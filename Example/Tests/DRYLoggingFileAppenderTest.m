//
//  DRYLoggingFileAppenderTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 18/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLogging.h>

@interface DRYLoggingFileAppenderTest : XCTestCase {
    DRYLoggingFileAppender *_appender;
    id<DRYLoggingMessageFormatter> _formatter;
    id<DRYLoggingRollerPredicate> _rollerPredicate;
    id<DRYLoggingRoller> _roller;
    
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
    _rollerPredicate = mockProtocol(@protocol(DRYLoggingRollerPredicate));
    _roller = mockProtocol(@protocol(DRYLoggingRoller));
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
    assertThat([self _readStringFromFile], is(equalTo(@"message\n")));
}

- (void)testAppendShouldAppendMessagesToFile {
    [self _writeStringToFile:@"existing content"];
    [_appender appendAcceptedAndFormattedMessage:@"message2"];
    assertThat([self _readStringFromFile], is(equalTo(@"existing contentmessage2\n")));
}

- (void)testInitializingWithFormatterOnlyResultsInLoggingToDefaultDotLogFileInDocumentPath {
    [DRYLoggingFileAppender appenderWithFormatter:_formatter];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"default.log"];
    assertThatBool([[NSFileManager defaultManager] fileExistsAtPath:path], isTrue());
    [self _removeFileAtPath:path];
}

- (void)testFileAppenderChecksRollerPredicate {
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [MKTVerify(_rollerPredicate) shouldRollFileAtPath:_filePath];
}

- (void)testFileAppenderShouldCallFileRoller {
    [given([_rollerPredicate shouldRollFileAtPath:_filePath]) willReturnBool:YES];
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [MKTVerify(_roller) rollFileAtPath:_filePath];
}

- (void)testFileAppenderShouldNotCallFileRollerIfPredicateSaysNo {
    [given([_rollerPredicate shouldRollFileAtPath:_filePath]) willReturnBool:NO];
    [_appender appendAcceptedAndFormattedMessage:@"message"];
    [MKTVerifyCount(_roller, never()) rollFileAtPath:anything()];
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


@implementation FileDeletingRoller

- (void)rollFileAtPath:(NSString *)path {
    if (![[NSFileManager defaultManager] removeItemAtPath:path error:nil]) {
        XCTFail(@"Test roller could not delete file");
    }
}

@end