//
//  ConsoleAppender.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

public class ConsoleAppender : BaseFormattingAppender {
    public private(set) var filters = [AppenderFilter]()
    public let formatter: MessageFormatter
    
    public init(formatter:MessageFormatter) {
        self.formatter = formatter
    }
    
    public func appendAcceptedAndFormattedMessage(_ formattedMessage: String!) {
        print(formattedMessage)
    }
    
    public func add(filter: AppenderFilter) {
        self.filters.append(filter)
    }
    
    public func remove(filter: AppenderFilter) {
        if let index = self.filters.index(where: { $0 === filter }) {
            self.filters.remove(at: index)
        }
    }
}
