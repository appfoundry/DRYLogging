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
    id _messageMatcherForBlock;
}

@end

@implementation DRYDefaultLoggerLogTest

- (void)setUp {
    [super setUp];
    _firstAppender = MKTMockProtocol(@protocol(DRYLoggingAppender));
    _logger = [[DRYDefaultLogger alloc] initWithName:@"testlogger"];
    [_logger addAppender:_firstAppender];
    _messageMatcher = HC_allOf(HC_hasProperty(@"date", HC_is(HC_notNilValue())), HC_hasProperty(@"lineNumber", HC_equalToInteger(0)), HC_hasProperty(@"message", @"Message param"), HC_hasProperty(@"loggerName", @"testlogger"), HC_hasProperty(@"threadName", @"main"), HC_hasProperty(@"framework", @"Tests"), HC_hasProperty(@"className", @"DRYDefaultLoggerLogTest"), HC_hasProperty(@"methodName", [self _testMethodName]), HC_hasProperty(@"memoryAddress", HC_notNilValue()), HC_hasProperty(@"byteOffset", HC_notNilValue()), HC_hasProperty(@"level", HC_anyOf(@(DRYLogLevelInfo), @(DRYLogLevelTrace), @(DRYLogLevelDebug), @(DRYLogLevelError), @(DRYLogLevelWarn), nil)), nil);
    _messageMatcherForBlock = HC_allOf(HC_hasProperty(@"date", HC_is(HC_notNilValue())), HC_hasProperty(@"lineNumber", HC_equalToInteger(0)), HC_hasProperty(@"message", @"Message param"), HC_hasProperty(@"loggerName", @"testlogger"), HC_hasProperty(@"threadName", @"main"), HC_hasProperty(@"framework", @"Tests"), HC_hasProperty(@"className", @"DRYDefaultLoggerLogTest"), HC_hasProperty(@"methodName", HC_allOf(HC_containsString([self _testMethodName]), HC_containsString(@"_block_invoke"), nil)), HC_hasProperty(@"memoryAddress", HC_notNilValue()), HC_hasProperty(@"byteOffset", HC_notNilValue()), HC_hasProperty(@"level", HC_anyOf(@(DRYLogLevelInfo), @(DRYLogLevelTrace), @(DRYLogLevelDebug), @(DRYLogLevelError), @(DRYLogLevelWarn), nil)), nil);

}

- (NSString *)_testMethodName {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"-\\[.* (.*)\\]" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *matches = [regex matchesInString:super.name options:0 range:NSMakeRange(0, super.name.length)];
    NSString *testMethod = [super.name substringWithRange:[matches[0] rangeAtIndex:1]];
    return testMethod;
}

- (void)testDefaultLogLevelIsOff {
    _logger = [[DRYDefaultLogger alloc] init];
    HC_assertThatInteger(_logger.level, HC_is(HC_equalToInteger(DRYLogLevelOff)));
}

- (void)testInitReturnsRootLogger {
    _logger = [[DRYDefaultLogger alloc] init];
    HC_assertThat(_logger.name, HC_is(HC_equalTo(@"root")));
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
    id<DRYLoggingAppender> secondAppender = MKTMockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelTrace;
    [_logger addAppender:secondAppender];
    [_logger trace:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testTrace_doesNotCallAppendersWhenDebugLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger trace:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, MKTNever()) append:HC_anything()];
}

- (void)testTraceWithLineNumber {
    _logger.level = DRYLogLevelTrace;
    DRYTraceOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:HC_allOf(HC_hasProperty(@"lineNumber", HC_equalToInteger(__PREVIOUS_LINE__)), HC_hasProperty(@"level", HC_equalToInteger(DRYLogLevelTrace)), nil)];
}

- (void)testDebug_callsAppenderWhenDebugLevelIsEnabled {
    _logger.level = DRYLogLevelDebug;
    [_logger debug:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void)testDebug_callsExtreAddedAppenderWhenDebugLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = MKTMockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelDebug;
    [_logger addAppender:secondAppender];
    [_logger debug:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testDebug_doesNotCallAppendersWhenDebugLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger debug:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, MKTNever()) append:HC_anything()];
}

