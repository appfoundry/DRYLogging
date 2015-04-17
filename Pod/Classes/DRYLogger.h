//
//  DRYLogger.h
//  Pods
//
//  Created by Michael Seghers on 09/04/15.
//
//

#import <Foundation/Foundation.h>

@protocol DRYLoggingAppender;

/**
 *  Defines the different available log levels.
 *  
 *  A log level is used by a DRYLogger to decide wheter to log a DRYLoggingMessage or not. 
 *  If a message has a level which is lower then the level defined on the logger, the message is ignored. Otherwise 
 *  it is passed to the logger's appenders.
 *
 *  @see DRYLogger
 *  @see DRYLoggerFactory
 *  @see DRYLoggingAppenderLevelFilter
 *
 *  @since 1.0
 */
typedef NS_ENUM(NSInteger, DRYLogLevel){
    /**
     *  TRACE log level, lowest level of logging. Use this only while analysing the flow of your code. It is probably best 
     *  not to activate this in production.
     */
    DRYLogLevelTrace,
    /**
     *  DEBUG log level, low level of logging. Use this during development. It is probably best
     *  not to activate this in production, but you can consider to activate this during your alpha testing phase.
     */
    DRYLogLevelDebug,
    /**
     *  INFO log level, medium level of logging. Use this to keep track of application wide events which occur from time to time.
     *  This is the default level of the root logger (see DRYLoggerFactory)
     */
    DRYLogLevelInfo,
    /**
     *  WARN log level, high level of logging. Use this to indicate events that probably will lead to mistakes.
     */
    DRYLogLevelWarn,
    /**
     *  ERROR log level, highest level of logging. Use this to track errors in the system. You should probably always
     *  at least let your loggers log at this level.
     */
    DRYLogLevelError,
    /**
     *  OFF log level. This is a special log level, which will only be used on loggers, and not on messages. 
     *  This is the default level of all non-root loggers (see DRYLoggerFactory)
     */
    DRYLogLevelOff
};

/**
 *  A logger transforms format strings into DRYLoggingMessage instances and sends them to its appenders, 
 *  only if the logger's level is lower or equal to the message's level. Loggers *can and should* be created through the
 *  DRYLoggerFactory class.
 *
 *  #About message creation#
 *
 *  A logger will creates a message, based on the information that is passed to it and information that it can 
 *  aquire from the system at runtime. Check the DRYLoggingMessage class to get more info about the information that is 
 *  stored inside such a message
 *
 *  #About a logger's level#
 *
 *  A logger will only create a message and append it on it's appenders if the logger's level is lower or equal to the 
 *  message's level. The level of the logger is can be changed at runtime through the level property. By default, the 
 *  DRYLoggerFactory will set this level to:
 *  
 *  * DRYLogLevelInfo for the root logger
 *  * DRYLogLevelOff for all other loggers
 *  
 *  When a logger's level is set to OFF, it will refer to its parent logger in order to decide whether or not to create and 
 *  append the message. Otherwise it will check if the message's level is higher or equal to its own level.
 *
 *  The following table should clarify this (X means a message is created and appended):
 *
 *  ----------------------------------------------------------------------
 *  | Logger level / Message level | TRACE | DEBUG | INFO | WARN | ERROR |
 *  ----------------------------------------------------------------------
 *  |           TRACE              |   X   |   X   |   X  |  X   |   X   |
 *  ----------------------------------------------------------------------
 *  |           DEBUG              |   /   |   X   |   X  |  X   |   X   |
 *  ----------------------------------------------------------------------
 *  |           INFO               |   /   |   /   |   X  |  X   |   X   |
 *  ----------------------------------------------------------------------
 *  |           WARN               |   /   |   /   |   /  |  X   |   X   |
 *  ----------------------------------------------------------------------
 *  |           ERROR              |   /   |   /   |   /  |  /   |   X   |
 *  ----------------------------------------------------------------------
 *  |            OFF               | Decided by the parent logger        |
 *  |                              | If the logger happens to be root    |
 *  |                              | logger, nothing will be logged.     |
 *  ----------------------------------------------------------------------
 *
 *  #About appenders#
 *
 *  A logger can hold a collection of appenders, which will be called in order in which they were added to the logger, if it
 *  decides to log the message (see above). A logger will also pass the message to its parent logger's appenders and so on.
 *  Mark that the parent's level is not checked during this process. This comes in handy: you don't need to add the same appender 
 *  to all loggers, just add the appender to a common ancestor (such as the root logger), and all descendant loggers will append there 
 *  messages as they see fit.
 *  
 *  You should also check out the DRYLogging test code and the sample code to see how these mechanisms work together.
 *
 *  #About log method#
 *
 *  DRYLogger instances provide log method such as trace: or traceWithLineNumber:format:. These methods check if this logger's level 
 *  allows the level specified in the method name. If so, a DRYLoggingMessage is created with:
 *
 *  * level based on the method's name
 *  * message derived from the given format
 *  * loggerName equal to this logger's name
 *  * lineNumber from the given lineNumber or 0
 *  * info from the thread on which this method is called
 * 
 *  It is highly recomended to use the macros defined in the DRYLogging.h header file as a standin replacement for the direct method calls 
 *  on logger. These macros will allow shorter syntax, and guarantee the correct parameters to be passed in to the appropriate log methods. 
 * These macros are:
 *
 *  * DRYTrace
 *  * DRYDebug
 *  * DRYInfo
 *  * DRYWarn
 *  * DRYError
 *
 *  @see DRYLoggingMessage
 *  @see DRYLoggerFactory
 *  @since 1.0
 */
