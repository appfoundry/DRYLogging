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
    _message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil lineNumber:0 date:nil];
}

- (void)testDRYLoggingConsoleAppenderHasImplementationForAppendAcceptedAndFormattedMessage {
    XCTAssertNoThrow([_appender appendAcceptedAndFormattedMessage:@""]);
}


@end
