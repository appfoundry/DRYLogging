//
//  DRYLoggingConsoleAppender.h
//  Pods
//
//  Created by Michael Seghers on 10/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLoggingAppender.h"

@protocol DRYLoggingMessageFormatter;

@interface DRYLoggingConsoleAppender : NSObject <DRYLoggingAppender>

+ (instancetype)appenderWithFormatter:(id<DRYLoggingMessageFormatter>)formatter;
- (instancetype)initWithFormatter:(id<DRYLoggingMessageFormatter>)formatter;

@end
