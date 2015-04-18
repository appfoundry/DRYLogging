//
//  DRYLoggingConsoleAppender.m
//  Pods
//
//  Created by Michael Seghers on 10/04/15.
//
//

#import <DRYLogging/DRYLoggingMessageFormatter.h>
#import "DRYLoggingConsoleAppender.h"
#import "DRYLoggingMessage.h"
#import "DRYLoggingAppenderFilter.h"

@interface DRYLoggingConsoleAppender () {
    id <DRYLoggingMessageFormatter> _formatter;

    NSMutableArray *_filters;
}
@end

@implementation DRYLoggingConsoleAppender

- (void)appendAcceptedAndFormattedMessage:(NSString *)formattedMessage {
    NSLog(@"%@", formattedMessage);
}

@end
