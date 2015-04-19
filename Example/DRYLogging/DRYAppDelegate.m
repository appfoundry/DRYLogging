//
//  DRYAppDelegate.m
//  DRYLogging
//
//  Created by CocoaPods on 04/09/2015.
//  Copyright (c) 2014 Michael Seghers. All rights reserved.
//

#import <DRYLogging/NSString+DRYLoggingLevelAdditions.h>
#import <DRYLogging/DRYLogging.h>
#import "DRYAppDelegate.h"

@interface DRYAppDelegate () {
    id<DRYLogger> _logger;
}
@end

@implementation DRYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self _prepareConsoleAppenderOnRootLoggerWithExtendedFormatter];
    [self _prepareFilteredConsoleAppenderOnRoorLoggerForErrorMessages];
    [self _prepareViewControllerParentLoggerToHaveLogLevelTrace];

    //Example on how to get a logger, and log a message.
    //Since we've setup the root logger with a console appender, and the default log level of a logger is set to info,
    //this message will be printed to the console with the configured format. (see _prepareConsoleAppenderOnRootLoggerWithExtendedFormatter)
    _logger = [DRYLoggerFactory loggerWithName:@"application.DRYAppDelegate"];
    [_logger info:@"Application did finish launching, this message should be printed, as the AppDelegate logger inherits from the root logger, which by default has INFO level logging"];

    DRYTrace(_logger, @"%@: Example of a trace logging, but should not be visible in the logs", @1);
    DRYDebug(_logger, @"%@: Example of a debug logging, but should not be visible in the logs", @2);
    DRYInfo(_logger, @"%@: Example of info logging, should be visible in the logs", @3);
    DRYWarn(_logger, @"%@: Example of warn logging, should be visible in the logs", @4);
    DRYError(_logger, @"%@: Example of error logging, should be appended to the console and the file, since two appenders will accept this message, as long as the default level is kept for the root logger", @5);

    return YES;
}

- (void)_prepareViewControllerParentLoggerToHaveLogLevelTrace {
    id <DRYLogger> viewControllerLoggers = [DRYLoggerFactory loggerWithName:@"viewcontroller"];
    viewControllerLoggers.level = DRYLogLevelTrace;
}

- (void)_prepareFilteredConsoleAppenderOnRoorLoggerForErrorMessages {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat =  @"yyyy-MM-dd HH:mm:ss.SSS";
    id <DRYLoggingMessageFormatter> filterFormatter = [DRYBlockBasedLoggingMessageFormatter formatterWithFormatterBlock:^NSString *(DRYLoggingMessage *message) {
        return [NSString stringWithFormat:@"[%@] ERRORS ONLY <%@> - %@", [df stringFromDate:message.date], message.lineNumber, message.message];
    }];
    id<DRYLoggingAppender> errorAppender = [[DRYLoggingFileAppender alloc] initWithFormatter:filterFormatter];
    DRYLoggingAppenderLevelFilter *filter = [[DRYLoggingAppenderLevelFilter alloc] init];
    filter.level = DRYLogLevelError;
    [errorAppender addFilter:filter];
    [[DRYLoggerFactory rootLogger] addAppender:errorAppender];
}

- (void)_prepareConsoleAppenderOnRootLoggerWithExtendedFormatter {
    id <DRYLoggingMessageFormatter> formatter = [DRYBlockBasedLoggingMessageFormatter formatterWithFormatterBlock:^NSString *(DRYLoggingMessage *message) {
        return [NSString stringWithFormat:@"%@ -[%@ %@] <%@> + %@ - %@ - (%@)", [NSString stringFromDRYLoggingLevel:message.level], message.className, message.methodName, message.lineNumber, message.byteOffset, message.message, message.loggerName];
    }];
    id<DRYLoggingAppender> appender = [[DRYLoggingConsoleAppender alloc] initWithFormatter:formatter];
    [[DRYLoggerFactory rootLogger] addAppender:appender];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [_logger info:@"Application is resigning active"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_logger info:@"Application did enter background"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_logger info:@"Application will enter foreground"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [_logger info:@"Application did become active"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [_logger info:@"Application will terminate"];
}

@end
