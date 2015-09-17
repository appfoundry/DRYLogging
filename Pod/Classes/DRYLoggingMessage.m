//
//  DRYLoggingMessage.m
//  Pods
//
//  Created by Michael Seghers on 11/04/15.
//
//

#import "DRYLoggingMessage.h"

@implementation DRYLoggingMessage

- (instancetype) init  {
    return [self initWithMessage:@"None" level:DRYLogLevelInfo loggerName:@"root" framework:@"Unknown" className:@"Unknown" methodName:@"Unknown" memoryAddress:@"Unknown" byteOffset:@"Unknown" threadName:@"Unknown" lineNumber:0 date:nil];
}

+ (instancetype)messageWithMessage:(NSString *)message level:(DRYLogLevel)level loggerName:(NSString *)loggerName framework:(NSString *)framework className:(NSString *)className methodName:(NSString *)methodName memoryAddress:(NSString *)memoryAddress byteOffset:(NSString *)byteOffset threadName:(NSString *)threadName lineNumber:(int)lineNumber date:(NSDate *)date {
    return [[self alloc] initWithMessage:message level:level loggerName:loggerName framework:framework className:className methodName:methodName memoryAddress:memoryAddress byteOffset:byteOffset threadName:threadName lineNumber:lineNumber date:date];
}

- (instancetype)initWithMessage:(NSString *)message level:(DRYLogLevel)level loggerName:(NSString *)loggerName framework:(NSString *)framework className:(NSString *)className methodName:(NSString *)methodName memoryAddress:(NSString *)memoryAddress byteOffset:(NSString *)byteOffset threadName:(NSString *)threadName lineNumber:(int)lineNumber date:(NSDate *)date {
    self = [super init];
    if (self) {
        _message = message;
        _level = level;
        _loggerName = loggerName;
        _framework = framework;
        _className = className;
        _methodName = methodName;
        _memoryAddress = memoryAddress;
        _byteOffset = byteOffset;
        _threadName = threadName;
        _lineNumber = @(lineNumber);
        _date = date;
    }

    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToMessage:other];
}

- (BOOL)isEqualToMessage:(DRYLoggingMessage *)message {
    if (self == message)
        return YES;
    if (message == nil)
        return NO;
    if (self.message != message.message && ![self.message isEqualToString:message.message])
        return NO;
    if (self.level != message.level)
        return NO;
    if (self.lineNumber != message.lineNumber && ![self.lineNumber isEqualToNumber:message.lineNumber])
        return NO;
    if (self.date != message.date && ![self.date isEqualToDate:message.date])
        return NO;
    if (self.loggerName != message.loggerName && ![self.loggerName isEqualToString:message.loggerName])
        return NO;
    if (self.framework != message.framework && ![self.framework isEqualToString:message.framework])
        return NO;
    if (self.className != message.className && ![self.className isEqualToString:message.className])
        return NO;
    if (self.methodName != message.methodName && ![self.methodName isEqualToString:message.methodName])
        return NO;
    if (self.memoryAddress != message.memoryAddress && ![self.memoryAddress isEqualToString:message.memoryAddress])
        return NO;
    if (self.threadName != message.threadName && ![self.threadName isEqualToString:message.threadName])
        return NO;
    return !(self.byteOffset != message.byteOffset && ![self.byteOffset isEqualToString:message.byteOffset]);
}

- (NSUInteger)hash {
    NSUInteger hash = [self.message hash];
    hash = hash * 31u + [self.loggerName hash];
    hash = hash * 31u + [self.framework hash];
    hash = hash * 31u + [self.className hash];
    hash = hash * 31u + [self.methodName hash];
    hash = hash * 31u + [self.memoryAddress hash];
    hash = hash * 31u + [self.byteOffset hash];
    hash = hash * 31u + [self.threadName hash];
    hash = hash * 31u + [self.lineNumber hash];
    hash = hash * 31u + [self.date hash];
    return hash;
}


@end
