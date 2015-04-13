//
//  DRYAppDelegate.m
//  DRYLogging
//
//  Created by CocoaPods on 04/09/2015.
//  Copyright (c) 2014 Michael Seghers. All rights reserved.
//

#import <DRYLogging/NSString+DRYLoggingLevelAdditions.h>
#import "DRYAppDelegate.h"
#import "DRYDefaultLogger.h"
#import "DRYLoggingConsoleAppender.h"
#import "DRYLoggingMessageFormatter.h"
#import "DRYBlockBasedLoggingMessageFormatter.h"
#import "DRYLoggingMessage.h"
#import "DRYLoggerFactory.h"

@interface DRYAppDelegate () {
    id<DRYLogger> _logger;
}
@end

@implementation DRYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    id <DRYLoggingMessageFormatter> formatter = [DRYBlockBasedLoggingMessageFormatter formatterWithFormatterBlock:^NSString *(DRYLoggingMessage *message) {
        return [NSString stringWithFormat:@"%@ -[%@ %@] + %@ - %@ - (%@)", [NSString stringFromDRYLoggingLevel:message.level], message.className, message.methodName, message.byteOffset, message.message, message.loggerName];
    }];
    id<DRYLoggingAppender> appender = [[DRYLoggingConsoleAppender alloc] initWithFormatter:formatter];
    [[DRYLoggerFactory rootLogger] addAppender:appender];

    _logger = [DRYLoggerFactory loggerWithName:@"application.DRYAppDelegate"];
    [_logger info:@"Application did finish launching, this message should be printed, as the AppDelegate logger inherits from the root logger, which by default has INFO level logging"];


    id <DRYLogger> viewControllerLoggers = [DRYLoggerFactory loggerWithName:@"viewcontroller"];
    viewControllerLoggers.level = DRYLogLevelTrace;

    [_logger trace:@"Example of a trace logging %@, but should not be visible in the logs, as long as the default level is kept for the root logger", @1];
    [_logger debug:@"Example of a debug logging %@, but should not be visible in the logs, as long as the default level is kept for the root logger", @2];
    [_logger info:@"Example of info logging %@, should be visible in the logs, as long as the default level is kept for the root logger", @3];
    [_logger warn:@"Example of warn logging %@, should be visible in the logs, as long as the default level is kept for the root logger", @4];
    [_logger error:@"Example of error logging %@, should be visible in the logs, as long as the default level is kept for the root logger", @5];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [_logger info:@"Application %@ is resigning active", application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_logger info:@"Application %@ did enter background", application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_logger info:@"Application %@ will enter foreground", application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [_logger info:@"Application %@ did become active", application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [_logger info:@"Application %@ will terminate", application];
}

@end
