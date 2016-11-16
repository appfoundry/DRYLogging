//
//  BaseFormattingAppender.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation


/**
 * Abstract base class for logging appenders which format messages through a DRYLoggingMessageFormatter.
 *
 * @since 3.0
 */
public protocol BaseFormattingAppender : class, LoggingAppender {
    
    var filters:[AppenderFilter] { get set }
    var formatter:MessageFormatter { get }
    
    /**
     *  Called when the append method has consulted the filters wheter or not
     *  to accept the message.
     *
     *  @param formattedMessage The message which was formatted using the DRYLoggingMessageFormatter
     */
    func appendAcceptedAndFormattedMessage(_ formattedMessage: String)
}

extension BaseFormattingAppender {
    public func append(message: LoggingMessage) {
        if self.filterDecision(message: message) != .deny {
            self.appendAcceptedAndFormattedMessage(self.formatter.format(message))
        }
    }
    
    public func add(filter: AppenderFilter) {
        self.filters.append(filter)
    }
    
    public func remove(filter: AppenderFilter) {
        if let index = self.filters.index(where: { $0 === filter }) {
            self.filters.remove(at: index)
        }
    }
    
    private func filterDecision(message:LoggingMessage) -> AppenderFilterDecission {
        var result:AppenderFilterDecission = .neutral
        for filter in self.filters {
            result = filter.decide(message)
            if (result != .neutral) {
                break
            }
        }
        return result
    }
}

