//
//  SizeRollerPredicateSpec.swift
//  DRYLogging
//
//  Created by Michael Seghers on 16/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import DRYLogging

class SizeLoggingRollerPredicateSpec : QuickSpec {
    override func spec() {
        describe("SizeLoggingRollerPredicate") {
            var predicate:SizeLoggingRollerPredicate!
            
            context("default init") {
                beforeEach {
                    predicate = SizeLoggingRollerPredicate()
                }
                
                it("should have a default size of 1MB") {
                    expect(predicate.maxSizeInBytes) == SizeLoggingRollerPredicate.ONE_MEGABYTE
                }
            }
            
            context("given a maximum file size of 5 bytes") {
                var path:String!
                
                beforeEach {
                    predicate = SizeLoggingRollerPredicate(maxSizeInBytes: 5)
                    path = ((NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String])[0]).stringByAppendingPathComponent(path: "file.txt")
                }
                
                it("should roll when the file size exceeds the configured maximum") {
                    try! "toobig".write(toFile: path, atomically: false, encoding: .utf8)
                    expect(predicate.shouldRollFile(atPath: path)) == true
                }
                
                it("should not roll when the file size is smaller then the configured maximum") {
                    try! "small".write(toFile: path, atomically: false, encoding: .utf8)
                    expect(predicate.shouldRollFile(atPath: path)) == false
                }
                
                afterEach {
                    guard let _ = try? FileManager.default.removeItem(atPath: path) else {
                        fail("Could not remove file")
                        return
                    }
                }
            }
        }
    }
}
