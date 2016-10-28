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

@interface _DRYLoggingFileAppenderMessageQueueThread : NSThread {
    NSOutputStream *_stream;
    NSStringEncoding _encoding;
    NSString *_filePath;
    id <DRYLoggingRollerPredicate> _rollerPredicate;
    id <DRYLoggingRoller> _roller;
    NSMutableArray *_queue;
    dispatch_semaphore_t _queueOrCancelledSemaphore;
}

- (instancetype)initWithFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding rollerPredicate:(id <DRYLoggingRollerPredicate>)rollerPredicate roller:(id <DRYLoggingRoller>)roller queue:(NSMutableArray *)queue semaphore:(dispatch_semaphore_t)sem;

@end

@interface DRYLoggingFileAppender () {
    NSMutableArray *_queuedMessages;
    _DRYLoggingFileAppenderMessageQueueThread *_queueThread;
    dispatch_semaphore_t _queueOrCancelledSemaphore;

}

@property (readonly, nonatomic) NSArray *queuedMessage;

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
        _queuedMessages = [[NSMutableArray alloc] init];
        _queueOrCancelledSemaphore = dispatch_semaphore_create(0);
        _queueThread = [[_DRYLoggingFileAppenderMessageQueueThread alloc] initWithFileAtPath:path encoding:encoding rollerPredicate:rollerPredicate roller:roller queue:_queuedMessages semaphore:_queueOrCancelledSemaphore];
        [_queueThread start];
    }
    return self;
}

- (void)appendAcceptedAndFormattedMessage:(NSString *)formattedMessage {
    @synchronized (_queuedMessages) {
        [_queuedMessages addObject:formattedMessage];
    }
    dispatch_semaphore_signal(_queueOrCancelledSemaphore);
}

- (void)dealloc {
    [_queueThread cancel];
    dispatch_semaphore_signal(_queueOrCancelledSemaphore);
}

@end

@implementation _DRYLoggingFileAppenderMessageQueueThread

- (instancetype)initWithFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding rollerPredicate:(id <DRYLoggingRollerPredicate>)rollerPredicate roller:(id <DRYLoggingRoller>)roller queue:(NSMutableArray *)queue semaphore:(dispatch_semaphore_t)sem {
    self = [super init];
    if (self) {
        _filePath = path;
        _encoding = encoding;
        _rollerPredicate = rollerPredicate;
        _roller = roller;
        _queue = queue;
        _queueOrCancelledSemaphore = sem;
        self.name = @"DRYLoggingFileAppenderThread";
    }
    return self;
}


- (void)main {
    [self _openNewStream];
    while (!self.isCancelled) {
        NSString *message;
        do {
            message = [self _firstMessageFromQueue];
            if (message) {
                [self _writeMessage:message];
                [self _rollIfNeeded];
            }
        } while (message);
        dispatch_semaphore_wait(_queueOrCancelledSemaphore, DISPATCH_TIME_FOREVER);
    }
    [_stream close];
}

- (void)_rollIfNeeded {
    if ([_rollerPredicate shouldRollFileAtPath:_filePath]) {
        [_stream close];
        [_roller rollFileAtPath:_filePath];
        [self _openNewStream];
    }
}

- (void)_openNewStream {
    _stream = [NSOutputStream outputStreamToFileAtPath:_filePath append:YES];
    [_stream open];
}

- (void)_writeMessage:(NSString *)message {
    NSData *stringAsData = [[message stringByAppendingString:@"\n"] dataUsingEncoding:_encoding];
    [_stream write:stringAsData.bytes maxLength:stringAsData.length];
}

- (NSString *)_firstMessageFromQueue {
    NSString *message;
    @synchronized (_queue) {
        message = _queue.firstObject;
        if (message) {
            [_queue removeObjectAtIndex:0];
        }
    }
    return message;
}

- (void)dealloc {
    [_stream close];
}

@end
