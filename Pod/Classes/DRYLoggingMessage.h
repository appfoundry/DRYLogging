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

+ (instancetype)messageWithMessage:(NSString *)message level:(DRYLogLevel)level loggerName:(NSString *)loggerName framework:(NSString *)framework className:(NSString *)className methodName:(NSString *)methodName memoryAddress:(NSString *)memoryAddress byteOffset:(NSString *)byteOffset;
- (instancetype)initWithMessage:(NSString *)message level:(DRYLogLevel)level loggerName:(NSString *)loggerName framework:(NSString *)framework className:(NSString *)className methodName:(NSString *)methodName memoryAddress:(NSString *)memoryAddress byteOffset:(NSString *)byteOffset;
- (BOOL)isEqualToMessage:(DRYLoggingMessage *)message;




@end
