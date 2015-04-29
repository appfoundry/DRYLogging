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

/**
 *  Shorthand for creating a logger through the DRYLoggerFactory's static interface.
 *
 *  @since 2.0
 */
#define DRYLogger(NAME) [DRYLoggerFactory loggerWithName:(NAME)]

/**
 *  Creates a static variable called LOGGER, initialized with the given name.
 *
 *  @since 2.0
 */
#define DRYInitializeStaticLogger(NAME) \
static id<DRYLogger> LOGGER; \
\
__attribute__((constructor)) \
static void dryInitialize_DRYLogger() { \
    LOGGER = DRYLogger(NAME); \
}


#define _DRYLog(LOGGER, LEVEL, ...) [(LOGGER) LEVEL##WithLineNumber:(__LINE__) format:__VA_ARGS__]

/**
 *  Calls the given logger's traceWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 2.0
 */
#define DRYTraceOnLogger(logger, ...) _DRYLog(logger, trace, __VA_ARGS__)

/**
 *  Calls the logger created by the DRYInitializeStaticLogger macro its traceWithLineNumber:format: method, using the current
 *  line number and the given format.
 *
 *  @since 2.0
 */
#define DRYTrace(...) DRYTraceOnLogger(LOGGER, __VA_ARGS__)

/**
 *  Calls the given logger's debugWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 2.0
 */
#define DRYDebugOnLogger(logger, ...) _DRYLog(logger, debug, __VA_ARGS__)

/**
 *  Calls the logger created by the DRYInitializeStaticLogger macro its debugWithLineNumber:format: method, using the current
 *  line number and the given format.
 *
 *  @since 2.0
 */
#define DRYDebug(...) DRYDebugOnLogger(LOGGER, __VA_ARGS__)

/**
 *  Calls the given logger's infoWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 2.0
 */
#define DRYInfoOnLogger(logger, ...) _DRYLog(logger, info, __VA_ARGS__)

/**
 *  Calls the logger created by the DRYInitializeStaticLogger macro its infoWithLineNumber:format: method, using the current
 *  line number and the given format.
 *
 *  @since 2.0
 */
#define DRYInfo(...) DRYInfoOnLogger(LOGGER, __VA_ARGS__)

/**
 *  Calls the given logger's warnWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 2.0
 */
#define DRYWarnOnLogger(logger, ...) _DRYLog(logger, warn, __VA_ARGS__)

/**
 *  Calls the given logger's warnWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 2.0
 */
#define DRYWarn(...) DRYWarnOnLogger(LOGGER, __VA_ARGS__)

/**
 *  Calls the given logger's errorWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 2.0
 */
#define DRYErrorOnLogger(logger, ...) _DRYLog(logger, error, __VA_ARGS__)

/**
 *  Calls the given logger's errorWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 2.0
 */
#define DRYError(...) DRYErrorOnLogger(LOGGER, __VA_ARGS__)

#endif
