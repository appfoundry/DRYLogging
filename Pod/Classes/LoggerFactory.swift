//
//  LoggerFactory.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/**
 *  The logger factory creates loggers with a given name, and creates a logger hierarchy based on that name.
 *
 *  When requesting a logger with a given name, the factory will search for a logger by that name and
 *  return it, or create a new logger by that name. This process is thread safe. If the factory decides
 *  to create a new logger, it will also create an ancestor hierarchy for that logger, based on the given
 *  name. Each dot (.) in the name will result in another parent. If the name does not contain a dot, the
 *  logger will receive the rootLogger as parent. For instance, if the name of the request logger is
 *  "dry.logger.detail" you will get the following logger hierarchy:
 *
 *  * logger named "root" (which is the rootLogger), which is parent of
 *  * logger named "dry", which is parent of
 *  * logger named "dry.logger", which is parent of
 *  * logger named "dry.logger.detail"
 *
 *  This factory can be used through it's static interface, or through its shared instance.
 *  Which flavour you choose depends on your personal preferences. The outcome is the same.
 *
 *  @since 3.0
 */
public class LoggerFactory : NSObject {
    private static let sharedInstance:LoggerFactory = LoggerFactory()
    private var loggersByName:[String: Logger] = [String: Logger]()
    
    /**
     *  Returns the singleton logger factory.
     */
    public static func shared() -> LoggerFactory {
        return sharedInstance
    }
    
    /**
     *  Returns the root logger, kept by the sharedLoggerFactory instance, which is named "root" and which does not have
     *  a parent. There can only be one root logger! This is the logger to rule them all.
     */
    public static var rootLogger:Logger {
        get {
            return self.sharedInstance.rootLogger
        }
    }
    
    /**
     *  Returns a logger, kept by the sharedLoggerFactory instance, with the given name, and it's derived hierarchy (see above).
     *
     *  @param name logger's name to look for or create.
     *  @see logger(named:)
     */
    public static func logger(named name: String) -> Logger {
        return self.sharedInstance.logger(named: name)
    }
    
    /**
     *  Returns the root logger, kept by the sharedLoggerFactory instance, which is named "root" and which does not have
     *  a parent. There can only be one root logger! This is the logger to rule them all.
     */
    public var rootLogger:Logger {
        get {
            return self.cachedOrCreateNewLogger(name: "root")
        }
    }
    
    /**
     *  Returns a logger, kept by the sharedLoggerFactory instance, with the given name, and it's derived hierarchy (see above).
     *
     *  @param name logger's name to look for or create.
     *  @see -loggerWitName:
     */
    public func logger(named name: String) -> Logger {
        var components = name.components(separatedBy: ".")
        let parent:Logger
        if components.count > 1 {
            components.removeLast()
            let parentName = components.joined(separator: ".")
            parent = self.logger(named: parentName)
        } else {
            parent = self.rootLogger
        }
        return self.cachedOrCreateNewLogger(name: name, parent: parent)
    }
    
    private func cachedOrCreateNewLogger(name:String, parent:Logger? = nil) -> Logger {
        objc_sync_enter(self.loggersByName)
        var logger = self.loggersByName[name]
        if logger == nil {
            logger = DefaultLogger(name: name, parent: parent)
            if parent == nil {
                logger!.logLevel = .info
            }
            self.loggersByName[name] = logger
        }
        objc_sync_exit(self.loggersByName)
        return logger!
    }
}
