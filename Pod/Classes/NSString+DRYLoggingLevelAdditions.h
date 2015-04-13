//
//  NSString+DRYLoggingLevelAdditions.h
//  Pods
//
//  Created by Michael Seghers on 13/04/15.
//
//

#import <Foundation/Foundation.h>
#import <DRYLogging/DRYLogger.h>

@interface NSString (DRYLoggingLevelAdditions)

+ (instancetype)stringFromDRYLoggingLevel:(DRYLogLevel)level;

@end
