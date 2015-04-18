//
//  DRYLoggingSizeRollerPredicate.h
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLoggingRollerPredicate.h"

#define DRY_ONE_MEGABYTE 1048576

/**
 *  Roller predicate which checks the file size against a configured value. If the file size 
 *  exceeds the maxSizeInBytes, the predicte returns YES. NO otherwise.
 *
 *  @since 1.1
 */
@interface DRYLoggingSizeRollerPredicate : NSObject <DRYLoggingRollerPredicate>


/**
 *  The maximum allowed file size in bytes.
 */
@property (nonatomic, readonly) NSUInteger maxSizeInBytes;

/**
 *  Class factory, initializing a predicate with the given maximum size in bytes.
 *
 *  @see initWithMaxSizeInBytes:
 */
+ (instancetype)predicateWithMaxSizeInBytes:(NSUInteger)maxSizeInBytes;

/**
 *  Convenience initializer, setting the maximum size in bytes to 1 megabyte
 */
- (instancetype)init;

/**
 *  Designated initializer, initializing a predicate with the given maximum size in bytes.
 *
 *  @param maxSizeInBytes The maximum allowed file size in bytes.
 */
- (instancetype)initWithMaxSizeInBytes:(NSUInteger)maxSizeInBytes NS_DESIGNATED_INITIALIZER;

@end
