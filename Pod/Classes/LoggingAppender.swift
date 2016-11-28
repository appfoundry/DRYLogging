//
//  LoggingAppender.swift
//  Pods
//
//  Created by Michael Seghers on 28/10/2016.
//
//

import Foundation

/// An appender is capable of appending LoggingMessage instances to an underlying system, such as but not excluding:
///
/// * the console
/// * the file system
/// * a database
/// * a remote service
/// * ...
///
/// An appender has a collection of filters which allow to filter out message that it will or will not accept. This works
/// as follows:
///
/// *  When a filter decides to accept the message, the message is directly appended to the underlying system.
/// *  When a filter decides to deny the message, the message will be ignored by this appender.
/// *  When a filter is indecisive, the next filter in order will be consulted. If the last filter is indecisive, the message is treated as accepted.
///
/// The filters are consulted in the order in which they were added.
///
/// - seealso: LoggingAppenderFilter
///
/// - since: 3.0
public protocol LoggingAppender : class {

    /// Append the message to the underlying system. How this is done is at the implementation's discression.
    ///
    /// - parameter message: the message to be appended to the underlying system.
    func append(message: LoggingMessage)
    
    
    /// Adds a filter to this appender.
    ///
    /// - parameter filter: The filter to be added.
    func add(filter: AppenderFilter)
    
    
    /// Removes a filter fromt this appender.
    ///
    /// - parameter filter: The filter to be removed.
    func remove(filter: AppenderFilter)
}
