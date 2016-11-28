//
//  MessageFormatter.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation


/// A message formatter transforms a LoggingMessage into a String.
///
/// Message formatters are used by LoggingAppender implementations.
public protocol MessageFormatter {
    
    /// Transforms the given message into a string
    ///
    /// - parameter message: the message that should be transformed into a string
    ///
    /// - returns a formatted string, based on the given message
    ///
    /// - since: 3.0
    func format(_ message: LoggingMessage) -> String
}
