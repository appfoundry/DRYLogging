//
//  ConsoleAppenderSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 14/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import DRYLogging

class ConsoleAppenderSpec : QuickSpec {
    override func spec() {
        describe("ConsoleAppender") {
            var appender:ConsoleAppender!
            var messageFormatter:MessageFormatterMock!
            
            context("appending messages") {
                beforeEach {
                    messageFormatter = MessageFormatterMock(expectedMessage: "formatted")
                    appender = ConsoleAppender(formatter: messageFormatter)
                }
                
                it("should not throw when logging") {
                    let message = LoggingMessage(message: "message", level: .trace, loggerName: "name", framework: "DRYLogging", className: "classname", fileName: "file", methodName: "function", memoryAddress: "memadd", byteOffset: "bo", threadName: "main", lineNumber: 0, date: Date())
                    expect(appender.append(message: message)).toNot(throwError())
                }
                
                it("should use the given formatter") {
                    let message = LoggingMessage(message: "message", level: .trace, loggerName: "name", framework: "DRYLogging", className: "classname", fileName: "file", methodName: "function", memoryAddress: "memadd", byteOffset: "bo", threadName: "main", lineNumber: 0, date: Date())
                    appender.append(message: message)
                    expect(messageFormatter.recordedMessage) == message
                }
            }
        }
    }
}
