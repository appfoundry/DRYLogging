//
//  DRYDefaultLoggerLogTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 10/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLogging.h>
#import "DRYDefaultLogger.h"

#define __PREVIOUS_LINE__ __LINE__ - 1

@interface DRYDefaultLoggerLogTest : XCTestCase {
    DRYDefaultLogger *_logger;

    id<DRYLoggingAppender> _firstAppender;
    id _messageMatcher;
}

@end

@implementation DRYDefaultLoggerLogTest

- (void)setUp {
    [super setUp];
    _firstAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger = [[DRYDefaultLogger alloc] initWithName:@"testlogger"];
    [_logger addAppender:_firstAppender];
    _messageMatcher = allOf(hasProperty(@"date", is(notNilValue())), hasProperty(@"lineNumber", equalToInteger(0)), hasProperty(@"message", @"Message param"), hasProperty(@"loggerName", @"testlogger"), hasProperty(@"threadName", @"main"), hasProperty(@"framework", @"Tests"), hasProperty(@"className", @"DRYDefaultLoggerLogTest"), hasProperty(@"methodName", [self _testMethodName]), hasProperty(@"memoryAddress", notNilValue()), hasProperty(@"byteOffset", notNilValue()), hasProperty(@"level", anyOf(@(DRYLogLevelInfo), @(DRYLogLevelTrace), @(DRYLogLevelDebug), @(DRYLogLevelError), @(DRYLogLevelWarn), nil)), nil);
}

- (NSString *)_testMethodName {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"-\\[.* (.*)\\]" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *matches = [regex matchesInString:super.name options:0 range:NSMakeRange(0, super.name.length)];
    NSString *testMethod = [super.name substringWithRange:[matches[0] rangeAtIndex:1]];
    return testMethod;
}

- (void)testDefaultLogLevelIsOff {
    _logger = [[DRYDefaultLogger alloc] init];
    assertThatInteger(_logger.level, is(equalToInteger(DRYLogLevelOff)));
}

- (void)testInitReturnsRootLogger {
    _logger = [[DRYDefaultLogger alloc] init];
    assertThat(_logger.name, is(equalTo(@"root")));
}

- (void)testInitDoesNotAllowNilAsName {
    XCTAssertThrows([[DRYDefaultLogger alloc] initWithName:nil]);
}


- (void)testTrace_callsAppenderWhenTraceLevelIsEnabled {
    _logger.level = DRYLogLevelTrace;
    [_logger trace:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void)testTrace_callsExtreAddedAppenderWhenDebugLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelTrace;
    [_logger addAppender:secondAppender];
    [_logger trace:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testTrace_doesNotCallAppendersWhenDebugLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger trace:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, never()) append:anything()];
}

- (void)testTraceWithLineNumber {
    _logger.level = DRYLogLevelTrace;
    DRYTraceOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:allOf(hasProperty(@"lineNumber", equalToInteger(__PREVIOUS_LINE__)), hasProperty(@"level", equalToInteger(DRYLogLevelTrace)), nil)];
}

- (void)testDebug_callsAppenderWhenDebugLevelIsEnabled {
    _logger.level = DRYLogLevelDebug;
    [_logger debug:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void)testDebug_callsExtreAddedAppenderWhenDebugLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelDebug;
    [_logger addAppender:secondAppender];
    [_logger debug:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testDebug_doesNotCallAppendersWhenDebugLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger debug:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, never()) append:anything()];
}

- (void)testDebugWithLineNumber {
    _logger.level = DRYLogLevelDebug;
    DRYDebugOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:allOf(hasProperty(@"lineNumber", equalToInteger(__PREVIOUS_LINE__)), hasProperty(@"level", equalToInteger(DRYLogLevelDebug)), nil)];
}

- (void)testInfo_callsAppenderWhenInfoLevelIsEnabled {
    _logger.level = DRYLogLevelInfo;
    [_logger info:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void) testInfo_callsExtreAddedAppenderWhenInfoLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelInfo;
    [_logger addAppender:secondAppender];
    [_logger info:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testInfo_doesNotCallAppendersWhenInfoLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger info:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, never()) append:anything()];
}

- (void)testInfoWithLineNumber {
    _logger.level = DRYLogLevelInfo;
    DRYInfoOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:allOf(hasProperty(@"lineNumber", equalToInteger(__PREVIOUS_LINE__)), hasProperty(@"level", equalToInteger(DRYLogLevelInfo)), nil)];
}

- (void)testWarn_callsAppenderWhenWarnLevelIsEnabled {
    _logger.level = DRYLogLevelWarn;
    [_logger warn:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void) testWarn_callsExtreAddedAppenderWhenWarnLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelWarn;
    [_logger addAppender:secondAppender];
    [_logger warn:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testWarn_doesNotCallAppendersWhenWarnLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger warn:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, never()) append:anything()];
}

- (void)testWarnWithLineNumber {
    _logger.level = DRYLogLevelWarn;
    DRYWarnOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:allOf(hasProperty(@"lineNumber", equalToInteger(__PREVIOUS_LINE__)), hasProperty(@"level", equalToInteger(DRYLogLevelWarn)), nil)];
}


- (void)testError_callsAppenderWhenErrorLevelIsEnabled {
    _logger.level = DRYLogLevelError;
    [_logger error:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void) testError_callsExtreAddedAppenderWhenErrorLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelError;
    [_logger addAppender:secondAppender];
    [_logger error:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testError_doesNotCallAppendersWhenErrorLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger error:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, never()) append:anything()];
}

- (void)testErrorWithLineNumber {
    _logger.level = DRYLogLevelError;
    DRYErrorOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:allOf(hasProperty(@"lineNumber", equalToInteger(__PREVIOUS_LINE__)), hasProperty(@"level", equalToInteger(DRYLogLevelError)), nil)];
}

- (void)testTrace_stopsCallingAppenderWhenItIsRemoved {
    _logger.level = DRYLogLevelTrace;
    [_logger removeAppender:_firstAppender];
    [_logger trace:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, never()) append:anything()];
}

@end
