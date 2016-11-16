//
//  LoggerFactorySpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 15/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DRYLogging

class LoggerFactorySpec : QuickSpec {
    override func spec() {
        describe("LoggerFactory") {
            var factory : LoggerFactory!
            var logger:Logger!
            
            beforeEach {
                factory = LoggerFactory.shared()
            }
            
            context("singleton creation") {
                it("should not be nil") {
                    expect(factory).toNot(beNil())
                }
                
                it("should always be the same instance being returned") {
                    expect(factory) === LoggerFactory.shared()
                }
            }
            
            context("root logger") {
                var logger:Logger!
                
                beforeEach {
                    logger = factory.rootLogger
                }
                
                it("should have name root") {
                    expect(logger.name) == "root"
                }
                
                it("should have log level info") {
                    expect(logger.logLevel) == LogLevel.info
                }
                
                it("should also be available statically") {
                    expect(LoggerFactory.rootLogger) === logger
                }
            }
            
            context("leaf logger name") {
                beforeEach {
                    logger = factory.logger(named: "logger")
                }
                
                it("should have the given name") {
                    expect(logger.name) == "logger"
                }
                
                it("should have the rootlogger as parent") {
                    expect(logger.parent!.name) == "root"
                }
                
                it("should have log level off") {
                    expect(logger.logLevel) == LogLevel.off
                }
                
                it("should always return the same instance") {
                    expect(logger) === factory.logger(named: "logger")
                }
                
                it("should also return the same logger when asking for logger statically") {
                    expect(logger) === LoggerFactory.logger(named: "logger")
                }
            }
            
            context("nested logger name") {
                beforeEach {
                    logger = factory.logger(named: "logger.child.grandchild")
                }
                
                it("should have the expected hierarchy") {
                    expect(logger.parent) === factory.logger(named: "logger.child")
                    expect(logger.parent?.parent) === factory.logger(named: "logger")
                }
            }
        }
    }
}
