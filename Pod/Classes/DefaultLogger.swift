//
//  DefaultLogger.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/**
 * Default logger implementation
 *
 * @see Logger
 */
public class DefaultLogger : Logger {
    public let name:String
    public let parent:Logger?
    public private(set) var appenders:[LoggingAppender]
    public var logLevel: LogLevel
    
    public convenience init() {
        self.init(name: "root")
    }
    
    public convenience init(name: String) {
        self.init(name: name, parent: nil)
    }
    
    public init(name: String, parent: Logger?) {
        self.name = name
        self.parent = parent
        self.appenders = [LoggingAppender]()
        self.logLevel = .off
    }
    
    
    
    public var isTraceEnabled: Bool {
        get {
            return self.isLevelEnabled(.trace)
        }
    }
    
    public var isDebugEnabled: Bool {
        get {
            return self.isLevelEnabled(.debug)
        }
    }
    
    public var isInfoEnabled: Bool {
        get {
            return self.isLevelEnabled(.info)
        }
    }
    
    public var isWarnEnabled: Bool {
        get {
            return self.isLevelEnabled(.warn)
        }
    }
    
    public var isErrorEnabled: Bool {
        get {
            return self.isLevelEnabled(.error)
        }
    }
    
    public func log(level: LogLevel, message: String, lineNumber:Int, function: String, file: String) {
        if (self.isLevelEnabled(level)) {
            let sourceString = Thread.callStackSymbols.count > 2 ? Thread.callStackSymbols[2] : ""
            let separatorSet = CharacterSet(charactersIn: " -[]+?.,")
            let components = sourceString.components(separatedBy: separatorSet).filter {
                $0 != ""
            }
            let threadName = (Thread.current.name?.characters.count ?? 0) > 0 ? Thread.current.name! : (Thread.current.isMainThread ? "main" : "???")
            let lm = self.messageWith(message: message, lineNumber: lineNumber, function: function, file: file, threadName: threadName, level: level, components: components)
            DefaultLogger.append(message: lm, toLogger: self)
        }
    }
    
    private func messageWith(message:String, lineNumber:Int, function:String, file:String, threadName:String, level:LogLevel, components:[String]) -> LoggingMessage {
        let lm:LoggingMessage
        switch components.count {
        case 8:
            lm = LoggingMessage(message: message, level: level, loggerName: self.name, framework: components[1], className: components[4], fileName: file, methodName: function, memoryAddress: components[2], byteOffset: components[3], threadName: threadName, lineNumber: lineNumber, date: Date())
        case 6:
            lm = LoggingMessage(message: message, level: level, loggerName: self.name, framework: components[1], className: components[3], fileName: file, methodName: function, memoryAddress: components[2], byteOffset: components[5], threadName: threadName, lineNumber: lineNumber, date: Date())
        case 5:
            lm = LoggingMessage(message: message, level: level, loggerName: self.name, framework: components[1], className: components[3], fileName: file, methodName: function, memoryAddress: components[2], byteOffset: components[4], threadName: threadName, lineNumber: lineNumber, date: Date())
        default:
            lm = LoggingMessage(message: message, level: level, loggerName: self.name, framework: "???", className: "???", fileName: file, methodName: function, memoryAddress: "???", byteOffset: "???", threadName: threadName, lineNumber: lineNumber, date: Date())
        }
        return lm
    }
    
    public func isLevelEnabled(_ level: LogLevel) -> Bool {
        if let parent = self.parent {
            if self.logLevel == .off {
                return parent.isLevelEnabled(level)
            }
        }
        return self.logLevel.rawValue <= level.rawValue;
    }
    
    public func add(appender: LoggingAppender) {
        self.appenders.append(appender) // Best line of code ever here!
    }
    
    public func remove(appender: LoggingAppender) {
        if let index = self.appenders.index(where: { $0 === appender }) {
            self.appenders.remove(at: index)
        }
        
    }
}
