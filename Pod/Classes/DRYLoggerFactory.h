//
//  DRYLoggerFactory.h
//  Pods
//
//  Created by Michael Seghers on 13/04/15.
//
//

#import <Foundation/Foundation.h>

@protocol DRYLogger;

@interface DRYLoggerFactory : NSObject

+ (DRYLoggerFactory *)sharedLoggerFactory;
+ (id <DRYLogger>)loggerWithName:(NSString *)name;
+ (id <DRYLogger>) rootLogger;

@property (nonatomic, readonly) id <DRYLogger> rootLogger;

- (id <DRYLogger>)loggerWithName:(NSString *)name;


@end
