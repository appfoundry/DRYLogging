//
//  DRYLoggingBaseFormattingAppenderTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 18/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import "DRYLoggingBaseFormattingAppender.h"
#import "DRYLoggingMessageFormatter.h"
#import "DRYLoggingMessage.h"
#import "DRYLoggingAppenderFilter.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface TestDRYLoggingBaseFormattingAppender : DRYLoggingBaseFormattingAppender

@property (nonatomic) NSString *messagePassedToAbstractMethodCall;

@end

@interface DRYLoggingBaseFormattingAppenderTest : XCTestCase {
    DRYLoggingBaseFormattingAppender *_appender;
    DRYLoggingMessage *_message;
    id <DRYLoggingMessageFormatter> _formatter;
    id <DRYLoggingAppenderFilter> _filter;
}


@end



@implementation DRYLoggingBaseFormattingAppenderTest

- (void)setUp {
    [super setUp];
    _formatter = MKTMockProtocol(@protocol(DRYLoggingMessageFormatter));
    _filter = MKTMockProtocol(@protocol(DRYLoggingAppenderFilter));
    _appender = [TestDRYLoggingBaseFormattingAppender appenderWithFormatter:_formatter];
    _message = [DRYLoggingMessage messageWithMessage:nil level:DRYLogLevelOff loggerName:nil framework:nil className:nil methodName:nil memoryAddress:nil byteOffset:nil threadName:nil lineNumber:0 date:nil];
}

- (void)testAppenderShouldCallFormatter {
    [_appender append:_message];
    [MKTVerify(_formatter) format:_message];
}

- (void)testAppenderCallsAbstractAppendAcceptedAndFormattedMessage {
    TestDRYLoggingBaseFormattingAppender *appender = [TestDRYLoggingBaseFormattingAppender appenderWithFormatter:_formatter];
    [MKTGiven([_formatter format:_message]) willReturn:@"test"];
    [appender append:_message];
    HC_assertThat(appender.messagePassedToAbstractMethodCall, HC_is(HC_equalTo(@"test")));
}

- (void)testAppendAcceptedAndFormattedMessageShouldFailForcingSubclassesToImplementIt {
    XCTAssertThrows([[DRYLoggingBaseFormattingAppender appenderWithFormatter:_formatter] appendAcceptedAndFormattedMessage:@""]);
}

- (void)testAppenderShouldCheckFilter {
    [_appender addFilter:_filter];
    [_appender append:_message];
    [MKTVerify(_filter) decide:_message];
}

- (void)testAppenderShouldNotAppendWhenFilterIsDeny {
    [MKTGiven([_filter decide:_message]) willReturnInteger:DRYLoggingAppenderFilterDecissionDeny];
    [_appender addFilter:_filter];
    [_appender append:_message];
    [MKTVerifyCount(_formatter, MKTNever()) format:_message];
}

- (void)testAppenderShouldNotAppendWhenAnyFilterIsDeny {
    [[MKTGiven([_filter decide:_message]) willReturnInteger:DRYLoggingAppenderFilterDecissionNeutral] willReturnInteger:DRYLoggingAppenderFilterDecissionDeny];
    [_appender addFilter:_filter];
    [_appender addFilter:_filter];
    [_appender append:_message];
    [MKTVerifyCount(_formatter, MKTNever()) format:_message];
}

- (void)testAppenderShouldNotTryAnyOtherFiltersWhenFilterReturnsAccept {
    [MKTGiven([_filter decide:_message]) willReturnInteger:DRYLoggingAppenderFilterDecissionAccept];
    [_appender addFilter:_filter];
    [_appender addFilter:_filter];
    [_appender append:_message];
    [MKTVerify(_filter) decide:_message];
}

- (void)testAppenderDoesNotCallFilterWhenItIsRemoved {
    [_appender addFilter:_filter];
    [_appender removeFilter:_filter];
    [_appender append:_message];
    [MKTVerifyCount(_filter, MKTNever()) decide:_message];
}

- (void)testAppenderShouldNotBeAbleToCreateWithoutFormatter {
    XCTAssertThrows([[DRYLoggingBaseFormattingAppender alloc] init]);
}

@end

@implementation TestDRYLoggingBaseFormattingAppender

- (void)appendAcceptedAndFormattedMessage:(NSString *)formattedMessage {
    self.messagePassedToAbstractMethodCall = formattedMessage;
}

@end
