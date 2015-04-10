//
//  DRYLoggingAppender.h
//  Pods
//
//  Created by Michael Seghers on 10/04/15.
//
//

#import <Foundation/Foundation.h>

@protocol DRYLoggingAppender <NSObject>

- (void)append:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

@end
