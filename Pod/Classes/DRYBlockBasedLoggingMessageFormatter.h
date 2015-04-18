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

/**
 *  This type definition is deprecated, use DRYLoggingMessageFormatterBlock instead.
 *
 *  @since 1.0
 *  @deprecated
 */
typedef NSString *(^FormatterBlock)(DRYLoggingMessage *) __attribute__((deprecated("use DRYLoggingMessageFormatterBlock instead.")));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/**
 *  A formatter block will format a DRYLoggingMessage to an NSString, and is used by the
 *  DRYBlockBasedLoggingMessageFormatter to do its work.
 *
 *  @param DRYLoggingMessage The message to be transformed.
 *
 *  @return the formatted string, build based on the message.
 *
 *  @since 1.1
 */
typedef FormatterBlock DRYLoggingMessageFormatterBlock;
#pragma clang diagnostic pop

/**
 *  Block based DRYLoggingMessageFormatter implementation. This formatter delegates its work to
 *  a FormatterBlock. This block is passed to this formatter at initialization time. Not passing
 *  in a block results in an exception.
 *
 *  @since 1.0
 */
@interface DRYBlockBasedLoggingMessageFormatter : NSObject <DRYLoggingMessageFormatter>

/**
 *  Class factory method to initialize a formatter with the given block.
 *
 *  @param formatterBlock the block which this instance will delegate to when asked to format a message.
 *
 *  @see initWithFormatterBlock:
 */
+ (instancetype)formatterWithFormatterBlock:(DRYLoggingMessageFormatterBlock)formatterBlock;

/**
 *  Do not use this initializer, as it will throw an exceptio because of a missing FormatterBlock!
 */
- (instancetype)init;

/**
 *  Initializes a formatter with the given block.
 *
 *  @param formatterBlock the block which this instance will delegate to when asked to format a message.
 */
- (instancetype)initWithFormatterBlock:(DRYLoggingMessageFormatterBlock)formatterBlock NS_DESIGNATED_INITIALIZER;

@end
