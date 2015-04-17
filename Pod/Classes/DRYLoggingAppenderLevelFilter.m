//
//  DRYLoggingAppenderLevelFilter.m
//  Pods
//
//  Created by Michael Seghers on 17/04/15.
//
//

#import <DRYLogging/DRYLoggingAppenderFilter.h>
#import <DRYLogging/DRYLogger.h>
#import "DRYLoggingAppenderLevelFilter.h"
#import "DRYLoggingMessage.h"


typedef BOOL (^DRYLoggingAppenderLevelFilterComparisonFunction)(DRYLoggingMessage *, DRYLogLevel);

@interface DRYLoggingAppenderLevelFilter () {
    DRYLoggingAppenderLevelFilterComparisonFunction _exactMatchComparison;
    DRYLoggingAppenderLevelFilterComparisonFunction _nonExactMatchComparison;
}
@end

@implementation DRYLoggingAppenderLevelFilter

+ (instancetype)filterWithLevel:(DRYLogLevel)level exactMatchRequired:(BOOL)exactMatchRequired matchDecission:(DRYLoggingAppenderFilterDecission)matchDecission noMatchDecission:(DRYLoggingAppenderFilterDecission)noMatchDecission {
    return [[self alloc] initWithLevel:level exactMatchRequired:exactMatchRequired matchDecission:matchDecission noMatchDecission:noMatchDecission];
}

- (instancetype)initWithLevel:(DRYLogLevel)level exactMatchRequired:(BOOL)exactMatchRequired matchDecission:(DRYLoggingAppenderFilterDecission)matchDecission noMatchDecission:(DRYLoggingAppenderFilterDecission)noMatchDecission {
    self = [super init];
    if (self) {
        _exactMatchComparison = ^BOOL(DRYLoggingMessage *message, DRYLogLevel level) {
            return message.level == level;
        };
        _nonExactMatchComparison = ^BOOL(DRYLoggingMessage *message, DRYLogLevel level) {
            return message.level >= level;
        };
        self.level = level;
        self.exactMatchRequired = exactMatchRequired;
        self.matchDecission = matchDecission;
        self.noMatchDecission = noMatchDecission;
    }

    return self;
}

- (instancetype)init {
    return [self initWithLevel:DRYLogLevelTrace exactMatchRequired:YES matchDecission:DRYLoggingAppenderFilterDecissionAccept noMatchDecission:DRYLoggingAppenderFilterDecissionDeny];
}

- (DRYLoggingAppenderFilterDecission)decide:(DRYLoggingMessage *)message {
    return [self _comparisonFunction](message, self.level) ? self.matchDecission : self.noMatchDecission;
}

- (DRYLoggingAppenderLevelFilterComparisonFunction)_comparisonFunction {
    return self.exactMatchRequired ? _exactMatchComparison : _nonExactMatchComparison;
}


@end
