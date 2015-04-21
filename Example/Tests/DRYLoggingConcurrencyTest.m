//
//  DRYLoggingConcurrencyTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 19/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLogging.h>

@interface DRYLoggingConcurrencyTest : XCTestCase {
    NSString *_filePath;
    NSString *_documentPath;
    int _numberOfThreadsToSpawn;
    int _numberOfMessagesToLogWithinOneThread;
}

@end

@interface MyLoggerThread : NSThread

@property(nonatomic) int numberOfMessagesToLog;
@property(nonatomic, strong) XCTestExpectation *exp;

@end

@implementation DRYLoggingConcurrencyTest

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    _documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _filePath = [_documentPath stringByAppendingPathComponent:@"concurrent.txt"];
    _numberOfThreadsToSpawn = 50;
    _numberOfMessagesToLogWithinOneThread = 100;

    [DRYLoggerFactory loggerWithName:@"threadlogger"].level = DRYLogLevelTrace;
}

- (void)_setupNonRollingRootFileAppender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    id <DRYLoggingMessageFormatter> filterFormatter = [DRYBlockBasedLoggingMessageFormatter formatterWithFormatterBlock:^NSString *(DRYLoggingMessage *message) {
        return [NSString stringWithFormat:@"[%@] - [%@] %@", [df stringFromDate:message.date], message.threadName, message.message];
    }];
    id <DRYLoggingAppender> errorAppender = [[DRYLoggingFileAppender alloc] initWithFormatter:filterFormatter toFileAtPath:_filePath encoding:NSUTF8StringEncoding rollerPredicate:nil roller:nil];
    [[DRYLoggerFactory rootLogger] addAppender:errorAppender];
}

- (void)_setupFastRollingRootFileAppender {
    id <DRYLoggingMessageFormatter> filterFormatter = [DRYBlockBasedLoggingMessageFormatter formatterWithFormatterBlock:^NSString *(DRYLoggingMessage *message) {
        return [NSString stringWithFormat:@"[%@] %@", message.threadName, message.message];
    }];
    DRYLoggingSizeRollerPredicate *predicate = [[DRYLoggingSizeRollerPredicate alloc] initWithMaxSizeInBytes:100];
    DRYLoggingBackupRoller *roller = [[DRYLoggingBackupRoller alloc] initWithMaximumNumberOfFiles:10];

    id <DRYLoggingAppender> errorAppender = [[DRYLoggingFileAppender alloc] initWithFormatter:filterFormatter toFileAtPath:_filePath encoding:NSUTF8StringEncoding rollerPredicate:predicate roller:roller];
    [[DRYLoggerFactory rootLogger] addAppender:errorAppender];
}

- (void)testLinesShouldNotGetMixedUp {
    [self _setupNonRollingRootFileAppender];
    [self _spawnThreads];
    [super waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
    }];
    [self _checkLogToHoldExpectedLinesOfLogging];
}

- (void)testRollingOverWithMultipleThreadsShouldNotMoveMoreThenNeeded {
    [self _setupFastRollingRootFileAppender];
    [self _spawnThreads];
    [super waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
    }];
    [NSThread sleepForTimeInterval:5];

    [self _checkRolledLogsHaveExpectedThreeLines];

}

- (void)_checkRolledLogsHaveExpectedThreeLines {
    for (int i = 1; i < 10; i++) {
        NSString *path = [_documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"concurrent%i.txt", i]];
        NSString *string = [self _readLogFileToString:path];
        NSRange fullRange = NSMakeRange(0, string.length);
        NSString *regexFormat = @"^\\[MyThread-[0-9]+\\] This is message [0-9]+\\.$";
        NSRegularExpression *regex = [self _expressionForFormat:regexFormat];
        NSArray *matches = [regex matchesInString:string options:0 range:fullRange];
        assertThat(matches, hasCountOf(3));
    }
}

- (void)_spawnThreads {
    for (int i = 0; i < _numberOfThreadsToSpawn; i++) {
        MyLoggerThread *t = [[MyLoggerThread alloc] init];
        t.numberOfMessagesToLog = _numberOfMessagesToLogWithinOneThread;
        t.name = [NSString stringWithFormat:@"MyThread-%i", i];
        t.exp = [super expectationWithDescription:t.name];
        [t start];
    }
}

- (void)_checkLogToHoldExpectedLinesOfLogging {
    NSString *contents = [self _readLogFileToString:_filePath];
    NSRange fullRange = NSMakeRange(0, contents.length);
    for (int i = 0; i < _numberOfThreadsToSpawn; i++) {
        for (int j = 0; j < _numberOfMessagesToLogWithinOneThread; j++) {
            NSArray *matches = [[self _expressionForThreadAtIndex:i withMessageAt:j] matchesInString:contents options:0 range:fullRange];
            XCTAssertEqual(matches.count, 1, @"Incorrect matches: %@", matches);
        }
    }
}

- (NSString *)_readLogFileToString:(NSString *)path {
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (NSRegularExpression *)_expressionForThreadAtIndex:(int)i withMessageAt:(int)j {
    NSString *regexFormat = [NSString stringWithFormat:@"^\\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}\\] - \\[MyThread-%i\\] This is message %i\\.$", i, j];
    return [self _expressionForFormat:regexFormat];
}

- (NSRegularExpression *)_expressionForFormat:(NSString *)regexFormat {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexFormat options:NSRegularExpressionAnchorsMatchLines error:&error];
    if (!regex) {
        XCTFail(@"Wrong regex format! %@", error);
    }
    return regex;
}

- (void)tearDown {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:documentsPath error:nil];
    for (NSString *filePath in array) {
        NSError *error;
        if (![manager removeItemAtPath:[documentsPath stringByAppendingPathComponent:filePath] error:&error]) {
            XCTFail(@"Could not remove %@: %@", filePath, error);
        }
    }

    [[DRYLoggerFactory rootLogger].appenders enumerateObjectsUsingBlock:^(id appender, NSUInteger idx, BOOL *stop) {
        [[DRYLoggerFactory rootLogger] removeAppender:appender];
    }];
}

@end

@implementation MyLoggerThread

- (void)main {
    id <DRYLogger> commonLogger = [DRYLoggerFactory loggerWithName:@"threadlogger"];
    for (int i = 0; i < self.numberOfMessagesToLog; i++) {
        DRYInfo(commonLogger, @"This is message %i.", i);
        [NSThread sleepForTimeInterval:(arc4random_uniform(10) / 10)];
    }
    [self.exp fulfill];
}

@end