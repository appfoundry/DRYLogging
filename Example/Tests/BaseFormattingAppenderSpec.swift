//
//  BaseFormattingAppenderSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 16/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import DRYLogging

class BaseFormattingAppenderSpec : QuickSpec {
    override func spec() {
        describe("BaseFormattingAppender") {
            var formatter:MessageFormatterMock!
            var appender:TestBaseFormattingAppender!
            var message:LoggingMessage!
            
            beforeEach {
                formatter = MessageFormatterMock(expectedMessage: "formatted message")
                appender = TestBaseFormattingAppender(formatter: formatter)
                message = LoggingMessage(message: "", level: .trace, loggerName: "", framework: "", className: "", fileName: "", methodName: "", memoryAddress: "", byteOffset: "", threadName: "", lineNumber: 0, date: Date())
            }
            
            context("appending messages") {
                it("should call the formatter") {
                    appender.append(message: message)
                    expect(formatter.recordedMessage) == message
                }
                
                it("should call appendAcceptedAndFormattedMessage with the result of the formatter") {
                    appender.append(message: message)
                    expect(appender.appendAcceptedAndFormattedMessage) == "formatted message"
                }
            }
            
            context("filtering") {
                var filter:AppenderFilterMock!
                
                beforeEach {
                    filter = AppenderFilterMock()
                    appender.add(filter: filter)
                }
                
                it("should consult the filter") {
                    appender.append(message: message)
                    expect(filter.recordedMessage) == message
                }
                
                it("should stop consulting the filter when it has been removed") {
                    appender.remove(filter: filter)
                    appender.append(message: message)
                    expect(filter.recordedMessage).to(beNil())
                }
                
                it("should append a message when the filter is neutral") {
                    appender.append(message: message)
                    expect(appender.appendAcceptedAndFormattedMessage) == "formatted message"
                }
                
                it("should not append a message when the filter denies") {
                    filter.decisionResult = .deny
                    appender.append(message: message)
                    expect(appender.appendAcceptedAndFormattedMessage).to(beNil())
                }
                
                it("should append a message when the filter accepts") {
                    filter.decisionResult = .accept
                    appender.append(message: message)
                    expect(appender.appendAcceptedAndFormattedMessage) == "formatted message"
                }
                
                it("should not append a message when first denying filter is hit") {
                    filter.decisionResult = .neutral
                    let denyingFilter = AppenderFilterMock(decisionResult: .deny)
                    appender.add(filter: denyingFilter)
                    appender.append(message: message)
                    expect(appender.appendAcceptedAndFormattedMessage).to(beNil())
                }
                
                it("should append a message when first accept filter is hit") {
                    filter.decisionResult = .accept
                    let denyingFilter = AppenderFilterMock()
                    appender.add(filter: denyingFilter)
                    appender.append(message: message)
                    expect(appender.appendAcceptedAndFormattedMessage) == "formatted message"
                }
            }
        }
    }
}

class TestBaseFormattingAppender : BaseFormattingAppender {
    public var formatter: MessageFormatter
    public var filters = [AppenderFilter]()
    var appendAcceptedAndFormattedMessage:String?
    
    init(formatter:MessageFormatter) {
        self.formatter = formatter
    }

    func append(acceptedAndFormattedMessage: String) {
        appendAcceptedAndFormattedMessage = acceptedAndFormattedMessage
    }
}
