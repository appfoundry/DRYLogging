//
//  DRYLogger.h
//  Pods
//
//  Created by Michael Seghers on 09/04/15.
//
//

#import <Foundation/Foundation.h>

@protocol DRYLoggingAppender;

typedef NS_ENUM(NSInteger, DRYLogLevel) {
    DRYLogLevelTrace,
    DRYLogLevelDebug,
    DRYLogLevelInfo,
    DRYLogLevelWarn,
    DRYLogLevelError,
    DRYLogLevelOff
};

@protocol DRYLogger <NSObject>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) id <DRYLogger> parent;
@property (nonatomic, readonly, copy) NSArray *appenders;
@property (nonatomic) DRYLogLevel level;

@property (nonatomic, readonly) BOOL isTraceEnabled;
@property (nonatomic, readonly) BOOL isDebugEnabled;
@property (nonatomic, readonly) BOOL isInfoEnabled;
@property (nonatomic, readonly) BOOL isWarnEnabled;
@property (nonatomic, readonly) BOOL isErrorEnabled;

- (BOOL)isLevelEnabled:(DRYLogLevel)level;

- (void)trace:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)debug:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)info:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)warn:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)error:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (void)addAppender:(id<DRYLoggingAppender>)appender;
- (void)removeAppender:(id <DRYLoggingAppender>)appender;

@end
