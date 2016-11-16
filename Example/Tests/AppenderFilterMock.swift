//
//  AppenderFilterMock.swift
//  DRYLogging
//
//  Created by Michael Seghers on 16/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import DRYLogging

class AppenderFilterMock : AppenderFilter {
    var decisionResult:AppenderFilterDecission
    var recordedMessage:LoggingMessage?
    
    init(decisionResult:AppenderFilterDecission = .neutral) {
        self.decisionResult = decisionResult
    }
    
    public func decide(_ message: LoggingMessage) -> AppenderFilterDecission {
        recordedMessage = message
        return decisionResult
    }

    
}
