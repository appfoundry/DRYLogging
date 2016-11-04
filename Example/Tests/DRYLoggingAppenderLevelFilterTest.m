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
    HC_assertThatInteger(_filter.level, HC_is(HC_equalToInteger(DRYLogLevelTrace)));
}

- (void)testFilterShouldRequireExactMatchByDefault {
    HC_assertThatBool(_filter.exactMatchRequired, HC_isTrue());
}

- (void)testFilterShouldHaveAcceptDecissionAsDefaultMatchDecission {
    HC_assertThatInteger(_filter.matchDecission, HC_is(HC_equalToInteger(DRYLoggingAppenderFilterDecissionAccept)));
}

- (void)testFilterShouldHaveDenyDecissionAsDefaultNoMatchDecission {
    HC_assertThatInteger(_filter.noMatchDecission, HC_is(HC_equalToInteger(DRYLoggingAppenderFilterDecissionDeny)));
}

- (void)testFilterShouldHavePropertiesFromInitializer {
    DRYLoggingAppenderLevelFilter *filter = [[DRYLoggingAppenderLevelFilter alloc] initWithLevel:DRYLogLevelOff exactMatchRequired:NO matchDecission:DRYLoggingAppenderFilterDecissionNeutral noMatchDecission:DRYLoggingAppenderFilterDecissionNeutral];
    HC_assertThat(filter, HC_allOf(HC_hasProperty(@"level", HC_equalToInteger(DRYLogLevelOff)), HC_hasProperty(@"exactMatchRequired", HC_isFalse()), HC_hasProperty(@"matchDecission", HC_equalToInteger(DRYLoggingAppenderFilterDecissionNeutral)), HC_hasProperty(@"noMatchDecission", HC_equalToInteger(DRYLoggingAppenderFilterDecissionNeutral)), nil));
}


@end
