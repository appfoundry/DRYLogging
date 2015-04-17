//
//  DRYLoggingAppenderFilter.h
//  Pods
//
//  Created by Michael Seghers on 17/04/15.
//
//

#import <Foundation/Foundation.h>

@class DRYLoggingMessage;

/**
 *  The result of a filter's decision on what to do with a message.
 *
 *  @since 1.1
 */
typedef NS_ENUM(NSInteger, DRYLoggingAppenderFilterDecission){
    /**
     *  Returned when the filter accepts the message.
     */
    DRYLoggingAppenderFilterDecissionAccept,
    /**
     *  Returned when the filter can not decide what to do with the message.
     */
    DRYLoggingAppenderFilterDecissionNeutral,
    /**
     *  Returned when the filter denies the message.
     */
    DRYLoggingAppenderFilterDecissionDeny
};

/**
 *  A filter, used by DRYLoggingAppender instances, to decide whether they should append a message to their underlying 
 *  system or not.
 *
 *  @since 1.1
 */
@protocol DRYLoggingAppenderFilter <NSObject>

/**
 *  When the message is accepted by this filter, returns DRYLoggingAppenderFilterDecissionAccept.
 *  When the filter cannot decide on what to do with the message, returns DRYLoggingAppenderFilterDecissionNeutral
 *  When the message is denied by this filter, returns DRYLoggingAppenderFilterDecissionDeny
 *
 *  @param message The message to make a decission for.
 */
- (DRYLoggingAppenderFilterDecission)decide:(DRYLoggingMessage *)message;

@end
