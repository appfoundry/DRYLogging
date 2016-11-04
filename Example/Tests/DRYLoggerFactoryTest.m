//
//  DRYLoggerFactoryTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 13/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//


#import "DRYLoggerFactory.h"
#import "DRYLogger.h"

@interface DRYLoggerFactoryTest : XCTestCase  {
    DRYLoggerFactory *_factory;
}

@end

@implementation DRYLoggerFactoryTest

- (void)setUp {
    [super setUp];
    _factory = [DRYLoggerFactory sharedLoggerFactory];
}

- (void)testLoggerFactoryIsASingleton {
    HC_assertThat(_factory, HC_is(HC_notNilValue()));
    HC_assertThat(_factory, HC_is(HC_sameInstance([DRYLoggerFactory sharedLoggerFactory])));
}

- (void)testFactoryReturnsLoggerNamedAsRequested {
    HC_assertThat([_factory loggerWithName:@"test"].name, HC_is(HC_equalTo(@"test")));
}

- (void)testRootLoggerHasInfoLevel {
    HC_assertThatInteger(_factory.rootLogger.level, HC_is(HC_equalToInteger(DRYLogLevelInfo)));
}

- (void)testCanAccessRootLoggerStatically {
    HC_assertThat([DRYLoggerFactory rootLogger], HC_is(HC_sameInstance(_factory.rootLogger)));
}

- (void)testNonRootLoggerHasNoneLevel {
    HC_assertThatInteger([_factory loggerWithName:@"test"].level, HC_is(HC_equalToInteger(DRYLogLevelOff)));
}

- (void)testFactoryReturnsSameLoggerForSameName {
    HC_assertThat([_factory loggerWithName:@"test"], HC_is(HC_sameInstance([_factory loggerWithName:@"test"])));
}

- (void)testFactoryWorksThroughSingletonWhenUsedStatically {
    id <DRYLogger> logger = [DRYLoggerFactory loggerWithName:@"test"];
    HC_assertThat(logger, HC_is(HC_sameInstance([[DRYLoggerFactory sharedLoggerFactory] loggerWithName:@"test"])));
}

- (void)testFactoryReturnsLoggerWithRootLoggerAsParent {
    id <DRYLogger> logger = [_factory loggerWithName:@"name"];
    HC_assertThat(logger.parent, HC_is(HC_sameInstance(_factory.rootLogger)));
}

- (void)testFactoryReturnsLoggerWithParentLoggerAsParent {
    id <DRYLogger> child = [_factory loggerWithName:@"name.child"];
    HC_assertThat(child.parent, HC_is(HC_sameInstance([_factory loggerWithName:@"name"])));
}

- (void)testFactoryReturnsLoggerWithParentAndItsParent {
    id <DRYLogger> child = [_factory loggerWithName:@"name.child.grandchild"];

    HC_assertThat(child.parent, HC_is(HC_sameInstance([_factory loggerWithName:@"name.child"])));
    HC_assertThat(child.parent.parent, HC_is(HC_sameInstance([_factory loggerWithName:@"name"])));
    HC_assertThat(child.parent.parent.parent, HC_is(HC_sameInstance(_factory.rootLogger)));
    HC_assertThat(child.parent.parent.parent.parent, HC_is(HC_nilValue()));
}

@end
