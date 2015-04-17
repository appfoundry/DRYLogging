//
//  DRYLoggingAppender.h
//  Pods
//
//  Created by Michael Seghers on 10/04/15.
//
//

#import <Foundation/Foundation.h>

@class DRYLoggingMessage;
@protocol DRYLoggingAppenderFilter;

/**
 *  An appender is capable of appending DRYLoggingMessage instances to an underlying system, such as but not excluding:
 *
 *  * the console
 *  * the file system
 *  * a database
 *  * a remote service
 *  * ...
 *
 *  An appender has a collection of filters which allow to filter out message that it will or will not accept. This works 
 *  as follows:
 *
 *  *  When a filter decides to accept the message, the message is directly appended to the underlying system.
 *  *  When a filter decides to deny the message, the message will be ignored by this appender.
 *  *  When a filter is indecisive, the next filter in order will be consulted. If the last filter is indecisive, the message is treated as accepted.
 *
 *  The filters are consulted in the order in which they were added.  
 *
 *  @see DRYLoggingAppenderFilter
 *  @since 1.0
 */
@protocol DRYLoggingAppender <NSObject>

/**
 *  Append the message to the underlying system. How this is done is at the implementation's discression.
 *
 *  @param message the message to be appended to the underlying system.
 */
- (void)append:(DRYLoggingMessage *)message;

/**
 *  Adds a filter to this appender.
 *
 *  @param filter The filter to be added.
 *
 *  @since 1.1
 */
- (void)addFilter:(id<DRYLoggingAppenderFilter>)filter;

/**
 *  Removes a filter fromt this appender.
 *
 *  @param filter The filter to be removed.
 *
 *  @since 1.1
 */
- (void)removeFilter:(id <DRYLoggingAppenderFilter>)filter;


@end
