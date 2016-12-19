//
//  FileAppender.swift
//  Pods
//
//  Created by Michael Seghers on 30/10/2016.
//
//

import Foundation

fileprivate class MessageQueue {
    var messageQueue: [String] = [String]()
    
    func append(message: String) {
        objc_sync_enter(self)
        messageQueue.append(message)
        objc_sync_exit(self)
    }
    
    func firstMessage() -> String? {
        objc_sync_enter(self)
        let first = messageQueue.first
        if first != nil {
            messageQueue.remove(at: 0)
        }
        objc_sync_exit(self)
        return first
    }
}

/// A File appender appends log message to a file using the given message formatter.
///
/// A file appender will write to the default.log file in the user's document directory or the file at the given filePath. Incomming messages are queued and the handled in that order in its own created thread.
public class FileAppender : BaseFormattingAppender {
    
    /// - seealso: BaseFormattingAppender
    public var filters = [AppenderFilter]()
    
    /// - seealso: BaseFormattingAppender
    public let formatter: MessageFormatter
    
    private var messageQueue: MessageQueue
    private let queueOrCancelledSemaphore: DispatchSemaphore
    private let messageQueueThread: FileAppenderMessageQueueThread
    
    /// Convenience initializer, initializing a file appender which will append a message formatted by
    /// the formatter to a file named "default.log" in the document folder with UTF-8 encoding using a
    /// roller predicate which will check that the files will not get bigger then 1 MB.
    public convenience init(formatter: MessageFormatter) {
        self.init(formatter: formatter, filePath: (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String])[0].stringByAppendingPathComponent(path: "default.log"))
    }
    
    /// Designated initializer, initializing a file appender which will append a message formatted by
    /// the formatter to the file at the given path with the given string encoding.
    ///
    /// - parameter formatter:       the appended messages will be formatter by using the formatter, required.
    /// - parameter path:            the path of the file to which messages should be appended, required.
    /// - parameter encoding:        the string encoding, used to write to the file. Defaults to utf-8 encoding.
    /// - parameter rollerPredicate: the roller predicate which decides when file rolling should occur. Defaults to a SizeLoggingRollerPredicate.
    /// - parameter roller:          the roller which is used to roll files. Default to a BackupRoller.
    public init(formatter: MessageFormatter, filePath: String, encoding: String.Encoding = .utf8, rollerPredicate: LoggingRollerPredicate = SizeLoggingRollerPredicate(), roller: LoggingRoller = BackupRoller()) {
        self.formatter = formatter
        self.messageQueue = MessageQueue()
        self.queueOrCancelledSemaphore = DispatchSemaphore(value: 0)
        self.messageQueueThread = FileAppenderMessageQueueThread(filePath: filePath, messageQueue: self.messageQueue, queueOrCancelledSemaphore: self.queueOrCancelledSemaphore, encoding: encoding, roller: roller, rollerPredicate: rollerPredicate)
        self.messageQueueThread.start()
    }
    
    /// - seealso: BaseFormattingAppender
    public func append(acceptedAndFormattedMessage formattedMessage: String) {
        messageQueue.append(message: formattedMessage)
        self.queueOrCancelledSemaphore.signal()
    }
    
    deinit {
        self.messageQueueThread.cancel()
        self.queueOrCancelledSemaphore.signal()
    }
}

/// Internal FileAppender error, used by the file appender
enum FileAppenderError : Error {
    /// Error generated when opening a stream fails
    case openingStreamFailed
}

private class FileAppenderMessageQueueThread : Thread {
    private var stream: OutputStream?
    private let filePath: String
    private let messageQueue: MessageQueue
    private let queueOrCancelledSemaphore: DispatchSemaphore
    private let encoding: String.Encoding
    private let roller: LoggingRoller
    private let rollerPredicate: LoggingRollerPredicate
    
    init(filePath: String, messageQueue: MessageQueue, queueOrCancelledSemaphore: DispatchSemaphore, encoding: String.Encoding, roller: LoggingRoller, rollerPredicate: LoggingRollerPredicate) {
        self.filePath = filePath
        self.messageQueue = messageQueue
        self.queueOrCancelledSemaphore = queueOrCancelledSemaphore
        self.encoding = encoding
        self.roller = roller
        self.rollerPredicate = rollerPredicate
        super.init()
        super.name = "be.appfoundry.drylogging.fileappender-thread"
    }
    
    override func main() {
        do {
            try self.openStream()
            while !self.isCancelled {
                while let message = messageQueue.firstMessage() {
                    self.write(message: message)
                    try self.rollIfNeeded()
                }
                self.queueOrCancelledSemaphore.wait()
            }
            self.closeStream()
        } catch {
            print("Failed to open stream: \(error)")
        }
    }
    
    private func openStream() throws {
        guard let stream = OutputStream(toFileAtPath: self.filePath, append: true) else {
            throw FileAppenderError.openingStreamFailed
        }
        self.stream = stream
        self.stream?.open()
    }
    
    private func closeStream() {
        self.stream?.close()
        self.stream = nil
    }
    
    private func write(message: String) {
        if let data = (message + "\n").data(using: self.encoding) {
            let _ = data.withUnsafeBytes {
                self.stream?.write($0, maxLength: data.count)
            }
        }
    }
    
    private func rollIfNeeded() throws {
        if self.rollerPredicate.shouldRollFile(atPath: self.filePath) {
            self.closeStream()
            self.roller.rollFile(atPath: self.filePath)
            try self.openStream()
        }
    }
    
    deinit {
        self.closeStream()
    }
}
