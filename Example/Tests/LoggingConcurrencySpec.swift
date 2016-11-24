//
//  LoggingConcurrencySpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 16/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import DRYLogging

class LoggingConcurrencySpec : QuickSpec {
    override func spec() {
        describe("logging concurrency checks") {
            let numberOfThreadsToSpawn = 20
            let numberOfMessagesToLog = 50
            var cachedRootAppenders:[LoggingAppender]!
            var documentPath:String!
            var path:String!
            var logger:Logger!
            var fileAppender:LoggingAppender!
            
            func spawnThreadsAndWait() {
                waitUntil(timeout: 100) { done in
                    var loggerThreads:[LoggerThread] = [];
                    for i in (0..<numberOfThreadsToSpawn) {
                        let thread = LoggerThread(name: "LoggerThread \(i)", numberOfMessagesToLog: numberOfMessagesToLog)
                        loggerThreads.append(thread)
                        thread.start()
                    }
                    
                    let waiter = WaiterThread(loggerThreads: loggerThreads, doneHandler: done)
                    waiter.start()
                }
            }
            
            beforeEach {
                cachedRootAppenders = LoggerFactory.rootLogger.appenders
                for appender in LoggerFactory.rootLogger.appenders {
                    LoggerFactory.rootLogger.remove(appender: appender)
                }
                
                documentPath = ((NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String])[0])
                path = documentPath.stringByAppendingPathComponent(path: "file.txt")
                logger = LoggerFactory.logger(named: "threadlogger")
                logger.logLevel = .info
            }
            
            context("spawn log thread without roller") {
                beforeEach {
                    let formatter = ClosureBasedMessageFormatter {
                        return "[\($0.date)] - [\($0.threadName)] \($0.message)"
                    }
                    fileAppender = FileAppender(formatter: formatter, filePath: path, rollerPredicate: SizeLoggingRollerPredicate(maxSizeInBytes: Int.max), roller: BackupRoller())
                    logger.add(appender: fileAppender)
                }
                
                it("should log the expected amount of log lines") {
                    spawnThreadsAndWait()
                    
                    let contents = try? String(contentsOfFile: path)
                    let lines = contents?.components(separatedBy: "\n")
                    let numberOfMessageTimesNumberOfThreadsPlusEmptyLine = numberOfThreadsToSpawn * numberOfMessagesToLog + 1
                    expect(lines?.count) == numberOfMessageTimesNumberOfThreadsPlusEmptyLine
                }
            }
            
            context("spawn log thread with fast roller") {
                beforeEach {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    let formatter = ClosureBasedMessageFormatter {
                        return "[\(dateFormatter.string(from: $0.date))] - [\($0.threadName)] \($0.message)"
                    }
                    fileAppender = FileAppender(formatter: formatter, filePath: path, rollerPredicate: SizeLoggingRollerPredicate(maxSizeInBytes: 100), roller: BackupRoller(maximumNumberOfFiles: 10))
                    logger.add(appender: fileAppender)
                }
                
                it("should have created the expected amount of files with the expected amount of lines in them") {
                    spawnThreadsAndWait()
                    for index in 1..<10 {
                        let filePath = documentPath.stringByAppendingPathComponent(path: "file\(index).txt")
                        let contents = try? String(contentsOfFile: filePath)
                        let lines = contents?.components(separatedBy: "\n")
                        expect(lines?.count) == 3
                    }
                }
            }
            
            afterEach {
                for appender in cachedRootAppenders {
                    LoggerFactory.rootLogger.add(appender: appender)
                }
                
                do {
                    let manager = FileManager.default
                    for filePath in try manager.contentsOfDirectory(atPath: documentPath) {
                        try manager.removeItem(atPath: documentPath.stringByAppendingPathComponent(path: filePath))
                    }
                } catch {
                    fail("could not remove files in document path \(documentPath): \(error)")
                }
                
                logger.remove(appender: fileAppender)
            }
        }
    }
}

class LoggerThread : Thread {
    let numberOfMessagesToLog:Int
    var done:Bool
    
    init(name: String, numberOfMessagesToLog: Int) {
        self.done = false
        self.numberOfMessagesToLog = numberOfMessagesToLog
        super.init()
        self.name = name
    }
    
    override func main() {
        let logger = LoggerFactory.logger(named: "threadlogger")
        for i in (0..<self.numberOfMessagesToLog) {
            logger.info("This is message \(i)")
            Thread.sleep(forTimeInterval: (Double(arc4random_uniform(10)) / 10))
        }
        done = true
    }
}

class WaiterThread : Thread {
    let loggerThreads:[LoggerThread]
    let doneHandler:() -> ()
    
    init(loggerThreads:[LoggerThread], doneHandler: @escaping () -> ()) {
        self.loggerThreads = loggerThreads
        self.doneHandler = doneHandler
    }
    
    override func main() {
        while !loggerThreads.reduce(true, {
            return $0 && $1.done
        }) {
            Thread.sleep(forTimeInterval: 0.5)
        }
        doneHandler()
    }
}
