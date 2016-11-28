//
//  ConsoleAppender.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/// A formatting appender, appending messages to the system console
public class ConsoleAppender : BaseFormattingAppender {
    /// - seealso: BaseFormattingAppender
    public var filters = [AppenderFilter]()
    
    /// - seealso: BaseFormattingAppender
    public let formatter: MessageFormatter
    
    /// Designated initializer, setting the message formatter
    public init(formatter: MessageFormatter) {
        self.formatter = formatter
    }
    
    public func append(acceptedAndFormattedMessage formattedMessage: String) {
        print(formattedMessage)
    }
}
