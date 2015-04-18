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
#import "DRYLoggingRoller.h"
#import "DRYLoggingRollerPredicate.h"
#import "DRYLoggingAppenderFilter.h"

#import "DRYBlockBasedLoggingMessageFormatter.h"
#import "DRYLoggingConsoleAppender.h"
#import "DRYLoggingFileAppender.h"
#import "DRYLoggingAppenderLevelFilter.h"
#import "DRYLoggingSizeRollerPredicate.h"
#import "DRYLoggingBackupRoller.h"

#ifndef Pods_DRYLogging_h
#define Pods_DRYLogging_h

#define _DRYLog(LOGGER, LEVEL, ...) [(LOGGER) LEVEL##WithLineNumber:(__LINE__) format:__VA_ARGS__]

/**
 *  Calls the given logger's traceWithLineNumber:format: method, using the current line number of the code on which this call is made and the given format.
 *
 *  @since 1.1
 */
#define DRYTrace(logger, ...) _DRYLog(logger, trace, __VA_ARGS__)

/**
 *  Calls the given logger's debugWithLineNumber:format: method, using the current line number of the code on which this call is made and the given format.
 *
 *  @since 1.1
 */
#define DRYDebug(logger, ...) _DRYLog(logger, debug, __VA_ARGS__)

/**
 *  Calls the given logger's infoWithLineNumber:format: method, using the current line number of the code on which this call is made and the given format.
 *
 *  @since 1.1
 */
#define DRYInfo(logger, ...) _DRYLog(logger, info, __VA_ARGS__)

/**
 *  Calls the given logger's warnWithLineNumber:format: method, using the current line number of the code on which this call is made and the given format.
 *
 *  @since 1.1
 */
#define DRYWarn(logger, ...) _DRYLog(logger, warn, __VA_ARGS__)

/**
 *  Calls the given logger's errorWithLineNumber:format: method, using the current line number of the code on which this call is made and the given format.
 *
 *  @since 1.1
 */
#define DRYError(logger, ...) _DRYLog(logger, error, __VA_ARGS__)

#endif
