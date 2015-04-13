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

@interface DRYDefaultLogger : NSObject<DRYLogger>

+ (instancetype)loggerWithName:(NSString *)name;
+ (instancetype)loggerWithName:(NSString *)name parent:(id<DRYLogger>)parent;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name parent:(id<DRYLogger>)parent;

@end
