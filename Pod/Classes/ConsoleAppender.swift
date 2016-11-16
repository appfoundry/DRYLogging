//
//  ConsoleAppender.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

public class ConsoleAppender : BaseFormattingAppender {
    public var filters = [AppenderFilter]()
    public let formatter: MessageFormatter
    
    public init(formatter:MessageFormatter) {
        self.formatter = formatter
    }
    
    public func appendAcceptedAndFormattedMessage(_ formattedMessage: String) {
        print(formattedMessage)
    }
}
