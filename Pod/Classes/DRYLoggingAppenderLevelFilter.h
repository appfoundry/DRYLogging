//
//  DRYLoggingAppenderLevelFilter.h
//  Pods
//
//  Created by Michael Seghers on 17/04/15.
//
//

#import <Foundation/Foundation.h>
#import <DRYLogging/DRYLogger.h>
#import <DRYLogging/DRYLoggingAppenderFilter.h>
#import "DRYLoggingAppenderFilter.h"
#import "DRYLogger.h"

@class DRYLoggingMessage;

@interface DRYLoggingAppenderLevelFilter : NSObject<DRYLoggingAppenderFilter>


@property(nonatomic) DRYLogLevel level;
@property(nonatomic) BOOL exactMatchRequired;
@property(nonatomic) DRYLoggingAppenderFilterDecission matchDecission;
@property(nonatomic) DRYLoggingAppenderFilterDecission noMatchDecission;

+ (instancetype)filterWithLevel:(DRYLogLevel)level exactMatchRequired:(BOOL)exactMatchRequired matchDecission:(DRYLoggingAppenderFilterDecission)matchDecission noMatchDecission:(DRYLoggingAppenderFilterDecission)noMatchDecission;
- (instancetype)initWithLevel:(DRYLogLevel)level exactMatchRequired:(BOOL)exactMatchRequired matchDecission:(DRYLoggingAppenderFilterDecission)matchDecission noMatchDecission:(DRYLoggingAppenderFilterDecission)noMatchDecission;

@end
