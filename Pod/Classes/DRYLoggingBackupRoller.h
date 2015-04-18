//
//  DRYLoggingBackupRoller.h
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLoggingRoller.h"

/**
 *  File roller which moves log files, augmenting their index and limiting them to the maximumNumberOfFiles.
 *  The naming of the file follows the format [fileName][index].[extension] bassed on the file being rolled.
 *
 *  The following list shows an example of how rolling happens for a file named "default.log" and a maximum of 4 files
 *  
 *  * 1st roll
 *  ** default.log becomes default1.log
 *  * 2nd roll
 *  ** default1.log becomes default2.log
 *  ** default.log becomes default1.log
 *  * 3rd roll
 *  ** default2.log becomes default3.log
 *  ** default1.log becomes default2.log
 *  ** default.log becomes default1.log
 *  * 4th roll
 *  ** default3.log is deleted
 *  ** default2.log becomes default3.log
 *  ** default1.log becomes default2.log
 *  ** default.log becomes default1.log
 *
 *  @since 1.1
 */
@interface DRYLoggingBackupRoller : NSObject <DRYLoggingRoller>

/**
 *  The number of files that should be kept before starting to delete te oldest ones.
 */
@property (nonatomic, readonly) NSUInteger maximumNumberOfFiles;

/**
 *  Class factory, initializing a backup roller with the given maximumNumberOfFiles
 *
 *  @see initWithMaximumNumberOfFiles:
 */
+ (instancetype)rollerWithMaximumNumberOfFiles:(NSUInteger)maximumNumberOfFiles;

/**
 *  Convenience initializer, setting the maximumNumberOfFiles to 5
 */
- (instancetype)init;

/**
 *  Designated initializer, initializing a backup roller with the given maximumNumberOfFiles
 */
- (instancetype)initWithMaximumNumberOfFiles:(NSUInteger)maximumNumberOfFiles NS_DESIGNATED_INITIALIZER;

@end
