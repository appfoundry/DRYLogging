//
//  DRYLoggerFactory.m
//  Pods
//
//  Created by Michael Seghers on 13/04/15.
//
//

#import "DRYLoggerFactory.h"
#import "DRYLogger.h"
#import "DRYDefaultLogger.h"

@interface DRYLoggerFactory () {
    NSMutableDictionary *_loggersByName;
}
@end

@implementation DRYLoggerFactory

+ (id <DRYLogger>)loggerWithName:(NSString *)name {
    return [[self sharedLoggerFactory] loggerWithName:name];
}

+ (id <DRYLogger>)rootLogger {
    return [self sharedLoggerFactory].rootLogger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _loggersByName = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id <DRYLogger>)rootLogger {
    return [self _returnCachedOrCreateNewLoggerForName:@"root" parent:nil];
}


- (id <DRYLogger>)loggerWithName:(NSString *)name {
    NSArray *components = [name componentsSeparatedByString:@"."];
    id <DRYLogger> parent;
    if (components.count > 1) {
        NSString *parentName = [[components subarrayWithRange:NSMakeRange(0, components.count - 1)] componentsJoinedByString:@"."];
        parent = [self loggerWithName:parentName];
    } else {
        parent = self.rootLogger;
    }

    return [self _returnCachedOrCreateNewLoggerForName:name parent:parent];
}

- (id <DRYLogger>)_returnCachedOrCreateNewLoggerForName:(NSString *)name parent:(id <DRYLogger>)parent {
    id <DRYLogger> logger = _loggersByName[name];
    if (!logger) {
        logger = [DRYDefaultLogger loggerWithName:name parent:parent];
        _loggersByName[name] = logger;
        if (!parent) {
            logger.level = DRYLogLevelInfo;
        }
    }
    return logger;
}

static DRYLoggerFactory *_instance;

+ (DRYLoggerFactory *)sharedLoggerFactory {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DRYLoggerFactory alloc] init];
    });
    return _instance;
}


@end
