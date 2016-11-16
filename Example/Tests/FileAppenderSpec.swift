//
//  FileAppenderSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 16/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import DRYLogging

class FileAppenderSpec : QuickSpec {
    override func spec() {
        describe("FileAppenderSpec") {
            var appender:FileAppender!
            var formatter:MessageFormatterMock!
            var path:String!
            
            beforeEach {
                formatter = MessageFormatterMock(expectedMessage: "test")
            }
            
            context("appending messages to given path") {
                var rollerPredicate:RollerPredicateMock!
                var roller:RollerMock!
                beforeEach {
                    rollerPredicate = RollerPredicateMock()
                    roller = RollerMock()
                    path = ((NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String])[0]).stringByAppendingPathComponent(path: "file.txt")
                    appender = FileAppender(formatter: formatter, filePath: path, rollerPredicate: rollerPredicate, roller: roller)
                }
                
                it("should append the formatterd message") {
                    appender.appendAcceptedAndFormattedMessage("message")
                    expect(self.contentsOfFile(atPath: path)).toEventually(equal("message\n"))
                }
                
                it("should append messages, not erase them") {
                    self.write(string: "existing content\n", toFile: path)
                    appender.appendAcceptedAndFormattedMessage("message")
                    expect(self.contentsOfFile(atPath: path)).toEventually(equal("existing content\nmessage\n"))
                }
                
                it("should call file roller when predicate says we should role") {
                    rollerPredicate.shouldRollFile = true
                    appender.appendAcceptedAndFormattedMessage("message")
                    expect(roller.rolledFile).toEventually(equal(path))
                }
                
                it("should have created a new empty file after rolling occured") {
                    self.write(string: "existing content\n", toFile: path)
                    rollerPredicate.shouldRollFile = true
                    appender.appendAcceptedAndFormattedMessage("message")
                    expect(self.contentsOfFile(atPath: path)).toEventually(equal(""))
                }
            }
            
            context("appending messages to default file") {
                beforeEach {
                    path = ((NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String])[0]).stringByAppendingPathComponent(path: "default.log")
                    appender = FileAppender(formatter: formatter)
                }
                
                it("should append the formatterd message") {
                    appender.appendAcceptedAndFormattedMessage("message")
                    expect(self.contentsOfFile(atPath: path)).toEventually(equal("message\n"))
                }
            }
            
            afterEach {
                guard let _ = try? FileManager.default.removeItem(atPath: path) else {
                    fail("Could not remove file")
                    return
                }
            }
        }
    }
    
    func contentsOfFile(atPath: String) -> String? {
        return try? String(contentsOfFile: atPath)
    }
    
    func write(string:String, toFile:String) {
        do {
            try string.write(toFile: toFile, atomically: false, encoding: .utf8)
        } catch {
            fail("Could not write to file!")
        }
    }
}

class RollerPredicateMock : LoggingRollerPredicate {
    var shouldRollFile:Bool = false
    
    public func shouldRollFile(atPath: String) -> Bool {
        return shouldRollFile
    }
}

class RollerMock : LoggingRoller {
    private(set) var rolledFile:String?
    
    public func rollFile(atPath: String) {
        self.rolledFile = atPath
        try? FileManager.default.removeItem(atPath: atPath)
    }
}
