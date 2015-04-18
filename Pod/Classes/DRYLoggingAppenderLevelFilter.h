//
//  DRYLoggingAppenderLevelFilter.h
//  Pods
//
//  Created by Michael Seghers on 17/04/15.
//
//

#import <Foundation/Foundation.h>
#import <DRYLogging/DRYLogger.h>
#import <DRYLogging/DRYLoggingAppenderFilter.h>
#import "DRYLoggingAppenderFilter.h"
#import "DRYLogger.h"

@class DRYLoggingMessage;

/**
 *  DRYLoggingAppenderFilter implementation, matching a DRYLoggingMessage's level and it's own level to 
 *  make a decission, based on whether an exact match is required or not.
 *
 *  When an exact match is required, only message with the same level as this filter's level will result 
 *  in the matchDecission DRYLoggingAppenderFilterDecission. The following table will clarify the 
 *  decission results when an exact match is not required. MD stands for matchDecission, NMD stands for 
 *  noMatchDecission.
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
 *  @since 1.1
 */
@interface DRYLoggingAppenderLevelFilter : NSObject<DRYLoggingAppenderFilter>

/**
 *  The level to use when deciding to accept a message or not. The default is DRYLogLevelTrace.
 */
@property(nonatomic) DRYLogLevel level;

/**
 *  Flag to indicate if this filter should do an exact match on the level or not. The default is YES.
 */
@property(nonatomic) BOOL exactMatchRequired;

/**
 *  The result returned by decide: when the filter finds matching levels. The default is DRYLoggingAppenderFilterDecissionAccept.
 */
@property(nonatomic) DRYLoggingAppenderFilterDecission matchDecission;

/**
 *  The result returned by decide: when the filter finds non-matching levels. The default is DRYLoggingAppenderFilterDecissionDeny.
 */
@property(nonatomic) DRYLoggingAppenderFilterDecission noMatchDecission;

/**
 *  Class factory method, initializing a level filter with all of its properties.
 *
 *  @see initWithLevel:exactMatchRequired:matchDecission:noMatchDecission:
 */
+ (instancetype)filterWithLevel:(DRYLogLevel)level exactMatchRequired:(BOOL)exactMatchRequired matchDecission:(DRYLoggingAppenderFilterDecission)matchDecission noMatchDecission:(DRYLoggingAppenderFilterDecission)noMatchDecission;

/**
 *  Convenience initializer, setting all properties to their defaults.
 */
- (instancetype)init;

/**
 *  Designated initializer, initializing a level filter with all of its properties.
 */
- (instancetype)initWithLevel:(DRYLogLevel)level exactMatchRequired:(BOOL)exactMatchRequired matchDecission:(DRYLoggingAppenderFilterDecission)matchDecission noMatchDecission:(DRYLoggingAppenderFilterDecission)noMatchDecission NS_DESIGNATED_INITIALIZER;

@end
