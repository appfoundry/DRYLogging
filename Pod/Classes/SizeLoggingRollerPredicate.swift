//
//  SizeLoggingRollerPredicate.swift
//  Pods
//
//  Created by Michael Seghers on 03/11/2016.
//
//

import Foundation

/**
 *  Roller predicate which checks the file size against a configured value. If the file size
 *  exceeds the maxSizeInBytes, the predicte returns true. False otherwise.
 *
 *  @since 3.0
 */
public class SizeLoggingRollerPredicate : LoggingRollerPredicate {
    static let ONE_MEGABYTE:Int = 1048576
    let maxSizeInBytes:Int
    
    /**
     *  Designated initializer, initializing a predicate with the given maximum size in bytes.
     *
     *  @param maxSizeInBytes The maximum allowed file size in bytes.
     */
    public init(maxSizeInBytes:Int) {
        assert(maxSizeInBytes > 0, "You should specify a maxiumum byte size value bigger then 0!")
        self.maxSizeInBytes = maxSizeInBytes
    }
    
    /**
     *  Convenience initializer, setting the maximum size in bytes to 1 megabyte
     */
    public convenience init() {
        self.init(maxSizeInBytes: SizeLoggingRollerPredicate.ONE_MEGABYTE)
    }
    
    public func shouldRollFile(atPath path: String) -> Bool {
        let attr = try? FileManager.default.attributesOfItem(atPath: path)
        return ((attr?[FileAttributeKey.size] as? Int) ?? 0) > self.maxSizeInBytes
    }
}
