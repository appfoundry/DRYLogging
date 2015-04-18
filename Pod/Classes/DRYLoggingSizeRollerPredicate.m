//
//  DRYLoggingSizeRollerPredicate.m
//  Pods
//
//  Created by Michael Seghers on 18/04/15.
//
//

#import "DRYLoggingSizeRollerPredicate.h"

@interface DRYLoggingSizeRollerPredicate () {
    NSUInteger _maxSizeInBytes;
}
@end

@implementation DRYLoggingSizeRollerPredicate

+ (instancetype)predicateWithMaxSizeInBytes:(NSUInteger)maxSizeInBytes {
    return [[self alloc] initWithMaxSizeInBytes:maxSizeInBytes];
}

- (instancetype)init {
    return [self initWithMaxSizeInBytes:DRY_ONE_MEGABYTE];
}


- (instancetype)initWithMaxSizeInBytes:(NSUInteger)maxSizeInBytes {
    self = [super init];
    if (self) {
        _maxSizeInBytes = maxSizeInBytes;
    }
    return self;
}

- (BOOL)shouldRollFileAtPath:(NSString *)path {
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return ([attr fileSize] > _maxSizeInBytes);
}

@end
