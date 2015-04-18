//
//  DRYBlockBasedLoggingMessageFormatter.m
//  Pods
//
//  Created by Michael Seghers on 12/04/15.
//
//

#import "DRYBlockBasedLoggingMessageFormatter.h"
#import "DRYLoggingMessage.h"

@interface DRYBlockBasedLoggingMessageFormatter () {
    DRYLoggingMessageFormatterBlock _formatterBlock;
}
@end

@implementation DRYBlockBasedLoggingMessageFormatter

+ (instancetype)formatterWithFormatterBlock:(DRYLoggingMessageFormatterBlock)formatterBlock {
    return [[self alloc] initWithFormatterBlock:formatterBlock];
}

- (instancetype)init {
    return [self initWithFormatterBlock:nil];
}

- (instancetype)initWithFormatterBlock:(DRYLoggingMessageFormatterBlock)formatterBlock {
    NSParameterAssert(formatterBlock);
    self = [super init];
    if (self) {
        _formatterBlock = formatterBlock;
    }
    return self;
}

- (NSString *)format:(DRYLoggingMessage *)message {
    return _formatterBlock(message);
}

@end