- (void)testDebugWithLineNumber {
    _logger.level = DRYLogLevelDebug;
    DRYDebugOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:HC_allOf(HC_hasProperty(@"lineNumber", HC_equalToInteger(__PREVIOUS_LINE__)), HC_hasProperty(@"level", HC_equalToInteger(DRYLogLevelDebug)), nil)];
}

- (void)testInfo_callsAppenderWhenInfoLevelIsEnabled {
    _logger.level = DRYLogLevelInfo;
    [_logger info:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void) testInfo_callsExtreAddedAppenderWhenInfoLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = MKTMockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelInfo;
    [_logger addAppender:secondAppender];
    [_logger info:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testInfo_doesNotCallAppendersWhenInfoLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger info:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, MKTNever()) append:HC_anything()];
}

- (void)testInfoWithLineNumber {
    _logger.level = DRYLogLevelInfo;
    DRYInfoOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:HC_allOf(HC_hasProperty(@"lineNumber", HC_equalToInteger(__PREVIOUS_LINE__)), HC_hasProperty(@"level", HC_equalToInteger(DRYLogLevelInfo)), nil)];
}

- (void)testWarn_callsAppenderWhenWarnLevelIsEnabled {
    _logger.level = DRYLogLevelWarn;
    [_logger warn:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void) testWarn_callsExtreAddedAppenderWhenWarnLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = MKTMockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelWarn;
    [_logger addAppender:secondAppender];
    [_logger warn:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testWarn_doesNotCallAppendersWhenWarnLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger warn:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, MKTNever()) append:HC_anything()];
}

- (void)testWarnWithLineNumber {
    _logger.level = DRYLogLevelWarn;
    DRYWarnOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:HC_allOf(HC_hasProperty(@"lineNumber", HC_equalToInteger(__PREVIOUS_LINE__)), HC_hasProperty(@"level", HC_equalToInteger(DRYLogLevelWarn)), nil)];
}


- (void)testError_callsAppenderWhenErrorLevelIsEnabled {
    _logger.level = DRYLogLevelError;
    [_logger error:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:_messageMatcher];
}

- (void) testError_callsExtreAddedAppenderWhenErrorLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = MKTMockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelError;
    [_logger addAppender:secondAppender];
    [_logger error:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:_messageMatcher];
}

- (void)testError_doesNotCallAppendersWhenErrorLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger error:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, MKTNever()) append:HC_anything()];
}

- (void)testErrorWithLineNumber {
    _logger.level = DRYLogLevelError;
    DRYErrorOnLogger(_logger, @"format %@", @1);
    [MKTVerify(_firstAppender) append:HC_allOf(HC_hasProperty(@"lineNumber", HC_equalToInteger(__PREVIOUS_LINE__)), HC_hasProperty(@"level", HC_equalToInteger(DRYLogLevelError)), nil)];
}

- (void)testTrace_stopsCallingAppenderWhenItIsRemoved {
    _logger.level = DRYLogLevelTrace;
    [_logger removeAppender:_firstAppender];
    [_logger trace:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, MKTNever()) append:HC_anything()];
}

- (void)testLog_blockLoggingWorksAsExpected {
    _logger.level = DRYLogLevelError;
    void (^testBlock)() = ^void() {
            [_logger error:@"Message %@", @"param"];
    };
    testBlock();
    [MKTVerify(_firstAppender) append:_messageMatcherForBlock];
}

- (void)testLog_blockInBlockLoggingWorksAsExpected {
    _logger.level = DRYLogLevelError;
    void (^testBlock)() = ^void() {
        void (^innerBlock)() = ^void() {
            [_logger error:@"Message %@", @"param"];
        };
        innerBlock();
    };
    testBlock();
    [MKTVerify(_firstAppender) append:_messageMatcherForBlock];
}


@end
