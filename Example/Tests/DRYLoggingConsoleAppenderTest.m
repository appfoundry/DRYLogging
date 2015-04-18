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
    DRYLoggingMessage *_message;
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
    _message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil lineNumber:0];
}

- (void)testAppenderShouldCallFormatter {
    [_appender append:_message];
    [MKTVerify(_formatter) format:_message];
}

- (void)testAppenderShouldCheckFilter {
    [_appender addFilter:_filter];
    [_appender append:_message];
    [MKTVerify(_filter) decide:_message];
}

- (void)testAppenderShouldNotAppendWhenFilterIsDeny {
    [given([_filter decide:_message]) willReturnInteger:DRYLoggingAppenderFilterDecissionDeny];
    [_appender addFilter:_filter];
    [_appender append:_message];
    [MKTVerifyCount(_formatter, never()) format:_message];
}

- (void)testAppenderShouldNotAppendWhenAnyFilterIsDeny {
    [[given([_filter decide:_message]) willReturnInteger:DRYLoggingAppenderFilterDecissionNeutral] willReturnInteger:DRYLoggingAppenderFilterDecissionDeny];
    [_appender addFilter:_filter];
    [_appender addFilter:_filter];
    [_appender append:_message];
    [MKTVerifyCount(_formatter, never()) format:_message];
}

- (void)testAppenderShouldNotTryAnyOtherFiltersWhenFilterReturnsAccept {
    [given([_filter decide:_message]) willReturnInteger:DRYLoggingAppenderFilterDecissionAccept];
    [_appender addFilter:_filter];
    [_appender addFilter:_filter];
    [_appender append:_message];
    [MKTVerifyCount(_filter, times(1)) decide:_message];
}

- (void)testAppenderDoesNotCallFilterWhenItIsRemoved {
    [_appender addFilter:_filter];
    [_appender removeFilter:_filter];
    [_appender append:_message];
    [MKTVerifyCount(_filter, never()) decide:_message];

}

- (void)testAppenderShouldNotBeAbleToCreateWithoutFormatter {
    XCTAssertThrows([[DRYLoggingConsoleAppender alloc] init]);
}


@end
