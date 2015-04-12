//
//  DRYLoggingAppender.h
//  Pods
//
//  Created by Michael Seghers on 10/04/15.
//
//

#import <Foundation/Foundation.h>

@class DRYLoggingMessage;

@protocol DRYLoggingAppender <NSObject>

- (void)append:(DRYLoggingMessage *)message;

@end
