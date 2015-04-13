//
//  DRYViewController.m
//  DRYLogging
//
//  Created by Michael Seghers on 04/09/2015.
//  Copyright (c) 2014 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLoggerFactory.h>
#import "DRYViewController.h"
#import "DRYLogger.h"

@interface DRYViewController () {
    id <DRYLogger> _logger;
}

@end

@implementation DRYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _logger = [DRYLoggerFactory loggerWithName:@"viewcontroller.DRYViewController"];
    [_logger trace:@"Controller view did load"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_logger warn:@"Memory warning!"];
}

@end
