//
//  DRYLoggingMessageFormatter.h
//  Pods
//
//  Created by Michael Seghers on 12/04/15.
//
//

#import <Foundation/Foundation.h>

@class DRYLoggingMessage;

/**
 *  A message formatter transforms a DRYLoggingMessage into an NSString.
 *
 *  Message formatters are used by DRYLoggingAppender implementations.
 */
@protocol DRYLoggingMessageFormatter <NSObject>

/**
*  Transforms the given message into a string
*
*  @param message the message that should be transformed into a string
*  
*  @return a formatted string, based on the given message
*
*  @since 1.0
*/
- (NSString *)format:(DRYLoggingMessage *)message;

@end
