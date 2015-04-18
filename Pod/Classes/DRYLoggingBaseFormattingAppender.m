//
//  DRYLoggingBaseFormattingAppender.m
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import "DRYLoggingBaseFormattingAppender.h"
#import "DRYLoggingAppenderFilter.h"
#import "DRYLoggingMessageFormatter.h"

@interface DRYLoggingBaseFormattingAppender () {
    id <DRYLoggingMessageFormatter> _formatter;

    NSMutableArray *_filters;
}
@end

@implementation DRYLoggingBaseFormattingAppender

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
        [self appendAcceptedAndFormattedMessage:[_formatter format:message]];
    }
}

- (void)appendAcceptedAndFormattedMessage:(NSString *)formattedMessage {
    [NSException raise:@"DRYLoggingAbstractAssumptionException" format:@"Impementations of %@ should override %@", [self class], NSStringFromSelector(_cmd)];
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
