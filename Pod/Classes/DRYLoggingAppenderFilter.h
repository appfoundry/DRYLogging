//
//  DRYLoggingAppenderFilter.h
//  Pods
//
//  Created by Michael Seghers on 17/04/15.
//
//

#import <Foundation/Foundation.h>

@class DRYLoggingMessage;

typedef NS_ENUM(NSInteger, DRYLoggingAppenderFilterDecission) {
    DRYLoggingAppenderFilterDecissionAccept,
    DRYLoggingAppenderFilterDecissionNeutral,
    DRYLoggingAppenderFilterDecissionDeny
};


@protocol DRYLoggingAppenderFilter <NSObject>

- (DRYLoggingAppenderFilterDecission)decide:(DRYLoggingMessage *)message;

@end
