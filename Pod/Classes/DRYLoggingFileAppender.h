//
//  DRYLoggingFileAppender.h
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYLoggingBaseFormattingAppender.h"

@interface DRYLoggingFileAppender : DRYLoggingBaseFormattingAppender

/**
 *  Class factory method, initializing a file appender which will append a message formatted by
 *  the formatter to the file at the given path with the given string encoding.
 *
 *  @see initWithFormatter:toFileAtPath:encoding:
 *  @since 1.1
 */
+ (instancetype)appenderWithFormatter:(id<DRYLoggingMessageFormatter>)formatter toFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding rollerPredicate:(id<DRYLoggingRollerPredicate>)rollerPredicate roller:(id<DRYLoggingRoller>)roller;

/**
 *  Convenience initializer, initializing a file appender which will append a message formatted by
 *  the formatter to a file named "default.log" in the document folder with UTF8 encoding using a
 *  roller predicate which will check that the file will not get bigger then 1 MB.
 */
- (instancetype)initWithFormatter:(id<DRYLoggingMessageFormatter>)formatter;

/**
 *  Designated initializer, initializing a file appender which will append a message formatted by
 *  the formatter to the file at the given path with the given string encoding.
 *
 *  @param formatter       the appended messages will be formatter by using the formatter, required.
 *  @param path            the path of the file to which messages should be appended, required.
 *  @param encoding        the string encoding, used to write to the file.
 *  @param rollerPredicate the roller predicate which decides when file rolling should occur.
 */
- (instancetype)initWithFormatter:(id<DRYLoggingMessageFormatter>)formatter toFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding rollerPredicate:(id<DRYLoggingRollerPredicate>)rollerPredicate roller:(id<DRYLoggingRoller>)roller NS_DESIGNATED_INITIALIZER;

@end
