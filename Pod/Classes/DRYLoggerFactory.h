//
//  DRYLoggerFactory.h
//  Pods
//
//  Created by Michael Seghers on 13/04/15.
//
//

#import <Foundation/Foundation.h>

@protocol DRYLogger;

/**
 *  The logger factory creates loggers with a given name, and creates a logger hierarchy based on that name.
 *
 *  When requesting a logger with a given name, the factory will search for a logger by that name and 
 *  return it, or create a new logger by that name. This process is thread safe. If the factory decides 
 *  to create a new logger, it will also create an ancestor hierarchy for that logger, base on the given 
 *  name. Each dot (.) in the name will result in another parent. If the name does not contain a dot, the 
 *  logger will receive the rootLogger as parent. For instance, if the name of the request logger is 
 *  "dry.logger.detail" you will get the following logger hierarchy:
 *
 *  * logger named "root" (which is the rootLogger), which is parent of
 *  * logger named "dry", which is parent of
 *  * logger named "dry.logger", which is parent of
 *  * logger named "dry.logger.detail"
 *  
 *  This factory can be used through it's static interface, or through its shared instance. 
 *  Which flavour you choose depends on your personal preferences. The outcome is the same.
 *
 *  @since 1.0
 */
@interface DRYLoggerFactory : NSObject

/**
 *  Returns the singleton logger factory.
 */
+ (DRYLoggerFactory *)sharedLoggerFactory;

/**
 *  Returns a logger, kept by the sharedLoggerFactory instance, with the given name, and it's derived hierarchy (see above).
 *
 *  @param name logger's name to look for or create.
 *  @see -loggerWitName:
 */
+ (id <DRYLogger>)loggerWithName:(NSString *)name;


/**
 *  Returns the root logger, kept by the sharedLoggerFactory instance, which is named "root" and which does not have 
 *  a parent. There can only be one root logger! This is the logger to rule them all.
 */
+ (id <DRYLogger>) rootLogger;

/**
 *  The root logger, kept by this factory, which is named "root" and which does not have
 *  a parent. There can only be one root logger! This is the logger to rule them all.
 */
@property (nonatomic, readonly) id <DRYLogger> rootLogger;

/**
 *  Returns a logger, kept by this factory instance, with the given name, and it's derived hierarchy (see above).
 *
 *  @param name logger's name to look for or create.
 */
- (id <DRYLogger>)loggerWithName:(NSString *)name;

@end
