//
//  DRYLoggingFileAppenderTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 18/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLogging.h>

@interface BlockRollerPredicate : NSObject <DRYLoggingRollerPredicate>
@property(nonatomic) BOOL expectedAnswer;
@property(nonatomic, strong) void(^executeOnCall)(NSString *passedInFilePath);

@end

@interface BlockRoller : NSObject <DRYLoggingRoller>
@property(nonatomic, strong) void(^executeOnCall)(NSString *passedInFilePath);
@end

@interface DRYLoggingFileAppenderTest : XCTestCase {
    DRYLoggingFileAppender *_appender;
    id <DRYLoggingMessageFormatter> _formatter;
    BlockRollerPredicate *_rollerPredicate;
    BlockRoller *_roller;

    NSString *_filePath;
    NSStringEncoding _encoding;
}

@end


@interface FileDeletingRoller : NSObject <DRYLoggingRoller>
@end

@implementation DRYLoggingFileAppenderTest

- (void)setUp {
    [super setUp];
    _formatter = mockProtocol(@protocol(DRYLoggingMessageFormatter));
    _rollerPredicate = [[BlockRollerPredicate alloc] init];
    _roller = [[BlockRoller alloc] init];
    _encoding = NSUTF8StringEncoding;

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
    _appender = [DRYLoggingFileAppender appenderWithFormatter:_formatter toFileAtPath:_filePath encoding:_encoding rollerPredicate:_rollerPredicate roller:_roller];
}

- (void)tearDown {
    [self _removeFileAtPath:_filePath];
}

- (void)_removeFileAtPath:(NSString *)path {
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
        XCTFail(@"Could not remove log file after test: %@", error);
    }
}

- (void)testAppendShouldWriteMessageToFile {
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    assertThatAfter(1, ^id() {
        return [self _readStringFromFile];
    }, is(equalTo(@"message\n")));
}

- (void)testAppendShouldAppendMessagesToFile {
    [self _writeStringToFile:@"existing content"];
    [_appender appendAcceptedAndFormattedMessage:@"message2"];
    assertThatAfter(1, ^id() {
        return [self _readStringFromFile];
    }, is(equalTo(@"existing contentmessage2\n")));
}

- (void)testInitializingWithFormatterOnlyResultsInLoggingToDefaultDotLogFileInDocumentPath {
    DRYLoggingFileAppender *appender = [DRYLoggingFileAppender appenderWithFormatter:_formatter];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"default.log"];

    assertThatAfter(1, ^id() {
        return @([[NSFileManager defaultManager] fileExistsAtPath:path]);
    }, is(equalTo(@(YES))));
    [self _removeFileAtPath:path];
}

- (void)testFileAppenderChecksRollerPredicate {
    XCTestExpectation *expectation = [super expectationWithDescription:@"PredicateExecution"];
    _rollerPredicate.executeOnCall = ^(NSString *calledWithPath) {
        assertThat(calledWithPath, is(equalTo(_filePath)));
        [expectation fulfill];
    };

    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [super waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
    }];
}

- (void)testFileAppenderShouldCallFileRoller {
    XCTestExpectation *expectation = [super expectationWithDescription:@"RollerExecution"];
    _rollerPredicate.expectedAnswer = YES;
    _roller.executeOnCall = ^(NSString *calledWithPath) {
        assertThat(calledWithPath, is(equalTo(_filePath)));
        [expectation fulfill];
    };
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [super waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
    }];
}

- (void)testFileAppenderShouldNotCallFileRollerIfPredicateSaysNo {
    _rollerPredicate.expectedAnswer = NO; //
    _roller.executeOnCall = ^(NSString *calledWithPath) {
        XCTFail(@"Roller should never be called!");
    };
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [NSThread sleepForTimeInterval:1];
}

- (void)testWhenRollingOccurredANewFileIsCreated {
    [given([_rollerPredicate shouldRollFileAtPath:_filePath]) willReturnBool:YES];
    id <DRYLoggingRoller> roller = [[FileDeletingRoller alloc] init];
    _appender = [DRYLoggingFileAppender appenderWithFormatter:_formatter toFileAtPath:_filePath encoding:_encoding rollerPredicate:_rollerPredicate roller:roller];
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    assertThatBool([[NSFileManager defaultManager] fileExistsAtPath:_filePath], isTrue());
}

- (NSString *)_readStringFromFile {
    return [NSString stringWithContentsOfFile:_filePath encoding:_encoding error:nil];
}

- (void)_writeStringToFile:(NSString *)string {
    NSError *error;
    if (![string writeToFile:_filePath atomically:NO encoding:_encoding error:&error]) {
        XCTFail(@"Could not write to file: %@", error);
    }
}

@end

@implementation BlockRollerPredicate

- (BOOL)shouldRollFileAtPath:(NSString *)path {
    if (self.executeOnCall) {
        self.executeOnCall(path);
    }
    return self.expectedAnswer;
}

@end

@implementation BlockRoller

- (void)rollFileAtPath:(NSString *)path {
    if (self.executeOnCall) {
        self.executeOnCall(path);
    }
}

@end


@implementation FileDeletingRoller

- (void)rollFileAtPath:(NSString *)path {
    if (![[NSFileManager defaultManager] removeItemAtPath:path error:nil]) {
        @throw [NSException exceptionWithName:@"TestException"
                                       reason:@"Test roller could not delete file"
                                     userInfo:nil];
    }
}

@end