//
//  DRYLoggingMessage.h
//  Pods
//
//  Created by Michael Seghers on 11/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLogger.h"

/**
 *  Value object, holding log message information.
 *
 *  @since 1.0
 */
@interface DRYLoggingMessage : NSObject

/**
 *  The message that should be logged.
 */
@property (nonatomic, readonly) NSString *message;

/**
 *  The log level on which this message should be logged.
 */
@property (nonatomic, readonly) DRYLogLevel level;

/**
 *  The name of the logger that created this message.
 */
@property (nonatomic, readonly) NSString *loggerName;

/**
 *  The name of the framework/module for which a logger created this log message.
 */
@property (nonatomic, readonly) NSString *framework;


/**
 *  The name of the class for which a logger created this log message.
 */
@property (nonatomic, readonly) NSString *className;

/**
 *  The name of the method for which a logger created this log message.
 */
@property (nonatomic, readonly) NSString *methodName;

/**
 *  The memory address of the caller for which a logger created this log message.
 */
@property (nonatomic, readonly) NSString *memoryAddress;

/**
 *  The byte offset in the caller for which a logger created this log message.
 */
@property (nonatomic, readonly) NSString *byteOffset;

/**
 *  The name of the thread in which this message was created.
 */
@property (nonatomic, readonly) NSString *threadName;

/**
 *  The line number of the code on which this message was created.
 */
@property (nonatomic, readonly) NSNumber *lineNumber;

/**
 *  Class factory, initializing a message with all of its properties.
 *
 *  @see initWithMessage:level:loggerName:framework:className:methodName:memoryAddress:byteOffset:threadName:lineNumber:
 */
+ (instancetype)messageWithMessage:(NSString *)message level:(DRYLogLevel)level loggerName:(NSString *)loggerName framework:(NSString *)framework className:(NSString *)className methodName:(NSString *)methodName memoryAddress:(NSString *)memoryAddress byteOffset:(NSString *)byteOffset threadName:(NSString *)threadName lineNumber:(int)lineNumber;

/**
 *  Designated initializer, initializing a message with all of its properties.
 */
- (instancetype)initWithMessage:(NSString *)message level:(DRYLogLevel)level loggerName:(NSString *)loggerName framework:(NSString *)framework className:(NSString *)className methodName:(NSString *)methodName memoryAddress:(NSString *)memoryAddress byteOffset:(NSString *)byteOffset threadName:(NSString *)threadName lineNumber:(int)lineNumber NS_DESIGNATED_INITIALIZER;

/**
 *  Messages are equal if all of their properties are equal.
 */
- (BOOL)isEqualToMessage:(DRYLoggingMessage *)message;

@end
