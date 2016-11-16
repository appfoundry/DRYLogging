//
//  DefaultLoggerInheritanceSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 15/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DRYLogging

class DefaultLoggerInheritanceSpec : QuickSpec {
    override func spec() {
        describe("DefaultLogger Inheritance") {
            var child:DefaultLogger!
            var parent:DefaultLogger!
            var grandParent:DefaultLogger!
            
            beforeEach {
                grandParent = DefaultLogger(name: "grandparent")
                parent = DefaultLogger(name: "parent", parent: grandParent)
                child = DefaultLogger(name: "child", parent: parent)
            }
            
            context("logger hierarchy from grandParent to child") {
                it("child should inherit logLevel from parent") {
                    parent.logLevel = .info
                    expect(child.isInfoEnabled) == true
                }
                
                it("child should override parent logging level when set") {
                    parent.logLevel = .info
                    child.logLevel = .error
                    expect(child.isInfoEnabled) == false
                }
            }
            
            context("logger hierarchy with appenders") {
                var childAppender:LoggingAppenderMock!
                var parentAppender:LoggingAppenderMock!
                var grandParentAppender:LoggingAppenderMock!
                
                beforeEach {
                    child.logLevel = .info
                    
                    grandParentAppender = LoggingAppenderMock()
                    grandParent.add(appender: grandParentAppender)
                    
                    parentAppender = LoggingAppenderMock()
                    parent.add(appender: parentAppender)

                    childAppender = LoggingAppenderMock()
                    child.add(appender: childAppender)
                }
                
                it("should append the message to the parent appender") {
                    child.info("test")
                    expect(parentAppender.messages).to(haveCount(1))
                }
                
                it("should append the message to the parent appender") {
                    child.info("test")
                    expect(grandParentAppender.messages).to(haveCount(1))
                }
            }
        }
    }
}
