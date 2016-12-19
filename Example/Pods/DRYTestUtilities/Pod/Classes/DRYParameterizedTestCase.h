//
//  DRYParameterizedTestCase.h
//  Pods
//
//  Created by Michael Seghers on 08/04/15.
//
//

#import <XCTest/XCTest.h>

@protocol DRYParameterizedTestCase

@optional
+ (NSArray *)parameters;
- (void)testWithParameter:(id)parameter;
@end

@protocol TestNameProvider
@property (nonatomic, readonly) NSString *testName;
@end

@protocol ParameterProvider
@property (nonatomic, readonly) id parameter;
@end


@interface DRYParameterizedTestCase : XCTestCase<DRYParameterizedTestCase>
@end
