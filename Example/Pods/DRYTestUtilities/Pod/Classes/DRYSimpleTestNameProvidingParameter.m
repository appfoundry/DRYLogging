//
//  DRYSimpleTestNameProvidingParameter.m
//  Pods
//
//  Created by Michael Seghers on 08/04/15.
//
//

#import "DRYSimpleTestNameProvidingParameter.h"

@implementation DRYSimpleTestNameProvidingParameter {
    NSString *_testName;
    id _parameter;
}

- (instancetype)initWithTestName:(NSString *)testName parameter:(id)parameter {
    self = [super init];
    if (self) {
        _testName = testName;
        _parameter = parameter;
    }
    return self;
}

+ (instancetype)parameterWithTestName:(NSString *)testName parameter:(id)parameter {
    return [[self alloc] initWithTestName:testName parameter:parameter];
}

@synthesize testName = _testName;
@synthesize parameter = _parameter;

@end
