//
//  DRYDefaultLogger.m
//  Pods
//
//  Created by Michael Seghers on 09/04/15.
//
//

#import "DRYDefaultLogger.h"
#import "DRYLoggingAppender.h"

@interface DRYDefaultLogger () {
    NSMutableArray *_appenders;
}

@end



@implementation DRYDefaultLogger

@synthesize level = _level;
@synthesize name = _name;

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

+ (instancetype)loggerWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (BOOL)isTraceEnabled {
    return [self _isLevelEnabled:DRYLogLevelTrace];
}

- (void)trace:(NSString *)format, ... {
    
}

- (BOOL)isDebugEnabled {
    return [self _isLevelEnabled:DRYLogLevelDebug];
}

- (void)debug:(NSString *)format, ... {
    if (self.isDebugEnabled) {
        va_list args;
        va_start(args, format);
        for (id<DRYLoggingAppender> appender in _appenders) {
            [appender append:format, args];
        }
        va_end(args);
    }
}

- (BOOL)isInfoEnabled {
    return [self _isLevelEnabled:DRYLogLevelInfo];
}

- (void)info:(NSString *)format, ... {
    if (self.isInfoEnabled) {
        va_list args;
        va_start(args, format);
        for (id<DRYLoggingAppender> appender in _appenders) {
            [appender append:format, args];
        }
        va_end(args);
    }
}

- (BOOL)isWarnEnabled {
    return [self _isLevelEnabled:DRYLogLevelWarn];
}

- (void)warn:(NSString *)format, ... {
    
}

- (BOOL)isErrorEnabled {
    return [self _isLevelEnabled:DRYLogLevelError];
}

- (void)error:(NSString *)format, ... {
    
}

- (BOOL)_isLevelEnabled:(DRYLogLevel)level {
    return _level <= level;
}

- (void)addAppender:(id<DRYLoggingAppender>)appender {
    [_appenders addObject:appender];
}

@end
