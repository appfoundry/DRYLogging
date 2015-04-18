//
//  DRYLoggingConsoleAppender.h
//  Pods
//
//  Created by Michael Seghers on 10/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLoggingAppender.h"

@protocol DRYLoggingMessageFormatter;

/**
 *  DRYLoggingAppender implementation that uses the console as its underlying system, through the use of NSLog. It will append DRYLoggingMessage instances to the console using a DRYLoggingMessageFormatter.
 *
 *  @since 1.0
 */
@interface DRYLoggingConsoleAppender : NSObject <DRYLoggingAppender>

/**
 *  Class factory method, initializing an appender with the given formatter.
 *
 *  @see initWithFormatter:
 */
+ (instancetype)appenderWithFormatter:(id<DRYLoggingMessageFormatter>)formatter;

/**
 *  Do not use this initializer, as it will throw an exception, because a formatter is missing.
 */
- (instancetype)init;

/**
 *  Designated initializer, initializing an appender with the given formatter.
 */
- (instancetype)initWithFormatter:(id<DRYLoggingMessageFormatter>)formatter NS_DESIGNATED_INITIALIZER;

@end
