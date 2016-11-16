//
//  DRYDefaultLoggerThreadingTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 13/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import "DRYDefaultLogger.h"
#import "DRYLoggingAppender.h"


#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>


@interface DRYDefaultLoggerThreadingTest : XCTestCase {
    DRYDefaultLogger *_logger;
    id <DRYLoggingAppender> _appender;
}

@end

@implementation DRYDefaultLoggerThreadingTest

- (void)setUp {
    [super setUp];
    _logger = [[DRYDefaultLogger alloc] initWithName:@"test"];
    _logger.level = DRYLogLevelInfo;
    _appender = MKTMockProtocol(@protocol(DRYLoggingAppender));
    [_logger addAppender:_appender];
    
}

- (void)testLogMessageShouldGetThreadNameMainIfOnMainThread {
    [_logger info:@"Info"];
    [MKTVerify(_appender) append:HC_hasProperty(@"threadName", @"main")];
}
 
- (void)testLogMessageShouldGetThreadNameAsSpecifiedOnThread {
    XCTestExpectation *expectation = [super expectationWithDescription:@"ThreadExp"];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(inOtherThread:) object:expectation];
    thread.name = @"other";
    [thread start];
    [super waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {}];
    [MKTVerify(_appender) append:HC_hasProperty(@"threadName", @"other")];
}

- (void)testLogMessageShouldGetThreadNameFallingbackToQuestionMarks {
    XCTestExpectation *expectation = [super expectationWithDescription:@"ThreadExp"];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(inOtherThread:) object:expectation];
    [thread start];
    [super waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {}];
    [MKTVerify(_appender) append:HC_hasProperty(@"threadName", @"???")];
}


- (void)inOtherThread:(XCTestExpectation *)expectation {
    [_logger info:@"Info"];
    [expectation fulfill];
}


@end
