//
//  LevelAppenderFilterTest.swift
//  DRYLogging
//
//  Created by Michael Seghers on 15/11/2016.
//  Copyright © 2016 Michael Seghers. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DRYLogging

class LevelAppenderFilterSpec : QuickSpec {
    override func spec() {
        describe("LevelAppenderFilter") {
            let parameters:[LogLevel : [LogLevel : [Bool : AppenderFilterDecission]]] =
                [.off :
                    [.off : [true : .accept, false : .accept],
                     .error : [true : .deny, false : .deny],
                     .warn : [true : .deny, false : .deny],
                     .info : [true : .deny, false : .deny],
                     .debug : [true : .deny, false : .deny],
                     .trace : [true : .deny, false : .deny]
                    ],
                 .error :
                    [.off : [true : .deny, false : .accept],
                     .error : [true : .accept, false : .accept],
                     .warn : [true : .deny, false : .deny],
                     .info : [true : .deny, false : .deny],
                     .debug : [true : .deny, false : .deny],
                     .trace : [true : .deny, false : .deny]
                    ],
                 .warn :
                    [.off : [true : .deny, false : .accept],
                     .error : [true : .deny, false : .accept],
                     .warn : [true : .accept, false : .accept],
                     .info : [true : .deny, false : .deny],
                     .debug : [true : .deny, false : .deny],
                     .trace : [true : .deny, false : .deny]
                    ],
                 .info :
                    [.off : [true : .deny, false : .accept],
                     .error : [true : .deny, false : .accept],
                     .warn : [true : .deny, false : .accept],
                     .info : [true : .accept, false : .accept],
                     .debug : [true : .deny, false : .deny],
                     .trace : [true : .deny, false : .deny]
                    ],
                 .debug :
                    [.off : [true : .deny, false : .accept],
                     .error : [true : .deny, false : .accept],
                     .warn : [true : .deny, false : .accept],
                     .info : [true : .deny, false : .accept],
                     .debug : [true : .accept, false : .accept],
                     .trace : [true : .deny, false : .deny]
                    ],
                 .trace :
                    [.off : [true : .deny, false : .accept],
                     .error : [true : .deny, false : .accept],
                     .warn : [true : .deny, false : .accept],
                     .info : [true : .deny, false : .accept],
                     .debug : [true : .deny, false : .accept],
                     .trace : [true : .accept, false : .accept]
                    ]
            ]
            
            
            for (filterLevel, filterExpectation) in parameters {
                for (messageLevel, matchToDecisionExpectation) in filterExpectation {
                    for (exactMatchRequired, expectedDecission) in matchToDecisionExpectation {
                        it("should result in \(expectedDecission) when filter level is \(filterLevel) and message level is \(messageLevel) when an exact match is\(exactMatchRequired ? " " : " not ")required") {
                            let filter = LevelAppenderFilter(level: filterLevel, exactMatchRequired: exactMatchRequired)
                            let message = LoggingMessage(message: "", level: messageLevel, loggerName: "", framework: "", className: "", fileName: "", methodName: "", memoryAddress: "", byteOffset: "", threadName: "", lineNumber: 0, date: Date())
                            expect(filter.decide(message)) == expectedDecission
                        }
                    }
                }
            }
        }
    }
}
