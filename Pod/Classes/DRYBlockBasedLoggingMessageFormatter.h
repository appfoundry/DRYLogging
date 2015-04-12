//
//  DRYBlockBasedLoggingMessageFormatter.h
//  Pods
//
//  Created by Michael Seghers on 12/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLoggingMessageFormatter.h"

@class DRYLoggingMessage;

typedef NSString *(^FormatterBlock)(DRYLoggingMessage *);

@interface DRYBlockBasedLoggingMessageFormatter : NSObject <DRYLoggingMessageFormatter>

+ (instancetype)formatterWithFormatterBlock:(FormatterBlock)formatterBlock;
- (instancetype)initWithFormatterBlock:(FormatterBlock)formatterBlock;

@end
