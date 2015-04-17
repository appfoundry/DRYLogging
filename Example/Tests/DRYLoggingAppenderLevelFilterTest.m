//
//  DRYLoggingAppenderLevelFilterTest.m
//  DRYLogging
//
//  Created by Michael Seghers on 17/04/15.
//  Copyright (c) 2015 Michael Seghers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <DRYLogging/DRYLoggingAppenderLevelFilter.h>

@interface DRYLoggingAppenderLevelFilterTest : XCTestCase {
    DRYLoggingAppenderLevelFilter *_filter;
}

@end

@implementation DRYLoggingAppenderLevelFilterTest

- (void)setUp {
    [super setUp];
    _filter = [[DRYLoggingAppenderLevelFilter alloc] init];
}

- (void)testFilterShouldHaveTraceLevelAsFilterLevelByDefault {
    assertThatInteger(_filter.level, is(equalToInteger(DRYLogLevelTrace)));
}

- (void)testFilterShouldRequireExactMatchByDefault {
    assertThatBool(_filter.exactMatchRequired, isTrue());
}

- (void)testFilterShouldHaveAcceptDecissionAsDefaultMatchDecission {
    assertThatInteger(_filter.matchDecission, is(equalToInteger(DRYLoggingAppenderFilterDecissionAccept)));
}

- (void)testFilterShouldHaveDenyDecissionAsDefaultNoMatchDecission {
    assertThatInteger(_filter.noMatchDecission, is(equalToInteger(DRYLoggingAppenderFilterDecissionDeny)));
}

- (void)testFilterShouldHavePropertiesFromInitializer {
    DRYLoggingAppenderLevelFilter *filter = [[DRYLoggingAppenderLevelFilter alloc] initWithLevel:DRYLogLevelOff exactMatchRequired:NO matchDecission:DRYLoggingAppenderFilterDecissionNeutral noMatchDecission:DRYLoggingAppenderFilterDecissionNeutral];
    assertThat(filter, allOf(hasProperty(@"level", equalToInteger(DRYLogLevelOff)), hasProperty(@"exactMatchRequired", isFalse()), hasProperty(@"matchDecission", equalToInteger(DRYLoggingAppenderFilterDecissionNeutral)), hasProperty(@"noMatchDecission", equalToInteger(DRYLoggingAppenderFilterDecissionNeutral)), nil));
}


@end
