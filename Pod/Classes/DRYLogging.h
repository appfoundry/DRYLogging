//
//  DRYLogging.h
//  Pods
//
//  Created by Michael Seghers on 15/04/15.
//
//

#import "DRYLogger.h"
#import "DRYLoggingMessageFormatter.h"
#import "DRYLoggingAppender.h"

#import "DRYLoggerFactory.h"
#import "DRYLoggingMessage.h"

#import "DRYBlockBasedLoggingMessageFormatter.h"
#import "DRYLoggingConsoleAppender.h"

#ifndef Pods_DRYLogging_h
#define Pods_DRYLogging_h

#define DRYLog(logger, level, format, ...) [(logger) level:(format), __VA_ARGS__]
#define DRYTrace(logger, format, ...) DRYLog(logger, trace, format, __VA_ARGS__)
#define DRYDebug(logger, format, ...) DRYLog(logger, debug, format, __VA_ARGS__)
#define DRYInfo(logger, format, ...) DRYLog(logger, info, format, __VA_ARGS__)
#define DRYWarn(logger, format, ...) DRYLog(logger, error, format, __VA_ARGS__)
#define DRYError(logger, format, ...) DRYLog(logger, warn, format, __VA_ARGS__)

#endif
