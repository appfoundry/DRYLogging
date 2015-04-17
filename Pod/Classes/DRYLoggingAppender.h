//
//  DRYLoggingAppender.h
//  Pods
//
//  Created by Michael Seghers on 10/04/15.
//
//

#import <Foundation/Foundation.h>

@class DRYLoggingMessage;
@protocol DRYLoggingAppenderFilter;

@protocol DRYLoggingAppender <NSObject>

- (void)append:(DRYLoggingMessage *)message;

- (void)addFilter:(id<DRYLoggingAppenderFilter>)filter;
- (void)removeFilter:(id <DRYLoggingAppenderFilter>)filter;


@end
