//
//  DRYLoggingFileAppender.m
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import <DRYLogging/DRYLoggingBackupRoller.h>
#import "DRYLoggingSizeRollerPredicate.h"
#import "DRYLoggingFileAppender.h"

@interface DRYLoggingFileAppender () {
    NSOutputStream *_stream;
    NSStringEncoding _encoding;
    NSString *_filePath;
    id <DRYLoggingRollerPredicate> _rollerPredicate;
    id <DRYLoggingRoller> _roller;
    BOOL _rolling;

}
@end

@implementation DRYLoggingFileAppender


+ (instancetype)appenderWithFormatter:(id <DRYLoggingMessageFormatter>)formatter toFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding rollerPredicate:(id <DRYLoggingRollerPredicate>)rollerPredicate roller:(id <DRYLoggingRoller>)roller {
    return [[self alloc] initWithFormatter:formatter toFileAtPath:path encoding:encoding rollerPredicate:rollerPredicate roller:roller];
}

- (instancetype)initWithFormatter:(id <DRYLoggingMessageFormatter>)formatter {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    id <DRYLoggingRollerPredicate> predicate = [[DRYLoggingSizeRollerPredicate alloc] init];
    id <DRYLoggingRoller> roller = [[DRYLoggingBackupRoller alloc] init];
    return [self initWithFormatter:formatter toFileAtPath:[documentsPath stringByAppendingPathComponent:@"default.log"] encoding:NSUTF8StringEncoding rollerPredicate:predicate roller:roller];
}

- (instancetype)initWithFormatter:(id <DRYLoggingMessageFormatter>)formatter toFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding rollerPredicate:(id <DRYLoggingRollerPredicate>)rollerPredicate roller:(id <DRYLoggingRoller>)roller {
    self = [super initWithFormatter:formatter];
    if (self) {
        _encoding = encoding;
        _filePath = path;
        _rollerPredicate = rollerPredicate;
        _roller = roller;
        [self _openStream];
    }
    return self;
}

- (void)_openStream {
    @synchronized (self) {
        _stream = [NSOutputStream outputStreamToFileAtPath:_filePath append:YES];
        [_stream open];
    }
}

- (void)appendAcceptedAndFormattedMessage:(NSString *)formattedMessage {
    while (_rolling) {
        [NSThread sleepForTimeInterval:0.1];
    }

    NSData *stringAsData = [[formattedMessage stringByAppendingString:@"\n"] dataUsingEncoding:_encoding];
    @synchronized (self) {
        [_stream write:stringAsData.bytes maxLength:stringAsData.length];
    }
    [self _performRollingIfNeeded];
}

- (void)_performRollingIfNeeded {
    if ([_rollerPredicate shouldRollFileAtPath:_filePath] && !_rolling) {
        @synchronized (self) {
            [_stream close];
        }
        _rolling = YES;
        NSThread *ct = [NSThread currentThread];
        [_roller rollFileAtPath:_filePath];
        [self _openStream];
        _rolling = NO;
    }
}

- (void)dealloc {
    [_stream close];
}

@end
