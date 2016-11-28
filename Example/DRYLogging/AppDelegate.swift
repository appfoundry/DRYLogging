//
//  AppDelegate.swift
//  DRYLogging
//
//  Created by Michael Seghers on 28/10/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import UIKit
import DRYLogging

/**
 Demo AppDelegate to show case logging of different levels. Make sure to activate the appropriate log level
 to see the messages appear on the console!
 
 Consult the DRYLogging documentation for more info!
 */

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    let logger = LoggerFactory.logger(named: "ui.appdelegate")
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        self.setupConsoleLogger()
        self.setupErrorLoggingFileLogger()
        
        //logger.logLevel = .trace
        
        logger.info("Application did finish launching, this message should be printed, as the AppDelegate logger inherits from the root logger, which by default has INFO level logging")
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String])[0]
        logger.info("You should be able to find the log file at\n\(path)/default.log")
        
        logger.trace("Example of a trace logging, but should not be visible in the logs, unless you uncomment the above line")
        logger.debug("Example of a debug logging, but should not be visible in the logs, unless you uncomment the above line")
        logger.warn("Example of a warn logging, should be visible in the logs")
        logger.error("Example of a error logging, should be visible in the logs")
        
        return true
    }
    
    func setupConsoleLogger() {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS"
        let formatter = ClosureBasedMessageFormatter(closure: {
            return "[\($0.level) - \(df.string(from: $0.date))] <T:\($0.threadName) - S:\($0.className) - M:\($0.methodName) - L:\($0.lineNumber)> - \($0.message)"
        })
        LoggerFactory.rootLogger.add(appender: ConsoleAppender(formatter: formatter))
    }
    
    func setupErrorLoggingFileLogger() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let formatter = ClosureBasedMessageFormatter {
            return "[\(df.string(from: $0.date))] <T:\($0.threadName) - S:\($0.className) - M:\($0.methodName) - L:\($0.lineNumber)> - \($0.message)"
        }
        let errorAppender = FileAppender(formatter: formatter)
        let filter = LevelAppenderFilter(level: .error, exactMatchRequired: true, matchDecission: .accept, noMatchDecission: .deny)
        errorAppender.add(filter: filter)
        LoggerFactory.rootLogger.add(appender: errorAppender)
    }
}
