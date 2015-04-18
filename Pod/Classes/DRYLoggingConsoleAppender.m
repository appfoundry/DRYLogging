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

+ (instancetype)appenderWithFormatter:(id <DRYLoggingMessageFormatter>)formatter {
    return [[self alloc] initWithFormatter:formatter];
}

- (instancetype)init {
    return [self initWithFormatter:nil];
}

- (instancetype)initWithFormatter:(id <DRYLoggingMessageFormatter>)formatter {
    NSParameterAssert(formatter);
    self = [super init];
    if (self) {
        _formatter = formatter;
        _filters = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)append:(DRYLoggingMessage *)message {
    if ([self _filterDecissionForMessage:message] != DRYLoggingAppenderFilterDecissionDeny) {
        NSLog(@"%@", [_formatter format:message]);
    }
}

- (DRYLoggingAppenderFilterDecission)_filterDecissionForMessage:(DRYLoggingMessage *)message {
    DRYLoggingAppenderFilterDecission d = DRYLoggingAppenderFilterDecissionNeutral;
    for (id<DRYLoggingAppenderFilter> filter in self->_filters) {
        d = [filter decide:message];
        if (d != DRYLoggingAppenderFilterDecissionNeutral) {
            break;
        }
    }
    return d;
}

- (void)addFilter:(id<DRYLoggingAppenderFilter>)filter {
    [_filters addObject:filter];
}

- (void)removeFilter:(id <DRYLoggingAppenderFilter>)filter {
    [_filters removeObject:filter];
}
@end
