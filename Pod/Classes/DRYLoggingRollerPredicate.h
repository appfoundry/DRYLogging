//
//  DRYLoggingRollerPredicate.h
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  A roller predicate is responsible for telling a file appender when to roll its current file.
 *
 *  @since 1.1
 */
@protocol DRYLoggingRollerPredicate <NSObject>

/**
 *  This method returns YES when an appender should roll over the given file. It is up to a 
 *  DRYLoggingRoller to do the actual rolling.
 *
 *  @param path The path of the file for which rolling should be checked
 */
- (BOOL)shouldRollFileAtPath:(NSString *)path;

@end
