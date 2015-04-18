//
//  DRYLoggingConsoleAppender.h
//  Pods
//
//  Created by Michael Seghers on 10/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLoggingBaseFormattingAppender.h"

/**
 *  DRYLoggingAppender implementation that uses the console as its underlying system, through the use of NSLog. It will append DRYLoggingMessage instances to the console using a DRYLoggingMessageFormatter.
 *
 *  @since 1.0
 */
@interface DRYLoggingConsoleAppender : DRYLoggingBaseFormattingAppender

@end
