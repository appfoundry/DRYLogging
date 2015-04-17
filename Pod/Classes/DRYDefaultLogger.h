//
//  DRYDefaultLogger.h
//  Pods
//
//  Created by Michael Seghers on 09/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLogger.h"

@protocol DRYLoggingAppender;

/**
 *  Default implementation of the DRYLogger protocol.
 *
 *  @see DRYLogger
 *  @since 1.0
 */
@interface DRYDefaultLogger : NSObject<DRYLogger>

/**
 *  Convenience initializer.
 *
 *  @see initWithName:
 */
+ (instancetype)loggerWithName:(NSString *)name;

/**
 *  Convenience initializer.
 *
 *  @see initWithName:parent:
 */
+ (instancetype)loggerWithName:(NSString *)name parent:(id<DRYLogger>)parent;

/**
 *  Creates a logger with the given name, without parent.
 *
 *  @param name the name for the logger that should be created.
 */
- (instancetype)initWithName:(NSString *)name;

/**
 *  Creates a logger with the given name and parent.
 *
 *  @param name   the name for the logger that should be created.
 *  @param parent the parent for the logger that should be created.
 */
- (instancetype)initWithName:(NSString *)name parent:(id<DRYLogger>)parent;

@end
