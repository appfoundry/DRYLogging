//
//  DRYViewController.m
//  DRYLogging
//
//  Created by Michael Seghers on 04/09/2015.
//  Copyright (c) 2014 Michael Seghers. All rights reserved.
//

#import <DRYLogging/DRYLogging.h>
#import "DRYViewController.h"

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

- (IBAction)_logATrace:(id)sender {
    [_logger trace:@"Trace action invoked"];
}


- (IBAction)_logADebug:(id)sender {
    [_logger debug:@"Debug action invoked"];
}

- (IBAction)_logAnInfo:(id)sender {
    [_logger info:@"Info action invoked"];
}

- (IBAction)_logAWarn:(id)sender {
    [_logger warn:@"Warn action invoked"];
}

- (IBAction)_logAnError:(id)sender {
    [_logger error:@"Error action invoked"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_logger warn:@"Memory warning!"];
}

@end
