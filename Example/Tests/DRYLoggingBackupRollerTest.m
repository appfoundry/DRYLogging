//
//  DRYLoggingBackupRollerTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 18/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLogging.h>

@interface DRYLoggingBackupRollerTest : XCTestCase {
    DRYLoggingBackupRoller *_roller;
    NSString *_filePath;
    NSString *_filePath1;
    NSString *_filePath2;
    NSString *_filePath3;
    NSString *_filePath4;
    NSString *_documentsPath;
    NSFileManager *_manager;
}

@end

@implementation DRYLoggingBackupRollerTest

- (void)setUp {
    [super setUp];
    _roller = [[DRYLoggingBackupRoller alloc] initWithMaximumNumberOfFiles:4];

    _documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _filePath = [_documentsPath stringByAppendingPathComponent:@"file.txt"];
    _filePath1 = [_documentsPath stringByAppendingPathComponent:@"file1.txt"];
    _filePath2 = [_documentsPath stringByAppendingPathComponent:@"file2.txt"];
    _filePath3 = [_documentsPath stringByAppendingPathComponent:@"file3.txt"];
    _filePath4 = [_documentsPath stringByAppendingPathComponent:@"file4.txt"];
    _manager = [NSFileManager defaultManager];
}

- (void)tearDown {
    NSArray *array = [_manager contentsOfDirectoryAtPath:_documentsPath error:nil];
    for (NSString *filePath in array) {
        NSError *error;
        if (![_manager removeItemAtPath:[_documentsPath stringByAppendingPathComponent:filePath] error:&error]) {
            XCTFail(@"Could not remove %@: %@", filePath, error);
        }
    }
}

- (void)testRollerRenamesFileToFile1 {
    [_manager createFileAtPath:_filePath contents:nil attributes:nil];
    [_roller rollFileAtPath:_filePath];
    assertThatBool([_manager fileExistsAtPath:_filePath1], isTrue());
}

- (void)testRollerRenamesFile1ToFile2 {
    [_manager createFileAtPath:_filePath1 contents:nil attributes:nil];
    [_roller rollFileAtPath:_filePath];
    assertThatBool([_manager fileExistsAtPath:_filePath2], isTrue());
}

- (void)testRollerRenamesFile2ToFile3 {
    [_manager createFileAtPath:_filePath2 contents:nil attributes:nil];
    [_roller rollFileAtPath:_filePath];
    assertThatBool([_manager fileExistsAtPath:_filePath3], isTrue());
}

- (void)testDeletesMaximumAllowedFileAndMovesBeforeLast {
    [self _writeString:@"3" toFile:_filePath3];
    [self _writeString:@"2" toFile:_filePath2];
    [_roller rollFileAtPath:_filePath];
    NSString *file3Content = [NSString stringWithContentsOfFile:_filePath3 encoding:NSUTF8StringEncoding error:nil];
    assertThat(file3Content, is(equalTo(@"2")));
    assertThatBool([_manager fileExistsAtPath:_filePath4], isFalse());
}

- (void)_writeString:(NSString *)string toFile:(NSString *)file {
    if (![string writeToFile:file atomically:NO encoding:NSUTF8StringEncoding error:nil]) {
        XCTFail(@"Couldn't write file %@", file);
    }
}

- (void)testConvenienceInitializerSetMaxNumberOfFilesTo5 {
    assertThatUnsignedInteger([[DRYLoggingBackupRoller alloc] init].maximumNumberOfFiles, is(equalToUnsignedInteger(5)));
}


@end
