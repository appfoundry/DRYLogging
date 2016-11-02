//
//  FileAppender.swift
//  Pods
//
//  Created by Michael Seghers on 30/10/2016.
//
//

import Foundation

public class FileAppender : BaseFormattingAppender {
    public private(set) var filters = [AppenderFilter]()
    public let formatter: MessageFormatter
    private var messageQueue:[String]
    private let queueOrCancelledSemaphore:DispatchSemaphore
    
    public init(formatter:MessageFormatter) {
        self.formatter = formatter
        self.messageQueue = [String]()
        self.queueOrCancelledSemaphore = DispatchSemaphore(value: 0)
    }
    
    public func appendAcceptedAndFormattedMessage(_ formattedMessage: String!) {
        objc_sync_enter(messageQueue)
        messageQueue.append(formattedMessage)
        objc_sync_exit(messageQueue)
        self.queueOrCancelledSemaphore.signal()
    }
    
    public func add(filter: AppenderFilter) {
        self.filters.append(filter)
    }
    
    public func remove(filter: AppenderFilter) {
        if let index = self.filters.index(where: { $0 === filter }) {
            self.filters.remove(at: index)
        }
    }
}

private class FileAppenderMessageQueueThread : Thread {
    var stream:OutputStream?
    let filePath:String
    
    override func main() {
        self.openStream()
        while !self.isCancelled {
            if let message = self.firstMessageFromQueue()
            
        }
        
    }
    
    private func openStream() {
        self.stream = OutputStream(toFileAtPath: self.filePath, append: true)
        self.stream!.open()
    }
    
    /*
     
     - (void)main {
     [self _openNewStream];
     while (!self.isCancelled) {
     NSString *message;
     do {
     message = [self _firstMessageFromQueue];
     if (message) {
     [self _writeMessage:message];
     [self _rollIfNeeded];
     }
     } while (message);
     dispatch_semaphore_wait(_queueOrCancelledSemaphore, DISPATCH_TIME_FOREVER);
     }
     [_stream close];
     }
     
     - (void)_rollIfNeeded {
     if ([_rollerPredicate shouldRollFileAtPath:_filePath]) {
     [_stream close];
     [_roller rollFileAtPath:_filePath];
     [self _openNewStream];
     }
     }
     
     - (void)_openNewStream {
     _stream = [NSOutputStream outputStreamToFileAtPath:_filePath append:YES];
     [_stream open];
     }
     
     - (void)_writeMessage:(NSString *)message {
     NSData *stringAsData = [[message stringByAppendingString:@"\n"] dataUsingEncoding:_encoding];
     [_stream write:stringAsData.bytes maxLength:stringAsData.length];
     }
     
     - (NSString *)_firstMessageFromQueue {
     NSString *message;
     @synchronized (_queue) {
     message = _queue.firstObject;
     if (message) {
     [_queue removeObjectAtIndex:0];
     }
     }
     return message;
     }
     
     - (void)dealloc {
     [_stream close];
     }

 */
}
