//
//  DRYDefaultLoggerTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 10/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//


#import "DRYDefaultLogger.h"
#import "NSString+DRYLoggingLevelAdditions.h"
#import <DRYTestUtilities/DRYParameterizedTestCase.h>

@interface DRYDefaultLoggerLevelsTest : DRYParameterizedTestCase {
    DRYDefaultLogger *_logger;
}

@end

@interface LogLevelTestParameter : NSObject<TestNameProvider>
@property (nonatomic) DRYLogLevel levelToSet;
@property (nonatomic) SEL enabledMethod;
@property (nonatomic) BOOL expectedToBe;

- (instancetype)initForLevel:(DRYLogLevel)level shouldBe:(BOOL)expected forEnabledMethod:(SEL)method;
+ (instancetype)paramForLevel:(DRYLogLevel)level shouldBe:(BOOL)expected forEnabledMethod:(SEL)method;

@end

@implementation LogLevelTestParameter

- (instancetype)initForLevel:(DRYLogLevel)level shouldBe:(BOOL)expected forEnabledMethod:(SEL)method {
    self = [super init];
    if (self) {
        self.levelToSet = level;
        self.enabledMethod = method;
        self.expectedToBe = expected;
    }
    return self;
}

+ (instancetype)paramForLevel:(DRYLogLevel)level shouldBe:(BOOL)expected forEnabledMethod:(SEL)method {
    return [[self alloc] initForLevel:level shouldBe:expected forEnabledMethod:method];
}

- (NSString *)testName {
    NSString *levelString= [NSString stringFromDRYLoggingLevel:self.levelToSet];
    NSString *methodString = NSStringFromSelector(self.enabledMethod);
    NSString *boolString = self.expectedToBe ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"test_whenLevelIsSetTo%@_%@_shouldBe%@", levelString, methodString, boolString];
}

@end

@implementation DRYDefaultLoggerLevelsTest

+ (NSArray *)parameters {
    return @[
        [LogLevelTestParameter paramForLevel:DRYLogLevelTrace shouldBe:YES forEnabledMethod:@selector(isTraceEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelDebug shouldBe:NO forEnabledMethod:@selector(isTraceEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelInfo shouldBe:NO forEnabledMethod:@selector(isTraceEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelWarn shouldBe:NO forEnabledMethod:@selector(isTraceEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelError shouldBe:NO forEnabledMethod:@selector(isTraceEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelOff shouldBe:NO forEnabledMethod:@selector(isTraceEnabled)],

        [LogLevelTestParameter paramForLevel:DRYLogLevelTrace shouldBe:YES forEnabledMethod:@selector(isDebugEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelDebug shouldBe:YES forEnabledMethod:@selector(isDebugEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelInfo shouldBe:NO forEnabledMethod:@selector(isDebugEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelWarn shouldBe:NO forEnabledMethod:@selector(isDebugEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelError shouldBe:NO forEnabledMethod:@selector(isDebugEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelOff shouldBe:NO forEnabledMethod:@selector(isDebugEnabled)],

        [LogLevelTestParameter paramForLevel:DRYLogLevelTrace shouldBe:YES forEnabledMethod:@selector(isInfoEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelDebug shouldBe:YES forEnabledMethod:@selector(isInfoEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelInfo shouldBe:YES forEnabledMethod:@selector(isInfoEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelWarn shouldBe:NO forEnabledMethod:@selector(isInfoEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelError shouldBe:NO forEnabledMethod:@selector(isInfoEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelOff shouldBe:NO forEnabledMethod:@selector(isInfoEnabled)],

        [LogLevelTestParameter paramForLevel:DRYLogLevelTrace shouldBe:YES forEnabledMethod:@selector(isWarnEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelDebug shouldBe:YES forEnabledMethod:@selector(isWarnEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelInfo shouldBe:YES forEnabledMethod:@selector(isWarnEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelWarn shouldBe:YES forEnabledMethod:@selector(isWarnEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelError shouldBe:NO forEnabledMethod:@selector(isWarnEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelOff shouldBe:NO forEnabledMethod:@selector(isWarnEnabled)],

        [LogLevelTestParameter paramForLevel:DRYLogLevelTrace shouldBe:YES forEnabledMethod:@selector(isErrorEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelDebug shouldBe:YES forEnabledMethod:@selector(isErrorEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelInfo shouldBe:YES forEnabledMethod:@selector(isErrorEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelWarn shouldBe:YES forEnabledMethod:@selector(isErrorEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelError shouldBe:YES forEnabledMethod:@selector(isErrorEnabled)],
        [LogLevelTestParameter paramForLevel:DRYLogLevelOff shouldBe:NO forEnabledMethod:@selector(isErrorEnabled)],
             ];
}

- (void)setUp {
    [super setUp];
    _logger = [[DRYDefaultLogger alloc] initWithName:@"testlogger"];
}

#pragma mark - Trace enabled
- (void)testWithParameter:(LogLevelTestParameter *)parameter {
    _logger.level = parameter.levelToSet;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_logger methodSignatureForSelector:parameter.enabledMethod]];
    invocation.target = _logger;
    invocation.selector = parameter.enabledMethod;
    [invocation invoke];
    BOOL result;
    [invocation getReturnValue:&result];
    
    assertThatBool(result, parameter.expectedToBe ? isTrue() : isFalse());
}

@end
