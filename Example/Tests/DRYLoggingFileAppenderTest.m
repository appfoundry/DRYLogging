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
    id<DRYLoggingAppenderFilter> _filter;
    
    NSString *_filePath;
    NSStringEncoding _encoding;
}

@end

@implementation DRYLoggingFileAppenderTest

- (void)setUp {
    [super setUp];
    _formatter = mockProtocol(@protocol(DRYLoggingMessageFormatter));
    _filter = mockProtocol(@protocol(DRYLoggingAppenderFilter));
    _encoding = NSUTF8StringEncoding;
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
    _appender = [DRYLoggingFileAppender appenderWithFormatter:_formatter toFileAtPath:_filePath encoding:_encoding];
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
