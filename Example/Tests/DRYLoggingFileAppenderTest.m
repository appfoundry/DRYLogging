//
//  DRYLoggingFileAppenderTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 18/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLogging.h>

#define WEAK_SELF __weak DRYLoggingFileAppenderTest *weakSelf = self;
#define STRONG_SELF DRYLoggingFileAppenderTest *self = weakSelf;

@interface BlockRollerPredicate : NSObject <DRYLoggingRollerPredicate>
@property(nonatomic) BOOL expectedAnswer;
@property(nonatomic, strong) void(^executeOnCall)(NSString *passedInFilePath);

@end

@interface BlockRoller : NSObject <DRYLoggingRoller>
@property(nonatomic, strong) void(^executeOnCall)(NSString *passedInFilePath);
@end

@interface DRYLoggingFileAppender (TestKnowsAll)

@property (readonly, nonatomic) NSArray *queuedMessage;

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
    _formatter = MKTMockProtocol(@protocol(DRYLoggingMessageFormatter));
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
    HC_assertThatAfter(1, ^id() {
        return [self _readStringFromFile];
    }, HC_is(HC_equalTo(@"message\n")));
}

- (void)testAppendShouldAppendMessagesToFile {
    [self _writeStringToFile:@"existing content"];
    [_appender appendAcceptedAndFormattedMessage:@"message2"];
    HC_assertThatAfter(1, ^id() {
        return [self _readStringFromFile];
    }, HC_is(HC_equalTo(@"existing contentmessage2\n")));
}

- (void)testInitializingWithFormatterOnlyResultsInLoggingToDefaultDotLogFileInDocumentPath {
    DRYLoggingFileAppender *appender = [DRYLoggingFileAppender appenderWithFormatter:_formatter];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"default.log"];

    HC_assertThatAfter(1, ^id() {
        return @([[NSFileManager defaultManager] fileExistsAtPath:path]);
    }, HC_is(HC_equalTo(@(YES))));
    [self _removeFileAtPath:path];
    appender = nil;
}

- (void)testFileAppenderChecksRollerPredicate {
    XCTestExpectation *expectation = [super expectationWithDescription:@"PredicateExecution"];
    WEAK_SELF
    _rollerPredicate.executeOnCall = ^(NSString *calledWithPath) {
        STRONG_SELF
        HC_assertThat(calledWithPath, HC_is(HC_equalTo(self->_filePath)));
        [expectation fulfill];
    };

    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [super waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
    }];
}

- (void)testFileAppenderShouldCallFileRoller {
    XCTestExpectation *expectation = [super expectationWithDescription:@"RollerExecution"];
    _rollerPredicate.expectedAnswer = YES;
    __weak DRYLoggingFileAppenderTest *weakSelf = self;
    _roller.executeOnCall = ^(NSString *calledWithPath) {
        DRYLoggingFileAppenderTest *self = weakSelf;
        HC_assertThat(calledWithPath, HC_is(HC_equalTo(self->_filePath)));
        [expectation fulfill];
    };
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [super waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
    }];
}

- (void)testFileAppenderShouldNotCallFileRollerIfPredicateSaysNo {
    _rollerPredicate.expectedAnswer = NO;
    __weak id weakSelf = self;
    _roller.executeOnCall = ^(NSString *calledWithPath) {
        id self = weakSelf;
        XCTFail(@"Roller should never be called!");
    };
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [NSThread sleepForTimeInterval:1];
}

- (void)testWhenRollingOccurredANewFileIsCreated {
    [MKTGiven([_rollerPredicate shouldRollFileAtPath:_filePath]) willReturnBool:YES];
    id <DRYLoggingRoller> roller = [[FileDeletingRoller alloc] init];
    _appender = [DRYLoggingFileAppender appenderWithFormatter:_formatter toFileAtPath:_filePath encoding:_encoding rollerPredicate:_rollerPredicate roller:roller];
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    while(_appender.queuedMessage.count > 0) {}
    HC_assertThatBool([[NSFileManager defaultManager] fileExistsAtPath:_filePath], HC_isTrue());
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
