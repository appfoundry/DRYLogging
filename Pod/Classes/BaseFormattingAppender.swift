//
//  BaseFormattingAppender.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation


/// Abstract base class for logging appenders which format messages through a MessageFormatter.
///
/// - since: 3.0
public protocol BaseFormattingAppender: class, LoggingAppender {
    
    /// The filters that will be consulted do decide wether a message will be appended or not
    var filters: [AppenderFilter] { get set }
    
    /// The message formatter used to format a LoggingMessage to a String
    var formatter: MessageFormatter { get }
    
    /// Called when the append method has consulted the filters wheter or not
    /// to accept the message.
    ///
    /// - parameter acceptedAndFormattedMessage: The message which was formatted using the MessageFormatter
    func append(acceptedAndFormattedMessage: String)
}

extension BaseFormattingAppender {
    public func append(message: LoggingMessage) {
        if self.filterDecision(message: message) != .deny {
            self.append(acceptedAndFormattedMessage: self.formatter.format(message))
        }
    }
    
    /// Add an AppenderFilter to the formatting appender
    ///
    /// - parameter filter: The filter to be added
    public func add(filter: AppenderFilter) {
        self.filters.append(filter)
    }
    
    /// Remove an AppenderFilter from the formatting appender
    ///
    /// - parameter filter: The filter to be removed
    public func remove(filter: AppenderFilter) {
        if let index = self.filters.index(where: { $0 === filter }) {
            self.filters.remove(at: index)
        }
    }
    
    private func filterDecision(message: LoggingMessage) -> AppenderFilterDecission {
        var result: AppenderFilterDecission = .neutral
        for filter in self.filters {
            result = filter.decide(message)
            if (result != .neutral) {
                break
            }
        }
        return result
    }
}

