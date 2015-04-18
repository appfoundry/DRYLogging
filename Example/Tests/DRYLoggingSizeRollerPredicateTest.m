//
//  DRYLoggingSizeRollerPredicateTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 18/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLogging.h>

@interface DRYLoggingSizeRollerPredicateTest : XCTestCase {
    DRYLoggingSizeRollerPredicate *_predicate;
    NSString *_filePath;
}

@end

@implementation DRYLoggingSizeRollerPredicateTest

- (void)setUp {
    [super setUp];
    _predicate = [DRYLoggingSizeRollerPredicate predicateWithMaxSizeInBytes:5];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _filePath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
}

- (void)tearDown {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:_filePath] && ![manager removeItemAtPath:_filePath error:nil]) {
        XCTFail(@"Test file could not be removed");
    }
}

- (void)testPredicateReturnsYESWhenFileSizeExeedsConfiguredSize {
    [self _writeStringToFile:@"toobig"];
    assertThatBool([_predicate shouldRollFileAtPath:_filePath], isTrue());
}

- (void)testPredicateReturnsNOWhenFileSizeDoesNotExceedConfiguredSize {
    [self _writeStringToFile:@"small"];
    assertThatBool([_predicate shouldRollFileAtPath:_filePath], isFalse());
}

- (void)testUsingConvenienceInitializerSetMaxSizeInBytesTo1MB {
    assertThatUnsignedInteger([[DRYLoggingSizeRollerPredicate alloc] init].maxSizeInBytes, is(equalToUnsignedInteger(DRY_ONE_MEGABYTE)));
}


- (void)_writeStringToFile:(NSString *)string {
    if (![string writeToFile:_filePath atomically:NO encoding:NSUTF8StringEncoding error:nil]) {
        XCTFail(@"Test file could not be created");
    }
}

@end
