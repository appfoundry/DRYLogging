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
}

@end

@implementation DRYViewController

DRYInitializeStaticLogger(@"viewcontroller.DRYViewController");

- (void)viewDidLoad
{
    [super viewDidLoad];
    DRYTrace(@"Controller view did load");
}

- (IBAction)_logATrace:(id)sender {
    DRYTrace(@"Trace action invoked");
}

- (IBAction)_logADebug:(id)sender {
    DRYDebug(@"Debug action invoked");
}

- (IBAction)_logAnInfo:(id)sender {
    DRYInfo(@"Info action invoked");
}

- (IBAction)_logAWarn:(id)sender {
    DRYWarn(@"Warn action invoked");
}

- (IBAction)_logAnError:(id)sender {
    NSString *loremIpsum = @"Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Sed posuere consectetur est at lobortis. Curabitur blandit tempus porttitor. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Etiam porta sem malesuada magna mollis euismod. Curabitur blandit tempus porttitor. Maecenas sed diam eget risus varius blandit sit amet non magna.\n\nEtiam porta sem malesuada magna mollis euismod. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Sed posuere consectetur est at lobortis. Sed posuere consectetur est at lobortis. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nMaecenas sed diam eget risus varius blandit sit amet non magna. Donec sed odio dui. Etiam porta sem malesuada magna mollis euismod. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Nulla vitae elit libero, a pharetra augue.\n\nDonec id elit non mi porta gravida at eget metus. Aenean lacinia bibendum nulla sed consectetur. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Donec id elit non mi porta gravida at eget metus.";
    
    for (int i = 0; i < 100; i++) {
        DRYError(@"Error action invoked, let's log a lot so we can show off the rolling file mechanism: %@", loremIpsum);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DRYWarn(@"Memory warning!");
}

@end
