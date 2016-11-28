//
//  ClosureBasedMessageFormatter.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/// Closure based MessageFormatter implementation. This formatter delegates its work to
/// a closure of type ```(LoggingMessage) -> String```.
///
/// - since: 3.0
public struct ClosureBasedMessageFormatter: MessageFormatter {
    private let closure: (LoggingMessage) -> String
    
    /// Designated initializer, setting the message formatting closure
    public init(closure: @escaping (LoggingMessage) -> String) {
        self.closure = closure
    }
    
    /// Passes the message to the closure and returns the closure's result
    public func format(_ message: LoggingMessage) -> String {
        return closure(message)
    }
}
