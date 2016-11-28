//
//  LoggingAppenderMock.swift
//  DRYLogging
//
//  Created by Michael Seghers on 15/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import DRYLogging

class LoggingAppenderMock : LoggingAppender {
    private(set) var filters = [AppenderFilter]()
    private(set) var messages = [LoggingMessage]()
    
    public func add(filter: AppenderFilter) {
        self.filters.append(filter)
    }
    
    public func remove(filter: AppenderFilter) {
        if let index = self.filters.index(where: { $0 === filter }) {
            self.filters.remove(at: index)
        }
    }

    public func append(message: LoggingMessage) {
        messages.append(message)
    }
}
