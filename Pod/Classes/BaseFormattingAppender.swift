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
public protocol BaseFormattingAppender : LoggingAppender {
    
    var filters:[AppenderFilter] { get }
    var formatter:MessageFormatter { get }
    
    /**
     *  Called when the append method has consulted the filters wheter or not
     *  to accept the message.
     *
     *  @param formattedMessage The message which was formatted using the DRYLoggingMessageFormatter
     */
    func appendAcceptedAndFormattedMessage(_ formattedMessage: String!)
}

extension BaseFormattingAppender {
    public func append(message: LoggingMessage) {
        if self.filterDecision(message: message) != .deny {
            self.appendAcceptedAndFormattedMessage(self.formatter.format(message))
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

