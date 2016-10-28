//
//  ClosureBasedMessageFormatter.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/**
 *  Closure based MessageFormatter implementation. This formatter delegates its work to
 *  a closure of type (LoggingMessage) -> String.
 *
 *  @since 1.0
 */
public struct ClosureBasedMessageFormatter : MessageFormatter {
    private let closure:(LoggingMessage) -> String
    
    public init(closure: @escaping (LoggingMessage) -> String) {
        self.closure = closure
    }
    
    public func format(_ message: LoggingMessage) -> String {
        return closure(message)
    }
}
