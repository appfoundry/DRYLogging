//
//  DRYLoggingConsoleAppenderTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 12/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DRYLoggingConsoleAppender.h"
#import "DRYLoggingMessageFormatter.h"
#import "DRYLoggingMessage.h"

@interface DRYLoggingConsoleAppenderTest : XCTestCase {
    DRYLoggingConsoleAppender *_appender;
    id <DRYLoggingMessageFormatter> _formatter;
}

@end

@implementation DRYLoggingConsoleAppenderTest

- (void)setUp {
    [super setUp];
    _formatter = mockProtocol(@protocol(DRYLoggingMessageFormatter));
    _appender = [DRYLoggingConsoleAppender appenderWithFormatter:_formatter];
}

- (void)testLoggerShouldCallFormatter {
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:nil loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil];
    [_appender append:message];
    [MKTVerify(_formatter) format:message];
}


@end
