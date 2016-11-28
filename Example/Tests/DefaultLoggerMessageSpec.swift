//
//  DefaultLoggerMessageSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 15/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DRYLogging

class DefaultLoggerMessageSpec : QuickSpec {
    override func spec() {
        describe("LoggerFactory") {
            var logger:DefaultLogger!
            var appender:LoggingAppenderMock!
            
            beforeEach {
                logger = DefaultLogger()
                logger.logLevel = .warn
                appender = LoggingAppenderMock()
                logger.add(appender: appender)
            }
            
            context("in main thread") {
                var message:LoggingMessage!
                
                beforeEach {
                    logger.warn("my message")
                    message = appender.messages.first
                }

                it("should have main as threadName") {
                    expect(message.threadName) == "main"
                }
                
                it("should have line number 31") {
                    expect(message.lineNumber) == 31
                }
                
                it("should have test class as fileName") {
                    expect(message.fileName).to(endWith("DefaultLoggerMessageSpec.swift"))
                }
                
                it ("should have test module as framework") {
                    expect(message.framework) == "Tests"
                }
                
                it ("should have function name spec") {
                    expect(message.methodName) == "spec()"
                }
                
                it("should contain DefaultLoggerMessageSpec as class name") {
                    expect(message.className).to(contain("DefaultLoggerMessageSpec"))
                }
            }
            
            context("in custom thread") {
                it("should have custom name") {
                    
                    waitUntil { done in
                        let thread = CustomThreadForTest(logger: logger, action: done)
                        thread.name = "customName"
                        thread.start()
                    }
                    expect(appender.messages.first?.threadName) == "customName"
                }
                
                it("should have questionmarked name") {
                    waitUntil { done in
                        CustomThreadForTest(logger: logger, action: done).start()
                    }
                    expect(appender.messages.first?.threadName) == "???"
                }
            }
        }
    }
}

class CustomThreadForTest : Thread {
    let logger:Logger
    let action:() -> ()

    init(logger:Logger, action: @escaping () -> ()) {
        self.logger = logger
        self.action = action
    }
    
    override func main() {
        logger.warn("log from thread")
        self.action()
    }
}
