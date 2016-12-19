//
//  DRYParameterizedTestCase.m
//  Pods
//
//  Created by Michael Seghers on 08/04/15.
//
//

#import <objc/runtime.h>
#import "DRYParameterizedTestCase.h"


@implementation DRYParameterizedTestCase

+ (NSArray *)testInvocations {
    if (self == [DRYParameterizedTestCase class]) {
        return nil;
    }
    
    SEL parameterSel = @selector(parameters);
    if (![self respondsToSelector:parameterSel]) {
        return nil;
    }
    
    
    NSArray *params = [self parameters];
    
    SEL sel = @selector(testWithParameter:);
    Method m = class_getInstanceMethod(self, sel);
    if (!m) {
        @throw [NSException exceptionWithName:@"DRYParameterizedTestCaseException" reason:[NSString stringWithFormat:@"You should provide an instance method called %@ in your parametirzed test class %@!", NSStringFromSelector(sel), self] userInfo:nil];
    }
    IMP imp = class_getMethodImplementation(self, sel);
    
    
    NSMutableArray *invocations = [[NSMutableArray alloc] init];
    int i = 0;
    for (id param in params) {
        NSString *testName = [self _testNameForParam:param atIndex:i];
        SEL testSEL = NSSelectorFromString(testName);
        BOOL succeeded = class_addMethod(self, testSEL, imp, method_getTypeEncoding(class_getInstanceMethod(self, sel)));
        if (!succeeded) {
            @throw [NSException exceptionWithName:@"DRYParameterizedTestCaseException" reason:[NSString stringWithFormat:@"Test method for parameters %@ could not be added", param] userInfo:nil];
        } else {
            NSMethodSignature *signature = [self instanceMethodSignatureForSelector:sel];
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
            
            id actualParam = [param respondsToSelector:@selector(parameter)] ? [param parameter] : param;
            inv.selector = testSEL;
            [inv setArgument:(void *)&actualParam atIndex:2];
            [inv retainArguments];
            [invocations addObject:inv];
        }
        i++;
    }
    return [[super testInvocations] arrayByAddingObjectsFromArray:invocations];
}

+ (NSString *)_testNameForParam:(id)param atIndex:(int)index {
    if ([param isKindOfClass:[NSArray class]]) {
        return [NSString stringWithFormat:@"testWith(%@)", [param componentsJoinedByString:@":"]];
    } else if ([param isKindOfClass:[NSDictionary class]] && [param objectForKey:@"testName"]) {
        return [param objectForKey:@"testName"];
    } else if ([param respondsToSelector:@selector(testName)]) {
        return [param testName];
    } else {
        return [NSString stringWithFormat:@"testForParamAtIndex_%@",  @(index)];
    }
}

@end
