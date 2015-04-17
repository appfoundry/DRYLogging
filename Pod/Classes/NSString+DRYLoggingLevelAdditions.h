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

/**
 *  Transforms a DRYLogLevel into a string. Usefull when including a level in a formatted message.
 *
 *  @since 1.0
 */
+ (instancetype)stringFromDRYLoggingLevel:(DRYLogLevel)level;

@end
