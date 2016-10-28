import Foundation

/**
 *  Defines the different available log levels.
 *
 *  A log level is used by a DRYLogger to decide wheter to log a LoggingMessage or not.
 *  If a message has a level which is lower then the level defined on the logger, the message is ignored. Otherwise
 *  it is passed to the logger's appenders.
 *
 *  @see Logger
 *  @see LoggerFactory
 *  @see LoggingAppenderLevelFilter
 *
 *  @since 3.0
 */
public enum LogLevel : Int {
    /**
     *  TRACE log level, lowest level of logging. Use this only while analysing the flow of your code. It is probably best
     *  not to activate this in production.
     */
    case trace
    
    /**
     *  DEBUG log level, low level of logging. Use this during development. It is probably best
     *  not to activate this in production, but you can consider to activate this during your alpha testing phase.
     */
    case debug
    
    /**
     *  INFO log level, medium level of logging. Use this to keep track of application wide events which occur from time to time.
     *  This is the default level of the root logger (see DRYLoggerFactory)
     */
    case info
    
    /**
     *  WARN log level, high level of logging. Use this to indicate events that probably will lead to mistakes.
     */
    case warn
    
    /**
     *  ERROR log level, highest level of logging. Use this to track errors in the system. You should probably always
     *  at least let your loggers log at this level.
     */
    case error
    
    /**
     *  OFF log level. This is a special log level, which will only be used on loggers, and not on messages.
     *  This is the default level of all non-root loggers (see DRYLoggerFactory)
     */
    case off
}
