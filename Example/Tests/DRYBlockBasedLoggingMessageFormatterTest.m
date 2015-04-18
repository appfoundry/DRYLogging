//
//  DRYBlockBasedLoggingMessageFormatterTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 12/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import "DRYLoggingMessageFormatter.h"
#import "DRYBlockBasedLoggingMessageFormatter.h"
#import "DRYLoggingMessage.h"
#import "DRYLogger.h"

@interface DRYBlockBasedLoggingMessageFormatterTest : XCTestCase {
    DRYBlockBasedLoggingMessageFormatter *_formatter;
}

@end

@implementation DRYBlockBasedLoggingMessageFormatterTest

- (void)setUp {
    [super setUp];
    _formatter = [[DRYBlockBasedLoggingMessageFormatter alloc] initWithFormatterBlock:^(DRYLoggingMessage *message){
        return [NSString stringWithFormat:@"[%@] %@", message.className, message.message];
    }];
}

- (void)testFormatterReturnsResultFromBlock {
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:@"message" level:DRYLogLevelDebug loggerName:@"logger" framework:@"framework" className:@"classname" methodName:@"method" memoryAddress:@"mem" byteOffset:@"byte" threadName:@"threadName" lineNumber:0];
    NSString *string = [_formatter format:message];
    assertThat(string, is(equalTo(@"[classname] message")));
}

- (void)testInitializingWithoutBlockFails {
    XCTAssertThrows([[DRYBlockBasedLoggingMessageFormatter alloc] init]);
}


@end
