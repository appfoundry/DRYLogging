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

#define callAppenders(lineNumber, lvl, format)  va_list args; \
va_start(args, (format));                           \
[self _callAppendersWithLineNumber:(lineNumber) format:(format) level:(lvl) args:args]; \
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
    return [self initWithName:name parent:nil];
}

- (instancetype)initWithName:(NSString *)name parent:(id<DRYLogger>)parent {
    NSParameterAssert(name);
    self = [super init];
    if (self) {
        _parent = parent;
        _name = name;
        _level = DRYLogLevelOff;
        _appenders = [[NSMutableArray alloc] init];
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
        callAppenders(0, DRYLogLevelTrace, format)
    }
}

- (void)traceWithLineNumber:(int)lineNumber format:(NSString *)format, ... {
    if (self.isTraceEnabled) {
        callAppenders(lineNumber, DRYLogLevelTrace, format)
    }
}

- (BOOL)isDebugEnabled {
    return [self isLevelEnabled:DRYLogLevelDebug];
}

- (void)debug:(NSString *)format, ... {
    if (self.isDebugEnabled) {
        callAppenders(0, DRYLogLevelDebug, format);
    }
}

- (void)debugWithLineNumber:(int)lineNumber format:(NSString *)format, ... {
    if (self.isDebugEnabled) {
        callAppenders(lineNumber, DRYLogLevelDebug, format)
    }
}

- (BOOL)isInfoEnabled {
    return [self isLevelEnabled:DRYLogLevelInfo];
}

- (void)info:(NSString *)format, ... {
    if (self.isInfoEnabled) {
        callAppenders(0, DRYLogLevelInfo, format);
    }
}

- (void)infoWithLineNumber:(int)lineNumber format:(NSString *)format, ... {
    if (self.isInfoEnabled) {
        callAppenders(lineNumber, DRYLogLevelInfo, format)
    }
}

- (BOOL)isWarnEnabled {
    return [self isLevelEnabled:DRYLogLevelWarn];
}

- (void)warn:(NSString *)format, ... {
    if (self.isWarnEnabled) {
        callAppenders(0, DRYLogLevelWarn, format);
    }
}

- (void)warnWithLineNumber:(int)lineNumber format:(NSString *)format, ... {
    if (self.isWarnEnabled) {
        callAppenders(lineNumber, DRYLogLevelWarn, format)
    }
}

- (BOOL)isErrorEnabled {
    return [self isLevelEnabled:DRYLogLevelError];
}

- (void)error:(NSString *)format, ... {
    if (self.isErrorEnabled) {
        callAppenders(0, DRYLogLevelError, format);
    }
}

- (void)errorWithLineNumber:(int)lineNumber format:(NSString *)format, ... {
    if (self.isErrorEnabled) {
        callAppenders(lineNumber, DRYLogLevelError, format)
    }
}

- (void)_callAppendersWithLineNumber:(int)lineNumber format:(NSString *)format level:(DRYLogLevel)level args:(va_list)args {
    NSString *sourceString = [NSThread callStackSymbols][2];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    NSString *threadName = [NSThread currentThread].name.length ? [NSThread currentThread].name : ([NSThread currentThread].isMainThread ? @"main" : @"???");
    DRYLoggingMessage *message = [DRYLoggingMessage messageWithMessage:[[NSString alloc] initWithFormat:format arguments:args] level:level loggerName:self.name framework:array[1] className:array[3] methodName:array[4] memoryAddress:array[2] byteOffset:array[5] threadName:threadName lineNumber:lineNumber];

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
