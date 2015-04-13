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
    assertThat(_factory, is(notNilValue()));
    assertThat(_factory, is(sameInstance([DRYLoggerFactory sharedLoggerFactory])));
}

- (void)testFactoryReturnsLoggerNamedAsRequested {
    assertThat([_factory loggerWithName:@"test"].name, is(equalTo(@"test")));
}

- (void)testRootLoggerHasInfoLevel {
    assertThatInteger(_factory.rootLogger.level, is(equalToInteger(DRYLogLevelInfo)));
}

- (void)testCanAccessRootLoggerStatically {
    assertThat([DRYLoggerFactory rootLogger], is(sameInstance(_factory.rootLogger)));
}

- (void)testNonRootLoggerHasNoneLevel {
    assertThatInteger([_factory loggerWithName:@"test"].level, is(equalToInteger(DRYLogLevelOff)));
}

- (void)testFactoryReturnsSameLoggerForSameName {
    assertThat([_factory loggerWithName:@"test"], is(sameInstance([_factory loggerWithName:@"test"])));
}

- (void)testFactoryWorksThroughSingletonWhenUsedStatically {
    id <DRYLogger> logger = [DRYLoggerFactory loggerWithName:@"test"];
    assertThat(logger, is(sameInstance([[DRYLoggerFactory sharedLoggerFactory] loggerWithName:@"test"])));
}

- (void)testFactoryReturnsLoggerWithRootLoggerAsParent {
    id <DRYLogger> logger = [_factory loggerWithName:@"name"];
    assertThat(logger.parent, is(sameInstance(_factory.rootLogger)));
}

- (void)testFactoryReturnsLoggerWithParentLoggerAsParent {
    id <DRYLogger> child = [_factory loggerWithName:@"name.child"];
    assertThat(child.parent, is(sameInstance([_factory loggerWithName:@"name"])));
}

- (void)testFactoryReturnsLoggerWithParentAndItsParent {
    id <DRYLogger> child = [_factory loggerWithName:@"name.child.grandchild"];

    assertThat(child.parent, is(sameInstance([_factory loggerWithName:@"name.child"])));
    assertThat(child.parent.parent, is(sameInstance([_factory loggerWithName:@"name"])));
    assertThat(child.parent.parent.parent, is(sameInstance(_factory.rootLogger)));
    assertThat(child.parent.parent.parent.parent, is(nilValue()));
}

@end
