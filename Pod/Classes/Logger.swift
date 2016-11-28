//
//  Logger.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/// A logger transforms format strings into LoggingMessage instances and sends them to its appenders,
/// only if the logger's level is lower or equal to the message's level. Loggers *can and should* be created through the
/// LoggerFactory class.
///
/// #About message creation#
///
/// A logger will creates a message, based on the information that is passed to it and information that it can
/// aquire from the system at runtime. Check the LoggingMessage class to get more info about the information that is
/// stored inside such a message
///
/// # About a logger's level
///
/// A logger will only create a message and append it on it's appenders if the logger's level is lower or equal to the
/// message's level. The level of the logger is can be changed at runtime through the level property. By default, the
/// LoggerFactory will set this level to:
///
/// * LogLevel.info for the root logger
/// * LogLevel.off for all other loggers
///
/// When a logger's level is set to .off, it will refer to its parent logger in order to decide whether or not to create and
/// append the message. Otherwise it will check if the message's level is higher or equal to its own level.
///
/// The following table should clarify this (X means a message is created and appended):
///
/// ----------------------------------------------------------------------
/// | Logger level / Message level | TRACE | DEBUG | INFO | WARN | ERROR |
/// ----------------------------------------------------------------------
/// |           TRACE              |   X   |   X   |   X  |  X   |   X   |
/// ----------------------------------------------------------------------
/// |           DEBUG              |   /   |   X   |   X  |  X   |   X   |
/// ----------------------------------------------------------------------
/// |           INFO               |   /   |   /   |   X  |  X   |   X   |
/// ----------------------------------------------------------------------
/// |           WARN               |   /   |   /   |   /  |  X   |   X   |
/// ----------------------------------------------------------------------
/// |           ERROR              |   /   |   /   |   /  |  /   |   X   |
/// ----------------------------------------------------------------------
/// |            OFF               | Decided by the parent logger        |
/// |                              | If the logger happens to be root    |
/// |                              | logger, nothing will be logged.     |
/// ----------------------------------------------------------------------
///
/// # About appenders
///
/// A logger can hold a collection of appenders, which will be called in the order in which they were added to the logger, if it
/// decides to log the message (see above). A logger will also pass the message to its parent logger's appenders and so on.
/// Mark that the parent's level is not checked during this process. This comes in handy: you don't need to add the same appender
/// to all loggers, just add the appender to a common ancestor (such as the root logger), and all descendant loggers will append there
/// messages as they see fit.
///
/// You should also check out the DRYLogging test code and the sample code to see how these mechanisms work together.
///
/// # About log method
///
/// Logger instances provide log method such as trace(_:). These methods check if this logger's level
/// allows the level specified in the method name. If so, a LoggingMessage is created with:
///
/// * level based on the method's name
/// * message derived from the given format
/// * loggerName equal to this logger's name
/// * lineNumber from the given lineNumber or 0
/// * info from the thread on which this method is called
///
/// It is highly recomended not to override the default values of these method's default parameters. The defaults will allow shorter syntax, and guarantee the correct parameters to be passed in to the appropriate log methods.
///
/// - SeeAlso:
///     - LoggingMessage
///     - LoggerFactory
/// - Since: 3.0
public protocol Logger {
    /// The name will be set as loggerName property on created LoggingMessage instances.
    var name: String { get }
    
    /// The parent logger of this logger.
    ///
    /// - seealso: level
    /// - seealso: appenders
    var parent: Logger? { get }
    
    /// A logger appends messages to all its appenders and those of its parents, if its level is lower or equal to the message's level.
    /// Also see the genaral discussion of this protocol.
    var appenders: [LoggingAppender] { get }
    
    /// The level of a logger is used to decide wether or not to append a message to its appenders, by comparing the message's level to this level.
    /// It will log the message only if its level is lower or equal to the message's level. If a logger has a level of OFF, its parent
    /// will be consulted, and so on. Also see the genaral discussion of this protocol.
    var logLevel: LogLevel { get set }
    
    
    /// Convenience property to check if a logger will log trace message.
    ///
    /// Also see the genaral discussion of this protocol.
    ///
    /// - SeeAlso: isLevelEnabled
    var isTraceEnabled: Bool { get }
    
    /// Convenience property to check if a logger will log debug message.
    ///
    /// Also see the genaral discussion of this protocol.
    ///
    /// - SeeAlso: isLevelEnabled
    var isDebugEnabled: Bool { get }
    
    /// Convenience property to check if a logger will log info message.
    ///
    /// Also see the genaral discussion of this protocol.
    ///
    /// - SeeAlso: isLevelEnabled
    var isInfoEnabled: Bool { get }
    
