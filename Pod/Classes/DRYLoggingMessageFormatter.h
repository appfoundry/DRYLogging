//
//  DRYLoggingMessageFormatter.h
//  Pods
//
//  Created by Michael Seghers on 12/04/15.
//
//

#import <Foundation/Foundation.h>

@class DRYLoggingMessage;

@protocol DRYLoggingMessageFormatter <NSObject>

- (NSString *)format:(DRYLoggingMessage *)message;

@end
