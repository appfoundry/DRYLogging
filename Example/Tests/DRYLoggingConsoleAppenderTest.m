//
//  DRYLoggingConsoleAppenderTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 12/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import "DRYLoggingConsoleAppender.h"
#import "DRYLoggingMessageFormatter.h"
#import "DRYLoggingMessage.h"
#import "DRYLoggingAppenderFilter.h"

@interface DRYLoggingConsoleAppenderTest : XCTestCase {
    DRYLoggingConsoleAppender *_appender;
    id <DRYLoggingMessageFormatter> _formatter;
    id <DRYLoggingAppenderFilter> _filter;
}

@end

@implementation DRYLoggingConsoleAppenderTest

- (void)setUp {
    [super setUp];
    _formatter = mockProtocol(@protocol(DRYLoggingMessageFormatter));
    _filter = mockProtocol(@protocol(DRYLoggingAppenderFilter));
    _appender = [DRYLoggingConsoleAppender appenderWithFormatter:_formatter];
}

- (void)testAppenderShouldCallFormatter {
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil];
    [_appender append:message];
    [MKTVerify(_formatter) format:message];
}

- (void)testAppenderShouldCheckFilter {
    [_appender addFilter:_filter];
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil];
    [_appender append:message];
    [MKTVerify(_filter) decide:message];
}

- (void)testAppenderShouldNotAppendWhenFilterIsDeny {
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil];
    [given([_filter decide:message]) willReturnInteger:DRYLoggingAppenderFilterDecissionDeny];
    [_appender addFilter:_filter];
    [_appender append:message];
    [MKTVerifyCount(_formatter, never()) format:message];
}

- (void)testAppenderShouldNotAppendWhenAnyFilterIsDeny {
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil];
    [[given([_filter decide:message]) willReturnInteger:DRYLoggingAppenderFilterDecissionNeutral] willReturnInteger:DRYLoggingAppenderFilterDecissionDeny];
    [_appender addFilter:_filter];
    [_appender addFilter:_filter];
    [_appender append:message];
    [MKTVerifyCount(_formatter, never()) format:message];
}

- (void)testAppenderShouldNotTryAnyOtherFiltersWhenFilterReturnsAccept {
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil];
    [given([_filter decide:message]) willReturnInteger:DRYLoggingAppenderFilterDecissionAccept];
    [_appender addFilter:_filter];
    [_appender addFilter:_filter];
    [_appender append:message];
    [MKTVerifyCount(_filter, times(1)) decide:message];
}

- (void)testAppenderDoesNotCallFilterWhenItIsRemoved {
    [_appender addFilter:_filter];
    [_appender removeFilter:_filter];
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil];
    [_appender append:message];
    [MKTVerifyCount(_filter, never()) decide:message];

}


@end