    /// Convenience property to check if a logger will log warn message.
    ///
    /// Also see the genaral discussion of this protocol.
    ///
    /// - SeeAlso: isLevelEnabled
    var isWarnEnabled: Bool { get }
    
    /// Convenience property to check if a logger will log error message.
    ///
    /// Also see the genaral discussion of this protocol.
    ///
    /// - SeeAlso: isLevelEnabled
    var isErrorEnabled: Bool { get }
    
    /// Check if a logger will log messages of the given level.
    ///
    /// - Parameter level: the level to check against this logger's level
    ///
    /// - Returns: true if this logger's level is lower or equal to the given level. If this logger's level is LogLevel.off, the parent logger will be consulted, if there is one.
    func isLevelEnabled(_ level: LogLevel) -> Bool
    
    ///Check if a logger will log messages of the given level. If so, a LoggingMessage is created with:
    func log(level: LogLevel, message: String, lineNumber: Int, function: String, file: String)
    
    
    /// Adds an appender to this logger.
    ///
    /// Also see the genaral discussion of this protocol.
    func add(appender: LoggingAppender)
    
    /// Removes an appender from this logger.
    ///
    /// Also see the genaral discussion of this protocol.
    func remove(appender: LoggingAppender)
    
}

public extension Logger {
    /// Check if this logger's level allows trace messages. If so, a LoggingMessage is created with:
    ///
    /// * level LogLevel.trace
    /// * message derived from the given format
    /// * loggerName equal to this logger's name
    /// * lineNumber from the given lineNumber
    /// * info from the thread on which this method is called
    ///
    /// It is recomended only to pass in a message, and not override any of the default values
    ///
    /// - parameter message: the message format
    func trace(_ message: String, lineNumber: Int = #line, function: String = #function, file: String = #file) {
        self.log(level: LogLevel.trace, message: message, lineNumber: lineNumber, function: function, file: file)
    }
    
    /// Check if this logger's level allows debug messages. If so, a LoggingMessage is created with:
    ///
    /// * level LogLevel.debug
    /// * message derived from the given format
    /// * loggerName equal to this logger's name
    /// * lineNumber from the given lineNumber
    /// * info from the thread on which this method is called
    ///
    /// It is recomended only to pass in a message, and not override any of the default values
    ///
    /// - parameter message: the message format
    func debug(_ message: String, lineNumber: Int = #line, function: String = #function, file: String = #file) {
        self.log(level: LogLevel.debug, message: message, lineNumber: lineNumber, function: function, file: file)
    }
    
    /// Check if this logger's level allows info messages. If so, a LoggingMessage is created with:
    ///
    /// * level LogLevel.info
    /// * message derived from the given format
    /// * loggerName equal to this logger's name
    /// * lineNumber from the given lineNumber
    /// * info from the thread on which this method is called
    ///
    /// It is recomended only to pass in a message, and not override any of the default values
    ///
    /// - parameter message: the message format
    func info(_ message: String, lineNumber: Int = #line, function: String = #function, file: String = #file) {
        self.log(level: LogLevel.info, message: message, lineNumber: lineNumber, function: function, file: file)
    }
    
    /// Check if this logger's level allows warn messages. If so, a LoggingMessage is created with:
    ///
    /// * level LogLevel.warn
    /// * message derived from the given format
    /// * loggerName equal to this logger's name
    /// * lineNumber from the given lineNumber
    /// * info from the thread on which this method is called
    ///
    /// It is recomended only to pass in a message, and not override any of the default values
    ///
    /// - parameter message: the message format
    func warn(_ message: String, lineNumber: Int = #line, function: String = #function, file: String = #file) {
        self.log(level: LogLevel.warn, message: message, lineNumber: lineNumber, function: function, file: file)
    }
    
    /// Check if this logger's level allows error messages. If so, a LoggingMessage is created with:
    ///
    /// * level LogLevel.error
    /// * message derived from the given format
    /// * loggerName equal to this logger's name
    /// * lineNumber from the given lineNumber
    /// * info from the thread on which this method is called
    ///
    /// It is recomended only to pass in a message, and not override any of the default values
    ///
    /// - parameter message: the message format
    func error(_ message: String, lineNumber: Int = #line, function: String = #function, file: String = #file) {
        self.log(level: LogLevel.error, message: message, lineNumber: lineNumber, function: function, file: file)
    }
    
    ///Append the given message to the given logger's appenders, and then recurse up the parent chain
    static func append(message: LoggingMessage, toLogger logger: Logger) {
        for appender in logger.appenders {
            appender.append(message: message)
        }
        
        if let parent = logger.parent {
            self.append(message: message, toLogger: parent)
        }
    }
}
