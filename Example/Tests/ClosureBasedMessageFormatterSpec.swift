//
//  ClosureBasedMessageFormatterSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 14/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DRYLogging

class ClosureBasedMessageFormatterSpec : QuickSpec {
    override func spec() {
        describe("ClosureBasedMessageFormatter") {
            context("") {
                var formatter:ClosureBasedMessageFormatter!
                var message:LoggingMessage!
                
                beforeEach {
                    formatter = ClosureBasedMessageFormatter {
                        message = $0
                        return "formatted"
                    }
                }
                
                it("should send the logging message to the closure") {
                    let msg = LoggingMessage(message: "message", level: .trace, loggerName: "name", framework: "DRYLogging", className: "classname", fileName: "file", methodName: "function", memoryAddress: "memadd", byteOffset: "bo", threadName: "main", lineNumber: 0, date: Date())
                    _ = formatter.format(msg)
                    expect(message) == msg
                }
                
                it("should return the value returned by the closure") {
                    let msg = LoggingMessage(message: "message", level: .trace, loggerName: "name", framework: "DRYLogging", className: "classname", fileName: "file", methodName: "function", memoryAddress: "memadd", byteOffset: "bo", threadName: "main", lineNumber: 0, date: Date())
                    let result = formatter.format(msg)
                    expect(result) == "formatted"
                }
            }
        }
    }
}
