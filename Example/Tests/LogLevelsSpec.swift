//
//  LogLevelsSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 04/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DRYLogging

class LogLevelsSpec : QuickSpec {
    override func spec() {
        describe("when setting loglevel") {
            var logger:DefaultLogger!
            
            beforeEach {
                logger = DefaultLogger()
            }
            
            context("to trace") {
                beforeEach {
                    logger.logLevel = .trace
                }
                
                it("trace should be enabled") {
                    expect(logger.isTraceEnabled).to(beTruthy())
                }
                
                it("debug should be enabled") {
                    expect(logger.isDebugEnabled).to(beTruthy())
                }
                
                it("info should be enabled") {
                    expect(logger.isInfoEnabled).to(beTruthy())
                }
                
                it("warn should be enabled") {
                    expect(logger.isWarnEnabled).to(beTruthy())
                }
                
                it("error should be enabled") {
                    expect(logger.isErrorEnabled).to(beTruthy())
                }
            }
            
            context("to debug") {
                beforeEach {
                    logger.logLevel = .debug
                }
                
                it("trace should be disabled") {
                    expect(logger.isTraceEnabled).to(beFalse())
                }
                
                it("debug should be enabled") {
                    expect(logger.isDebugEnabled).to(beTruthy())
                }
                
                it("info should be enabled") {
                    expect(logger.isInfoEnabled).to(beTruthy())
                }
                
                it("warn should be enabled") {
                    expect(logger.isWarnEnabled).to(beTruthy())
                }
                
                it("error should be enabled") {
                    expect(logger.isErrorEnabled).to(beTruthy())
                }
            }
            
            context("to info") {
                beforeEach {
                    logger.logLevel = .info
                }
                
                it("trace should be disabled") {
                    expect(logger.isTraceEnabled).to(beFalse())
                }
                
                it("debug should be disabled") {
                    expect(logger.isDebugEnabled).to(beFalse())
                }
                
                it("info should be enabled") {
                    expect(logger.isInfoEnabled).to(beTruthy())
                }
                
                it("warn should be enabled") {
                    expect(logger.isWarnEnabled).to(beTruthy())
                }
                
                it("error should be enabled") {
                    expect(logger.isErrorEnabled).to(beTruthy())
                }
            }
            
            context("to warn") {
                beforeEach {
                    logger.logLevel = .warn
                }
                
                it("trace should be disabled") {
                    expect(logger.isTraceEnabled).to(beFalse())
                }
                
                it("debug should be disabled") {
                    expect(logger.isDebugEnabled).to(beFalse())
                }
                
                it("info should be disabled") {
                    expect(logger.isInfoEnabled).to(beFalse())
                }
                
                it("warn should be enabled") {
                    expect(logger.isWarnEnabled).to(beTruthy())
                }
                
                it("error should be enabled") {
                    expect(logger.isErrorEnabled).to(beTruthy())
                }
            }
            
            context("to error") {
                beforeEach {
                    logger.logLevel = .error
                }
                
                it("trace should be disabled") {
                    expect(logger.isTraceEnabled).to(beFalse())
                }
                
                it("debug should be disabled") {
                    expect(logger.isDebugEnabled).to(beFalse())
                }
                
                it("info should be disabled") {
                    expect(logger.isInfoEnabled).to(beFalse())
                }
                
                it("warn should be disabled") {
                    expect(logger.isWarnEnabled).to(beFalse())
                }
                
                it("error should be enabled") {
                    expect(logger.isErrorEnabled).to(beTruthy())
                }
            }
            
            context("to off") {
                beforeEach {
                    logger.logLevel = .off
                }
                
                it("trace should be disabled") {
                    expect(logger.isTraceEnabled).to(beFalse())
                }
                
                it("debug should be disabled") {
                    expect(logger.isDebugEnabled).to(beFalse())
                }
                
                it("info should be disabled") {
                    expect(logger.isInfoEnabled).to(beFalse())
                }
                
                it("warn should be disabled") {
                    expect(logger.isWarnEnabled).to(beFalse())
                }
                
                it("error should be disabled") {
                    expect(logger.isErrorEnabled).to(beFalse())
                }
            }
        }
        
    }
}
