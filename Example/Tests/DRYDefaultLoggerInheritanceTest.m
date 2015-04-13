//
//  DRYDefaultLoggerInheritanceTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 13/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import "DRYDefaultLogger.h"
#import "DRYLoggingAppender.h"

@interface DRYDefaultLoggerInheritanceTest : XCTestCase {
    DRYDefaultLogger *_child;
    DRYDefaultLogger *_parent;
    DRYDefaultLogger *_greatParent;

    id <DRYLoggingAppender> _parentAppender;
    id <DRYLoggingAppender> _greatParentAppender;
    id <DRYLoggingAppender> _childAppender;
}

@end

@implementation DRYDefaultLoggerInheritanceTest

- (void)setUp {
    [super setUp];
    _greatParent = [[DRYDefaultLogger alloc] initWithName:@"greatparent"];
    _greatParentAppender = mockProtocol(@protocol(DRYLoggingAppender));
    [_greatParent addAppender:_greatParentAppender];

    _parent = [[DRYDefaultLogger alloc] initWithName:@"parent" parent:_greatParent];
    _parentAppender = mockProtocol(@protocol(DRYLoggingAppender));
    [_parent addAppender:_parentAppender];

    _child = [[DRYDefaultLogger alloc] initWithName:@"child" parent:_parent];
    _childAppender = mockProtocol(@protocol(DRYLoggingAppender));
    [_child addAppender:_childAppender];
}

- (void)testChildInheritsLevelFromParentIfChildHasNoLevelByItself {
    _parent.level = DRYLogLevelInfo;
    assertThatBool(_child.isInfoEnabled, isTrue());
}

- (void)testChildTakesOwnLevelIfItHasOne {
    _parent.level = DRYLogLevelInfo;
    _child.level = DRYLogLevelTrace;
    assertThatBool(_child.isTraceEnabled, isTrue());
}

- (void)testLoggingMessageOnChildAlsoCallsAppendersOfParent {
    _child.level = DRYLogLevelInfo;
    [_child info:@"Test message"];
    [MKTVerify(_parentAppender) append:hasProperty(@"message", @"Test message")];
}

- (void)testLoggingMessageOnChildAlsoCallsAppendersOfGreatParent {
    _child.level = DRYLogLevelInfo;
    [_child info:@"Test message"];
    [MKTVerify(_greatParentAppender) append:hasProperty(@"message", @"Test message")];
}


@end
