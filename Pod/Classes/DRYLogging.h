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
 *  @since 1.2
 */
#define DRYLogger(NAME) [DRYLoggerFactory loggerWithName:(NAME)]

/**
 *  Creates a static variable called LOGGER, initialized with the given name.
 *
 *  @since 1.2
 */
#define DRYClassLogger(NAME) \
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
 *  @since 1.1
 */
#define DRYTrace(logger, ...) _DRYLog(logger, trace, __VA_ARGS__)

/**
 *  Calls the logger created by the DRYClassLogger macro its traceWithLineNumber:format: method, using the current
 *  line number and the given format.
 *
 *  @since 1.2
 */
#define dryTrace(...) DRYTrace(LOGGER, __VA_ARGS__)

/**
 *  Calls the given logger's debugWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 1.1
 */
#define DRYDebug(logger, ...) _DRYLog(logger, debug, __VA_ARGS__)

/**
 *  Calls the logger created by the DRYClassLogger macro its debugWithLineNumber:format: method, using the current
 *  line number and the given format.
 *
 *  @since 1.2
 */
#define dryDebug(...) DRYDebug(LOGGER, __VA_ARGS__)

/**
 *  Calls the given logger's infoWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 1.1
 */
#define DRYInfo(logger, ...) _DRYLog(logger, info, __VA_ARGS__)

/**
 *  Calls the logger created by the DRYClassLogger macro its infoWithLineNumber:format: method, using the current
 *  line number and the given format.
 *
 *  @since 1.2
 */
#define dryInfo(...) DRYInfo(LOGGER, __VA_ARGS__)

/**
 *  Calls the given logger's warnWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 1.1
 */
#define DRYWarn(logger, ...) _DRYLog(logger, warn, __VA_ARGS__)

/**
 *  Calls the given logger's warnWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 1.2
 */
#define dryWarn(...) DRYWarn(LOGGER, __VA_ARGS__)

/**
 *  Calls the given logger's errorWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 1.1
 */
#define DRYError(logger, ...) _DRYLog(logger, error, __VA_ARGS__)

/**
 *  Calls the given logger's errorWithLineNumber:format: method, using the current line number and the given format.
 *
 *  @since 1.2
 */
#define dryError(...) DRYError(LOGGER, __VA_ARGS__)

#endif
