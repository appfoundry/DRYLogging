//
//  DRYLoggingFileAppender.m
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import "DRYLoggingFileAppender.h"

@interface DRYLoggingFileAppender () {
    NSOutputStream *_stream;
    NSStringEncoding _encoding;
    
}
@end

@implementation DRYLoggingFileAppender


+ (instancetype)appenderWithFormatter:(id<DRYLoggingMessageFormatter>)formatter toFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    return [[self alloc] initWithFormatter:formatter toFileAtPath:path encoding:encoding];
}

- (instancetype)initWithFormatter:(id<DRYLoggingMessageFormatter>)formatter {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [self initWithFormatter:formatter toFileAtPath:[documentsPath stringByAppendingPathComponent:@"default.log"] encoding:NSUTF8StringEncoding];
}

- (instancetype)initWithFormatter:(id<DRYLoggingMessageFormatter>)formatter toFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super initWithFormatter:formatter];
    if (self) {
        _encoding = encoding;
        _stream = [NSOutputStream outputStreamToFileAtPath:path append:YES];
        [_stream open];
    }
    return self;
}

- (void)appendAcceptedAndFormattedMessage:(NSString *)formattedMessage {
    NSData *stringAsData = [[formattedMessage stringByAppendingString:@"\n"] dataUsingEncoding:_encoding];
    [_stream write:stringAsData.bytes maxLength:stringAsData.length];
}

- (void)dealloc {
    [_stream close];
}

@end
