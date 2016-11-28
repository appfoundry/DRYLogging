//
//  DefaultLogger.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/// Default logger implementation
///
/// - seealso: Logger
public class DefaultLogger : Logger {
    /// - seealso: Logger
    public let name: String
    
    /// - seealso: Logger
    public let parent: Logger?
    
    /// - seealso: Logger
    public private(set) var appenders: [LoggingAppender]
    
    /// - seealso: Logger
    public var logLevel: LogLevel
    
    /// Convenience initializer to create the root logger.
    public convenience init() {
        self.init(name: "root")
    }
    
    /// Designated initializer, setting the name and an optional parent.
    ///
    /// - parameter name: The logger's name
    /// - parameter parent: This logger's parent
    public init(name: String, parent: Logger? = nil) {
        self.name = name
        self.parent = parent
        self.appenders = [LoggingAppender]()
        self.logLevel = .off
    }
    
    /// - seealso: Logger
    public var isTraceEnabled: Bool {
        get {
            return self.isLevelEnabled(.trace)
        }
    }
    
    /// - seealso: Logger
    public var isDebugEnabled: Bool {
        get {
            return self.isLevelEnabled(.debug)
        }
    }
    
    /// - seealso: Logger
    public var isInfoEnabled: Bool {
        get {
            return self.isLevelEnabled(.info)
        }
    }
    
    /// - seealso: Logger
    public var isWarnEnabled: Bool {
        get {
            return self.isLevelEnabled(.warn)
        }
    }
    
    /// - seealso: Logger
    public var isErrorEnabled: Bool {
        get {
            return self.isLevelEnabled(.error)
        }
    }
    
    /// - seealso: Logger
    public func log(level: LogLevel, message: String, lineNumber: Int, function: String, file: String) {
        if (self.isLevelEnabled(level)) {
            let sourceString = Thread.callStackSymbols.count > 3 ? Thread.callStackSymbols[3] : ""
            let separatorSet = CharacterSet(charactersIn: " -[]+?.,")
            let components = sourceString.components(separatedBy: separatorSet).filter {
                $0 != ""
            }
            let threadName = (Thread.current.name?.characters.count ?? 0) > 0 ? Thread.current.name! : (Thread.current.isMainThread ? "main" : "???")
            let lm = self.makeMessage(with: message, lineNumber: lineNumber, function: function, file: file, threadName: threadName, level: level, components: components)
            DefaultLogger.append(message: lm, toLogger: self)
        }
    }
    
    private func makeMessage(with message: String, lineNumber: Int, function: String, file: String, threadName: String, level: LogLevel, components: [String]) -> LoggingMessage {
        let lm: LoggingMessage
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
    
    /// - seealso: Logger
    public func isLevelEnabled(_ level: LogLevel) -> Bool {
        if let parent = self.parent {
            if self.logLevel == .off {
                return parent.isLevelEnabled(level)
            }
        }
        return self.logLevel.rawValue <= level.rawValue;
    }
    
    /// - seealso: Logger
    public func add(appender: LoggingAppender) {
        self.appenders.append(appender) // Best line of code ever here!
    }
    
    /// - seealso: Logger
    public func remove(appender: LoggingAppender) {
        if let index = self.appenders.index(where: { $0 === appender }) {
            self.appenders.remove(at: index)
        }
        
    }
}
