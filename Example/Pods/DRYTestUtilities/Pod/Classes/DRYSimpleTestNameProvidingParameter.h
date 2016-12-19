//
//  DRYSimpleTestNameProvidingParameter.h
//  Pods
//
//  Created by Michael Seghers on 08/04/15.
//
//

#import <Foundation/Foundation.h>
#import "DRYParameterizedTestCase.h"

@interface DRYSimpleTestNameProvidingParameter : NSObject<TestNameProvider, ParameterProvider>
- (instancetype)initWithTestName:(NSString *)testName parameter:(id)parameter;

+ (instancetype)parameterWithTestName:(NSString *)testName parameter:(id)parameter;

@end
