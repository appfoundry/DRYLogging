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
- (instancetype)initWithName:(NSString *)name;

- (void)addAppender:(id<DRYLoggingAppender>)appender;

@end
