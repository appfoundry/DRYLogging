//
//  NSString+DRYLoggingLevelAdditions.m
//  Pods
//
//  Created by Michael Seghers on 13/04/15.
//
//

#import "NSString+DRYLoggingLevelAdditions.h"
#import "DRYLogger.h"

@implementation NSString (DRYLoggingLevelAdditions)
+ (instancetype)stringFromDRYLoggingLevel:(DRYLogLevel)level {
    NSString *levelString;
    switch (level) {
        case DRYLogLevelTrace:
            levelString = @"TRACE";
            break;
        case DRYLogLevelDebug:
            levelString = @"DEBUG";
            break;
        case DRYLogLevelInfo:
            levelString = @"INFO";
            break;
        case DRYLogLevelWarn:
            levelString = @"WARN";
            break;
        case DRYLogLevelError:
            levelString = @"ERROR";
            break;
        case DRYLogLevelOff:
            levelString = @"OFF";
            break;
    }
    return levelString;
}


@end
