//
//  DRYLoggingRoller.h
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  A logging roller is responsible for rolling over files. The goal is to not make the logging 
 *  system clutter the system with large files or too many log files.
 *
 *  @since 1.1
 */
@protocol DRYLoggingRoller <NSObject>

/**
 *  Rolls over the file at the given path. What this means depends on the implementation of this protocol.
 *
 *  @param path The path of the file to roll over.
 */
- (void)rollFileAtPath:(NSString *)path;

@end
