//
//  LoggingRollerPredicate.swift
//  Pods
//
//  Created by Michael Seghers on 03/11/2016.
//
//

import Foundation

/// A roller predicate is responsible for telling a file appender when to roll its current file.
///
/// - since: 3.0
public protocol LoggingRollerPredicate {
    /// This method returns true when an appender should roll over the given file. It is up to a
    /// LoggingRoller to do the actual rolling.
    ///
    /// - parameter path: The path of the file for which rolling should be checked
    /// - returns true when an appender should roll over the given file
    func shouldRollFile(atPath: String) -> Bool
}
