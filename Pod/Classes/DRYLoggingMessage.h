//
//  DRYLoggingMessage.h
//  Pods
//
//  Created by Michael Seghers on 11/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLogger.h"

@interface DRYLoggingMessage : NSObject

@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) DRYLogLevel level;
@property (nonatomic, readonly) NSString *loggerName;
@property (nonatomic, readonly) NSString *framework;
@property (nonatomic, readonly) NSString *className;
@property (nonatomic, readonly) NSString *methodName;
@property (nonatomic, readonly) NSString *memoryAddress;
@property (nonatomic, readonly) NSString *byteOffset;
@property (nonatomic, readonly) NSString *threadName;
@property (nonatomic, readonly) NSNumber *lineNumber;

+ (instancetype)messageWithMessage:(NSString *)message level:(DRYLogLevel)level loggerName:(NSString *)loggerName framework:(NSString *)framework className:(NSString *)className methodName:(NSString *)methodName memoryAddress:(NSString *)memoryAddress byteOffset:(NSString *)byteOffset threadName:(NSString *)threadName lineNumber:(int)lineNumber;
- (instancetype)initWithMessage:(NSString *)message level:(DRYLogLevel)level loggerName:(NSString *)loggerName framework:(NSString *)framework className:(NSString *)className methodName:(NSString *)methodName memoryAddress:(NSString *)memoryAddress byteOffset:(NSString *)byteOffset threadName:(NSString *)threadName lineNumber:(int)lineNumber;
- (BOOL)isEqualToMessage:(DRYLoggingMessage *)message;




@end
