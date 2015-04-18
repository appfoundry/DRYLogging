//
//  DRYLoggingFileAppender.m
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import "DRYLoggingRoller.h"
#import "DRYLoggingRollerPredicate.h"
#import "DRYLoggingFileAppender.h"

@interface DRYLoggingFileAppender () {
    NSOutputStream *_stream;
    NSStringEncoding _encoding;
    NSString *_filePath;
    id<DRYLoggingRollerPredicate> _rollerPredicate;
    id<DRYLoggingRoller> _roller;
    
}
@end

@implementation DRYLoggingFileAppender


+ (instancetype)appenderWithFormatter:(id<DRYLoggingMessageFormatter>)formatter toFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding rollerPredicate:(id<DRYLoggingRollerPredicate>)rollerPredicate roller:(id<DRYLoggingRoller>)roller {
    return [[self alloc] initWithFormatter:formatter toFileAtPath:path encoding:encoding rollerPredicate:rollerPredicate roller:roller];
}
#warning todo -> set default size roller predicate of 1 MB and roller to simple backup roller
- (instancetype)initWithFormatter:(id<DRYLoggingMessageFormatter>)formatter {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [self initWithFormatter:formatter toFileAtPath:[documentsPath stringByAppendingPathComponent:@"default.log"] encoding:NSUTF8StringEncoding rollerPredicate:nil roller:nil];
}

- (instancetype)initWithFormatter:(id<DRYLoggingMessageFormatter>)formatter toFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding rollerPredicate:(id<DRYLoggingRollerPredicate>)rollerPredicate roller:(id<DRYLoggingRoller>)roller {
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
    _stream = [NSOutputStream outputStreamToFileAtPath:_filePath append:YES];
    [_stream open];
}

- (void)appendAcceptedAndFormattedMessage:(NSString *)formattedMessage {
    NSData *stringAsData = [[formattedMessage stringByAppendingString:@"\n"] dataUsingEncoding:_encoding];
    [_stream write:stringAsData.bytes maxLength:stringAsData.length];
    [self _performRollingIfNeeded];
}

- (void)_performRollingIfNeeded {
    if ([_rollerPredicate shouldRollFileAtPath:_filePath]) {
        [_stream close];
        [_roller rollFileAtPath:_filePath];
        [self _openStream];
    }
}

- (void)dealloc {
    [_stream close];
}

@end
