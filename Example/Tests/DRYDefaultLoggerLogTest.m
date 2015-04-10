//
//  DRYDefaultLoggerLogTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 10/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import "DRYDefaultLogger.h"
#import "DRYLoggingAppender.h"

@interface DRYDefaultLoggerLogTest : XCTestCase {
    DRYDefaultLogger *_logger;
    
    id<DRYLoggingAppender> _firstAppender;
}

@end

@implementation DRYDefaultLoggerLogTest

- (void)setUp {
    [super setUp];
    _firstAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger = [[DRYDefaultLogger alloc] initWithName:@"testlogger"];
    [_logger addAppender:_firstAppender];
    
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

- (void)testDebug_callsAppenderWhenDebugLevelIsEnabled {
    _logger.level = DRYLogLevelDebug;
    [_logger debug:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:@"Message %@", @"param"];
}

- (void)testDebug_callsExtreAddedAppenderWhenDebugLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelDebug;
    [_logger addAppender:secondAppender];
    [_logger debug:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:@"Message %@", @"param"];
}

- (void)testDebug_doesNotCallAppendersWhenDebugLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger debug:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, never()) append:anything()];
    
}



- (void)testInfo_callsAppenderWhenInfoLevelIsEnabled {
    _logger.level = DRYLogLevelInfo;
    [_logger info:@"Message %@", @"param"];
    [MKTVerify(_firstAppender) append:@"Message %@", @"param"];
    
}

- (void) testInfo_callsExtreAddedAppenderWhenInfoLevelIsEnabled {
    id<DRYLoggingAppender> secondAppender = mockProtocol(@protocol(DRYLoggingAppender));
    _logger.level = DRYLogLevelInfo;
    [_logger addAppender:secondAppender];
    [_logger info:@"Message %@", @"param"];
    [MKTVerify(secondAppender) append:@"Message %@", @"param"];
}

- (void)testInfo_doesNotCallAppendersWhenInfoLevelIsNotEnabled {
    _logger.level = DRYLogLevelOff;
    [_logger info:@"Message %@", @"param"];
    [MKTVerifyCount(_firstAppender, never()) append:anything()];
    
}

@end