@protocol DRYLogger <NSObject>

/**
 *  The name will be set as loggerName property on created DRYLoggingMessage instances.
 */
@property (nonatomic, readonly) NSString *name;

/**
 *  The parent logger of this logger.
 *
 *  @see level
 *  @see appenders
 */
@property (nonatomic, readonly) id <DRYLogger> parent;

/**
 *  A logger appends messages to all its appenders and those of its parents, if its level is lower or equal to the message's level.
 *  Also see the genaral discussion of this protocol.
 */
@property (nonatomic, readonly, copy) NSArray *appenders;


/**
 *  The level of a logger is used to decide wether or not to append a message to its appenders, by comparing the message's level to this level. 
 *  It will log the message only if its level is lower or equal to the message's level. If a logger has a level of OFF, its parent
 *  will be consulted, and so on. Also see the genaral discussion of this protocol.
 */
@property (nonatomic) DRYLogLevel level;

/**
 *  Convenience property to check if a logger will log trace message.
 *
 *  Also see the genaral discussion of this protocol.
 *
 *  @see isLevelEnabled:
 */
@property (nonatomic, readonly) BOOL isTraceEnabled;

/**
 *  Convenience property to check if a logger will log debug message.
 *
 *  Also see the genaral discussion of this protocol.
 *
 *  @see isLevelEnabled:
 */
@property (nonatomic, readonly) BOOL isDebugEnabled;

/**
 *  Convenience property to check if a logger will log info message.
 *
 *  Also see the genaral discussion of this protocol.
 *
 *  @see isLevelEnabled:
 */
@property (nonatomic, readonly) BOOL isInfoEnabled;

/**
 *  Convenience property to check if a logger will log warn message.
 *
 *  Also see the genaral discussion of this protocol.
 *
 *  @see isLevelEnabled:
 */
@property (nonatomic, readonly) BOOL isWarnEnabled;

/**
 *  Convenience property to check if a logger will log error message.
 *
 *  Also see the genaral discussion of this protocol.
 *
 *  @see isLevelEnabled:
 */
@property (nonatomic, readonly) BOOL isErrorEnabled;

/**
 *  Check if a logger will log messages of the given level.
 *
 *  @param level the level to check against this logger's level
 *
 *  @return YES if this logger's level is lower or equal to the given level. If this logger's level is DRYLogLevelOff, the parent logger will be consulted, if there is one.
 */
- (BOOL)isLevelEnabled:(DRYLogLevel)level;

/**
 *  Check if this logger's level allows trace messages. If so, a DRYLoggingMessage is created with:
 *
 *  It is recomended to use the DRYTrace macro
 *
 *  * level DRYLogLevelTrace
 *  * message derived from the given format
 *  * loggerName equal to this logger's name
 *  * lineNumber 0
 *  * info from the thread on which this method is called
 *
 *  @param format the message format
 */
- (void)trace:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
 *  Check if this logger's level allows trace messages. If so, a DRYLoggingMessage is created with:
 *
 *  It is recomended to use the DRYTrace macro
 *
 *  * level DRYLogLevelTrace
 *  * message derived from the given format
 *  * loggerName equal to this logger's name
 *  * lineNumber from the given lineNumber
 *  * info from the thread on which this method is called
 *
 *  @param lineNumber The line number of the code which calls this method
 *  @param format the message format
 */
- (void)traceWithLineNumber:(int)lineNumber format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

/**
 *  Like trace: but for DRYLogLevelDebug
 */
- (void)debug:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
 *  Like traceWithLineNumber:format: but for DRYLogLevelDebug
 */
- (void)debugWithLineNumber:(int)lineNumber format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

/**
 *  Like trace: but for DRYLogLevelInfo
 */
- (void)info:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
 *  Like traceWithLineNumber:format: but for DRYLogLevelInfo
 */
- (void)infoWithLineNumber:(int)lineNumber format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

/**
 *  Like trace: but for DRYLogLevelWarn
 */
- (void)warn:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
 *  Like traceWithLineNumber:format: but for DRYLogLevelWarn
 */
- (void)warnWithLineNumber:(int)lineNumber format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

/**
 *  Like trace: but for DRYLogLevelError
 */
- (void)error:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
 *  Like traceWithLineNumber:format: but for DRYLogLevelError
 */
- (void)errorWithLineNumber:(int)lineNumber format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

/**
 *  Adds an appender to this logger.
 *
 *  Also see the genaral discussion of this protocol.
 */
- (void)addAppender:(id<DRYLoggingAppender>)appender;

/**
 *  Removes an appender from this logger.
 *
 *  Also see the genaral discussion of this protocol.
 */
- (void)removeAppender:(id <DRYLoggingAppender>)appender;

@end
