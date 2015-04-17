//
//  DRYLoggingAppenderLevelFilterDecissionTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 17/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYTestUtilities/DRYParameterizedTestCase.h>
#import <DRYLogging/DRYLoggingAppenderFilter.h>
#import "DRYLoggingAppenderLevelFilter.h"
#import "DRYLoggingMessage.h"
#import "NSString+DRYLoggingLevelAdditions.h"

@interface DRYLoggingAppenderLevelFilterDecissionTest : DRYParameterizedTestCase {
    DRYLoggingAppenderLevelFilter *_filter;
}

@end

@interface FilterLevelTestParameter : NSObject<TestNameProvider>
@property (nonatomic) DRYLogLevel filterLevel;
@property (nonatomic) DRYLogLevel messageLevel;
@property (nonatomic) BOOL exactMatchRequired;
@property (nonatomic) DRYLoggingAppenderFilterDecission expectedDecission;

- (instancetype)initWithFilterLevel:(DRYLogLevel)filterLevel messageLevel:(DRYLogLevel)messageLevel exactMatchRequired:(BOOL)exactMatchRequired expectedDecission:(DRYLoggingAppenderFilterDecission)expectedDecission;

+ (instancetype)parameterWithFilterLevel:(DRYLogLevel)filterLevel messageLevel:(DRYLogLevel)messageLevel exactMatchRequired:(BOOL)exactMatchRequired expectedDecission:(DRYLoggingAppenderFilterDecission)expectedDecission;


@end

@implementation DRYLoggingAppenderLevelFilterDecissionTest

- (void)setUp {
    [super setUp];
    _filter = [[DRYLoggingAppenderLevelFilter alloc] init];
}

+ (NSArray *)parameters {
    return @[
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelTrace exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelDebug exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelInfo exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelWarn exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelError exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelOff exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelTrace exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelDebug exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelInfo exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelWarn exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelError exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelOff exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelTrace exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelDebug exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelInfo exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelWarn exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelError exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelOff exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelTrace exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelDebug exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelInfo exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelWarn exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelError exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelOff exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelTrace exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelDebug exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelInfo exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelWarn exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelError exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelOff exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelTrace exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelDebug exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelInfo exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelWarn exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelError exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelOff exactMatchRequired:NO expectedDecission:DRYLoggingAppenderFilterDecissionAccept],






            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelTrace exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelDebug exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelInfo exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelWarn exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelError exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelTrace messageLevel:DRYLogLevelOff exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelTrace exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelDebug exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelInfo exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelWarn exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelError exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelDebug messageLevel:DRYLogLevelOff exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelTrace exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelDebug exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelInfo exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelWarn exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelError exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelInfo messageLevel:DRYLogLevelOff exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelTrace exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelDebug exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelInfo exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelWarn exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelError exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelWarn messageLevel:DRYLogLevelOff exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelTrace exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelDebug exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelInfo exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelWarn exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelError exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelError messageLevel:DRYLogLevelOff exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],

            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelTrace exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelDebug exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelInfo exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelWarn exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelError exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionDeny],
            [FilterLevelTestParameter parameterWithFilterLevel:DRYLogLevelOff messageLevel:DRYLogLevelOff exactMatchRequired:YES expectedDecission:DRYLoggingAppenderFilterDecissionAccept],
    ];
}



#pragma mark - Trace enabled
- (void)testWithParameter:(FilterLevelTestParameter *)parameter {
    _filter.level = parameter.filterLevel;
    _filter.exactMatchRequired = parameter.exactMatchRequired;

    DRYLoggingMessage *message = [[DRYLoggingMessage alloc] initWithMessage:nil level:parameter.messageLevel loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil lineNumber:0];
    DRYLoggingAppenderFilterDecission result = [_filter decide:message];
    assertThatInteger(result, is(equalToInteger(parameter.expectedDecission)));
}

@end

@implementation FilterLevelTestParameter
- (instancetype)initWithFilterLevel:(DRYLogLevel)filterLevel messageLevel:(DRYLogLevel)messageLevel exactMatchRequired:(BOOL)exactMatchRequired expectedDecission:(DRYLoggingAppenderFilterDecission)expectedDecission {
    self = [super init];
    if (self) {
        self.filterLevel = filterLevel;
        self.messageLevel = messageLevel;
        self.exactMatchRequired = exactMatchRequired;
        self.expectedDecission = expectedDecission;
    }

    return self;
}

+ (instancetype)parameterWithFilterLevel:(DRYLogLevel)filterLevel messageLevel:(DRYLogLevel)messageLevel exactMatchRequired:(BOOL)exactMatchRequired expectedDecission:(DRYLoggingAppenderFilterDecission)expectedDecission {
    return [[self alloc] initWithFilterLevel:filterLevel messageLevel:messageLevel exactMatchRequired:exactMatchRequired expectedDecission:expectedDecission];
}

- (NSString *)testName {
    NSString *filterLevelString= [NSString stringFromDRYLoggingLevel:self.filterLevel];
    NSString *messageLevelString = [NSString stringFromDRYLoggingLevel:self.messageLevel];
    NSString *shouldMatch = self.exactMatchRequired ? @"" : @"Not";
    NSString *decissionString;
    switch(self.expectedDecission) {
        case DRYLoggingAppenderFilterDecissionAccept:
            decissionString = @"ACCEPT";
            break;
        case DRYLoggingAppenderFilterDecissionNeutral:
            decissionString = @"NEUTRAL";
            break;
        case DRYLoggingAppenderFilterDecissionDeny:
            decissionString = @"DENY";
            break;
    }
    return [NSString stringWithFormat:@"test_filterShould%@_whenMessageLevelIsSetTo%@_andFilterLevelIs%@_andExactMatchIs%@Required", decissionString, messageLevelString, filterLevelString, shouldMatch];
}

@end
