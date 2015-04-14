//
//  DRYDefaultLogger.m
//  Pods
//
//  Created by Michael Seghers on 09/04/15.
//
//

#import "DRYDefaultLogger.h"
#import "DRYLoggingAppender.h"
#import "DRYLoggingMessage.h"

@interface DRYDefaultLogger () {
    NSMutableArray *_appenders;
}

@end

#define callAppenders(lvl, format)  va_list args; \
va_start(args, (format));                           \
[self _callAppendersWithFormat:(format) level:(lvl) args:args]; \
va_end(args);

@implementation DRYDefaultLogger

@synthesize level = _level;
@synthesize name = _name;
@synthesize parent = _parent;
@synthesize appenders = _appenders;

- (instancetype)init
{
    return [self initWithName:@"root"];
}

- (instancetype)initWithName:(NSString *)name {
    NSAssert(name != nil,  @"Name should not be nil for a logger!");
    self = [super init];
    if (self) {
        _name = name;
        _level = DRYLogLevelOff;
        _appenders = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name parent:(id<DRYLogger>)parent {
    self = [self initWithName:name];
    if (self) {
        _parent = parent;
    }
    return self;
}

+ (instancetype)loggerWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

+ (instancetype)loggerWithName:(NSString *)name parent:(id<DRYLogger>)parent {
    return [[self alloc] initWithName:name parent:parent];
}


- (BOOL)isTraceEnabled {
    return [self isLevelEnabled:DRYLogLevelTrace];
}

- (void)trace:(NSString *)format, ... {
    if (self.isTraceEnabled) {
        callAppenders(DRYLogLevelTrace, format)
    }
}



- (BOOL)isDebugEnabled {
    return [self isLevelEnabled:DRYLogLevelDebug];
}

- (void)debug:(NSString *)format, ... {
    if (self.isDebugEnabled) {
        callAppenders(DRYLogLevelDebug, format);
    }
}

- (BOOL)isInfoEnabled {
    return [self isLevelEnabled:DRYLogLevelInfo];
}

- (void)info:(NSString *)format, ... {
    if (self.isInfoEnabled) {
        callAppenders(DRYLogLevelInfo, format);
    }
}

- (BOOL)isWarnEnabled {
    return [self isLevelEnabled:DRYLogLevelWarn];
}

- (void)warn:(NSString *)format, ... {
    if (self.isWarnEnabled) {
        callAppenders(DRYLogLevelWarn, format);
    }
}

- (BOOL)isErrorEnabled {
    return [self isLevelEnabled:DRYLogLevelError];
}

- (void)error:(NSString *)format, ... {
    if (self.isErrorEnabled) {
        callAppenders(DRYLogLevelError, format);
    }
}

- (void)_callAppendersWithFormat:(NSString *)format level:(DRYLogLevel)level args:(va_list)args {
    NSString *sourceString = [NSThread callStackSymbols][2];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    NSString *threadName = [NSThread currentThread].name.length ? [NSThread currentThread].name : ([NSThread currentThread].isMainThread ? @"main" : @"???");
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:[[NSString alloc] initWithFormat:format arguments:args] level:level loggerName:self.name framework:array[1] className:array[3] methodName:array[4] memoryAddress:array[2] byteOffset:array[5] threadName:threadName];

    [self _callLoggerAppenders:self message:message];
}

- (void)_callLoggerAppenders:(DRYDefaultLogger *)logger message:(DRYLoggingMessage *)message {
    for (id<DRYLoggingAppender> appender in logger.appenders) {
        [appender append:message];
    }

    if (logger.parent) {
        [self _callLoggerAppenders:logger.parent message:message];
    }
}

- (BOOL)isLevelEnabled:(DRYLogLevel)level {
    if (_level == DRYLogLevelOff && _parent) {
        return [_parent isLevelEnabled:level];
    }
    return _level <= level;
}

- (void)addAppender:(id<DRYLoggingAppender>)appender {
    [_appenders addObject:appender];
}

- (void)removeAppender:(id <DRYLoggingAppender>)appender {
    [_appenders removeObject:appender];
}
@end
