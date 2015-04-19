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
}

@end

@interface MyLoggerThread : NSThread

@property (nonatomic, strong) XCTestExpectation *exp;

@end

@implementation DRYLoggingConcurrencyTest

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat =  @"yyyy-MM-dd HH:mm:ss.SSS";
    id <DRYLoggingMessageFormatter> filterFormatter = [DRYBlockBasedLoggingMessageFormatter formatterWithFormatterBlock:^NSString *(DRYLoggingMessage *message) {
        return [NSString stringWithFormat:@"[%@] - [%@] %@", [df stringFromDate:message.date], message.threadName, message.message];
    }];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _filePath = [documentsPath stringByAppendingPathComponent:@"concurrent.txt"];
    id<DRYLoggingAppender> errorAppender = [[DRYLoggingFileAppender alloc] initWithFormatter:filterFormatter toFileAtPath:_filePath encoding:NSUTF8StringEncoding rollerPredicate:nil roller:nil];
    [[DRYLoggerFactory rootLogger] addAppender:errorAppender];
    [DRYLoggerFactory loggerWithName:@"threadlogger"].level = DRYLogLevelTrace;
    
    
}

- (void)testSpawnThreads {
    int total = 50;
    for (int i = 0; i < total; i++) {
        MyLoggerThread *t = [[MyLoggerThread alloc] init];
        t.name = [NSString stringWithFormat:@"MyThread-%i", i];
        t.exp = [super expectationWithDescription:t.name];
        [t start];
    }
    
    [super waitForExpectationsWithTimeout:5 handler:^(NSError *error) {}];
    
    NSString *contents = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
    NSRange fullRange = NSMakeRange(0, contents.length);
    
    
    for (int i = 0; i < total; i++) {
        for (int j = 0; j < 100; j++) {
            //NSString *regexFormat = [NSString stringWithFormat:@"^\\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}\\] - \\[MyThread-%i\\] This is message %i$", i, j];
            NSString *regexFormat = [NSString stringWithFormat:@"^\\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{3}\\] - \\[MyThread-%i\\] This is message %i\\.$", i, j];
            NSError *error;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexFormat options:NSRegularExpressionAnchorsMatchLines error:&error];
            if (!regex) {
                XCTFail(@"Wrong regex format! %@", error);
            }
            NSArray *matches = [regex matchesInString:contents options:0 range:fullRange];
            XCTAssertEqual(matches.count, 1, @"Incorrect matches: %@", matches);
        }
    }
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
}

@end

@implementation MyLoggerThread

- (void)main {
    id <DRYLogger> commonLogger = [DRYLoggerFactory loggerWithName:@"threadlogger"];
    for (int i = 0; i < 100; i++) {
        DRYInfo(commonLogger, @"This is message %i.", i);
        [NSThread sleepForTimeInterval:(arc4random_uniform(10) / 10)];
    }
    [self.exp fulfill];
}

@end