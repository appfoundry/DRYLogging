//
//  MessageFormatterMock.swift
//  DRYLogging
//
//  Created by Michael Seghers on 14/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import DRYLogging

class MessageFormatterMock : MessageFormatter {
    let expectedMessage:String
    private(set) var recordedMessage:LoggingMessage? = nil
    
    init(expectedMessage:String) {
        self.expectedMessage = expectedMessage
    }
    
    func format(_ message: LoggingMessage) -> String {
        self.recordedMessage = message
        return expectedMessage
    }
}
