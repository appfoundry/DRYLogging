//
//  LoggingMessage.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/**
 *  Value object, holding log message information.
 *
 *  @since 3.0
 */
public struct LoggingMessage {
    /**
     *  The message that should be logged.
     */
    public let message: String
    
    /**
     *  The log level on which this message should be logged.
     */
    public let level: LogLevel
    
    
    /**
     *  The name of the logger that created this message.
     */
    public let loggerName: String
    
    
    /**
     *  The name of the framework/module for which a logger created this log message.
     */
    public let framework: String
    
    
    /**
     *  The name of the class for which a logger created this log message.
     */
    public let className: String
    
    /**
     *  The name of the class for which a logger created this log message.
     */
    public let fileName: String
    
    
    /**
     *  The name of the method for which a logger created this log message.
     */
    public let methodName: String
    
    /**
     *  The memory address of the caller for which a logger created this log message.
     */
    public let memoryAddress: String
    
    
    /**
     *  The byte offset in the caller for which a logger created this log message.
     */
    public let byteOffset: String
    
    
    /**
     *  The name of the thread in which this message was created.
     */
    public let threadName: String
    
    
    /**
     *  The line number of the code on which this message was created.
     */
    public let lineNumber: Int
    
    
    /**
     *  The date of the creation of this message.
     */
    public let date: Date
}
