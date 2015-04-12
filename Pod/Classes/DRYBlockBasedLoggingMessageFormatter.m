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
    FormatterBlock _formatterBlock;
}
@end

@implementation DRYBlockBasedLoggingMessageFormatter

+ (instancetype)formatterWithFormatterBlock:(FormatterBlock)formatterBlock {
    return [[self alloc] initWithFormatterBlock:formatterBlock];
}

- (instancetype)initWithFormatterBlock:(FormatterBlock)formatterBlock {
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
