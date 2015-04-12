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

@interface DRYLoggingConsoleAppender () {
    id <DRYLoggingMessageFormatter> _formatter;
}
@end

@implementation DRYLoggingConsoleAppender

+ (instancetype)appenderWithFormatter:(id <DRYLoggingMessageFormatter>)formatter {
    return [[self alloc] initWithFormatter:formatter];
}

- (instancetype)initWithFormatter:(id <DRYLoggingMessageFormatter>)formatter {
    self = [super init];
    if (self) {
        _formatter = formatter;
    }
    return self;
}

- (void)append:(DRYLoggingMessage *)message {
    NSString *string = [_formatter format:message];
    NSLog(@"%@", string);
}

@end
