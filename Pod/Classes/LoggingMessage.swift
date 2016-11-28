//
//  LoggingMessage.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation


/// Value object, holding log message information.
///
/// - since: 3.0
public struct LoggingMessage {
    
    /// The message that should be logged.
    public let message: String
    
    /// The log level on which this message should be logged.
    public let level: LogLevel
    
    /// The name of the logger that created this message.
    public let loggerName: String
    
    /// The name of the framework/module for which a logger created this log message.
    public let framework: String
    
    /// The name of the class for which a logger created this log message.
    public let className: String
    
    /// The name of the class for which a logger created this log message.
    public let fileName: String
    
    /// The name of the method for which a logger created this log message.
    public let methodName: String
    
    /// The memory address of the caller for which a logger created this log message.
    public let memoryAddress: String
    
    /// The byte offset in the caller for which a logger created this log message.
    public let byteOffset: String
    
    /// The name of the thread in which this message was created.
    public let threadName: String
    
    /// The line number of the code on which this message was created.
    public let lineNumber: Int
    
    /// The date of the creation of this message.
    public let date: Date
    
    /// Designated initializer, initializing all fields.
    public init(message: String, level: LogLevel, loggerName: String, framework: String, className: String, fileName: String, methodName: String, memoryAddress: String, byteOffset: String, threadName: String, lineNumber: Int, date: Date) {
        self.message = message
        self.level = level
        self.loggerName = loggerName
        self.framework = framework
        self.className = className
        self.fileName = fileName
        self.methodName = methodName
        self.memoryAddress = memoryAddress
        self.byteOffset = byteOffset
        self.threadName = threadName
        self.lineNumber = lineNumber
        self.date = date
    }
}

extension LoggingMessage : Equatable {
    /// Makes the LoggingMessage equatable.
    ///
    /// - returns true when all fields match, false otherwise
    public static func ==(lhs: LoggingMessage, rhs: LoggingMessage) -> Bool {
        return lhs.message == rhs.message &&
            lhs.level == rhs.level &&
            lhs.loggerName == rhs.loggerName &&
            lhs.framework == rhs.framework &&
            lhs.className == rhs.className &&
            lhs.fileName == rhs.fileName &&
            lhs.methodName == rhs.methodName &&
            lhs.memoryAddress == rhs.memoryAddress &&
            lhs.byteOffset == rhs.byteOffset &&
            lhs.threadName == rhs.threadName &&
            lhs.lineNumber == rhs.lineNumber &&
            lhs.date == rhs.date
    }
}
