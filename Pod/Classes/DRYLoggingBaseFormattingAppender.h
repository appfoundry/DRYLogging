//
//  DRYLoggingBaseFormattingAppender.h
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLoggingAppender.h"

@protocol DRYLoggingMessageFormatter;

/**
 * Abstract base class for logging appenders which format messages through a DRYLoggingMessageFormatter.
 *
 * @since 1.1
 */
@interface DRYLoggingBaseFormattingAppender : NSObject <DRYLoggingAppender>

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

/**
 *  Abstract method which will be called when the append: method has consulted the filters wheter or not 
 *  to accept the message. 
 *  
 *  Implementations must override this method. It should not call its super neither.
 *
 *  @param formattedMessage The message which was formatted using the DRYLoggingMessageFormatter
 */
- (void)appendAcceptedAndFormattedMessage:(NSString *)formattedMessage;

@end
