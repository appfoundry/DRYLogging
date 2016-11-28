//
//  DefaultLoggerSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 08/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import DRYLogging

class MockAppender : LoggingAppender {
    var appendedMessages = [LoggingMessage]()
    
    func append(message:LoggingMessage) {
        appendedMessages.append(message)
    }
    
    func add(filter:AppenderFilter) {
        
    }
    
    func remove(filter:AppenderFilter) {
        
    }
}

class DeaultLoggerSpec : QuickSpec {
    override func spec() {
        describe("DefaultLogger") {
            var logger:DefaultLogger!
            
            context("Initialization without parameters") {
                beforeEach {
                    logger = DefaultLogger()
                }
                
                it("should set log level to off by default") {
                    expect(logger.logLevel) == LogLevel.off
                }
                
                it("should have root as name by default") {
                    expect(logger.name) == "root"
                }
                
                it("should have no parent by default") {
                    expect(logger.parent).to(beNil())
                }
            }
            
            context("Initialization with name") {
                beforeEach {
                    logger = DefaultLogger(name: "random")
                }
                
                it ("should set log level to off by default") {
                    expect(logger.logLevel) == LogLevel.off
                }
                
                it("should have the given name") {
                    expect(logger.name) == "random"
                }
                
                it("should have no parent by default") {
                    expect(logger.parent).to(beNil())
                }
            }
            
            context("Initialization with parent") {
                var parent:DefaultLogger!
                
                beforeEach {
                    parent = DefaultLogger()
                    logger = DefaultLogger(name: "random", parent: parent)
                }
                
                it("should have the given parent") {
                    expect(logger.parent) === parent
                }
            }
            
            context("should append a trace message when trace is enabled") {
                var appender:MockAppender!
                var message:LoggingMessage!
                
                beforeEach {
                    appender = MockAppender()
                    message = LoggingMessage(message: "message", level: .trace, loggerName: "name", framework: "Tests", className: "classname", fileName: "file", methodName: "function", memoryAddress: "memadd", byteOffset: "bo", threadName: "main", lineNumber: 0, date: Date())
                    logger = DefaultLogger(name: "name")
                    logger.logLevel = .trace
                    logger.add(appender: appender)
                }
                
                it("should add the given message") {
                    logger.trace("message", lineNumber: 0, function: "function", file: "file")
                    expect(appender.appendedMessages).to(haveMessageLike(message))
                }
                
                it("should add the given message to an added appender") {
                    let otherAppender = MockAppender()
                    logger.add(appender: otherAppender)
                    logger.trace("message", lineNumber: 0, function: "function", file: "file")
                    expect(otherAppender.appendedMessages).to(haveMessageLike(message))
                }
                
                it("should not have appended anything when log level is off") {
                    logger.logLevel = .off
                    logger.trace("message", lineNumber: 0, function: "function", file: "file")
                    expect(appender.appendedMessages).to(beEmpty())
                }
                
                it("should not call the appender when it has been removed") {
                    logger.remove(appender: appender)
                    logger.trace("message", lineNumber: 0, function: "function", file: "file")
                    expect(appender.appendedMessages).to(beEmpty())
                }
            }
        }
    }
}

public func haveMessageLike(_ expectedValue: LoggingMessage?) -> MatcherFunc<Array<LoggingMessage>?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "like <\(expectedValue)>"
        if let evaluated = try actualExpression.evaluate(), let actualValue = evaluated, let expectedValue = expectedValue {
            var result = false
            for recordedMessage in actualValue {
                if recordedMessage.message == expectedValue.message &&
                    recordedMessage.level == expectedValue.level &&
                    recordedMessage.loggerName == expectedValue.loggerName &&
                    recordedMessage.framework == expectedValue.framework &&
                    !recordedMessage.className.isEmpty &&
                    recordedMessage.methodName == expectedValue.methodName &&
                    recordedMessage.fileName == expectedValue.fileName &&
                    !recordedMessage.memoryAddress.isEmpty &&
                    !recordedMessage.byteOffset.isEmpty &&
                    recordedMessage.threadName == expectedValue.threadName &&
                    recordedMessage.lineNumber == expectedValue.lineNumber {
                    result = true
                    break
                }
            }
            return result
        } else {
            return false
        }
    }
}
