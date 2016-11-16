//
//  LevelAppenderFilter.swift
//  Pods
//
//  Created by Michael Seghers on 29/10/2016.
//
//

import Foundation

/**
 *  AppenderFilter implementation, matching a LoggingMessage's level and its own level to
 *  make a decission, based on whether an exact match is required or not.
 *
 *  When an exact match is required, only message with the same level as this filter's level will result
 *  in the AppenderFilterDecission given by the matchDecission property. The following table will clarify the
 *  decission results when an exact match is not required. MD stands for matchDecission, NMD stands for noMatchDecission.
 *
 *  ----------------------------------------------------------------------
 *  | Filter level / Message level | TRACE | DEBUG | INFO | WARN | ERROR |
 *  ----------------------------------------------------------------------
 *  |           TRACE              |   MD  |   MD  |  MD  |  MD  |   MD  |
 *  ----------------------------------------------------------------------
 *  |           DEBUG              |  NMD  |   MD  |  MD  |  MD  |   MD  |
 *  ----------------------------------------------------------------------
 *  |           INFO               |  NMD  |  NMD  |  MD  |  MD  |   MD  |
 *  ----------------------------------------------------------------------
 *  |           WARN               |  NMD  |  NMD  |  NMD |  MD  |   MD  |
 *  ----------------------------------------------------------------------
 *  |           ERROR              |  NMD  |  NMD  |  NMD |  NMD |   MD  |
 *  ----------------------------------------------------------------------
 *  |            OFF               |  NMD  |  NMD  |  NMD |  NMD |  NMD  |
 *  ----------------------------------------------------------------------
 *
 *  @since 3.0
 */
public class LevelAppenderFilter : AppenderFilter {
    /**
     *  The level to use when deciding to accept a message or not. The default is DRYLogLevelTrace.
     */
    public let level: LogLevel
    
    
    /**
     *  Flag to indicate if this filter should do an exact match on the level or not. The default is YES.
     */
    public let exactMatchRequired: Bool
    
    
    /**
     *  The result returned by decide: when the filter finds matching levels. The default is DRYLoggingAppenderFilterDecissionAccept.
     */
    public let matchDecission: AppenderFilterDecission
    
    
    /**
     *  The result returned by decide: when the filter finds non-matching levels. The default is DRYLoggingAppenderFilterDecissionDeny.
     */
    public let noMatchDecission: AppenderFilterDecission
    
    /**
     *  Designated initializer, initializing a level filter with all of its properties.
     *
     * @param level defaults to trace
     * @param exactMatchRequired defaults to true
     * @param matchDecission defaults to accept
     * @param noMatchDecission defaults to deny
     */
    public init(level: LogLevel = .trace, exactMatchRequired: Bool = true, matchDecission: AppenderFilterDecission = .accept, noMatchDecission: AppenderFilterDecission = .deny) {
        self.level = level
        self.exactMatchRequired = exactMatchRequired
        self.matchDecission = matchDecission
        self.noMatchDecission = noMatchDecission
    }
    
    public func decide(_ message: LoggingMessage) -> AppenderFilterDecission {
        if self.exactMatchRequired {
            return message.level == self.level ? matchDecission : noMatchDecission
        } else {
            return message.level >= self.level ? matchDecission : noMatchDecission
        }
    }
}
