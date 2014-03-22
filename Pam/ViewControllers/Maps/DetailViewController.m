//
// Created by Ian Dundas on 20/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "DetailViewController.h"
#import "Location.h"
#import "IDTransitioningDelegate.h"


@implementation DetailViewController {

}
- (id)initWithLocation:(Location *)location {
    if (self= [super init]){

    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view.layer setCornerRadius:5];
    [self.view.layer setMasksToBounds:YES];
}

@end