//
// Created by Ian Dundas on 20/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "DetailViewController.h"
#import "Location.h"
#import "IDTransitioningDelegate.h"
#import "UIView+AutoLayout.h"


@interface DetailViewController ()
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextView *subtitleTextView;

- (void)configureViews;

- (void)placeViews;

- (void)constrainViews;
@end

@implementation DetailViewController {
}

- (id)initWithLocation:(Location *)location {
    if (self= [super init]){
        _location= location;
        _titleTextField= [[UITextField alloc] initWithFrame:CGRectZero];
        _subtitleTextView= [[UITextView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.location setTitle:self.titleTextField.text];
    [self.location setSubtitle:self.subtitleTextView.text];
    [self.location save];
}
#pragma mark - UIViewController
-(void) configureViews{
    [self.titleTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.subtitleTextView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.titleTextField setText: self.location.title];
    [self.titleTextField setPlaceholder:@"Title"];
    [self.titleTextField setFont:[UIFont fontWithName:@"GillSans" size:24]];
    [self.titleTextField setBackgroundColor:[UIColor whiteColor]];
    [self.titleTextField setTextColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1]];

    [self.subtitleTextView setDelegate:self];
    [self.subtitleTextView setBackgroundColor:[UIColor whiteColor]];
    [self.subtitleTextView setFont:[UIFont fontWithName:@"GillSans" size:20]];
    [self.subtitleTextView setTextColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1]];
    [self.subtitleTextView setText:self.location.subtitle];
//    [self.subtitleTextView setPlaceholder: @"Location"];

}
-(void) placeViews{
    [self.view addSubview:self.titleTextField];
    [self.view addSubview:self.subtitleTextView];

}
-(void) constrainViews{
    [self.titleTextField pinToSuperviewEdges:JRTViewPinLeftEdge|JRTViewPinRightEdge|JRTViewPinTopEdge inset:20];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];

    [self.subtitleTextView pinEdge:NSLayoutAttributeTop toEdge:NSLayoutAttributeBottom ofView:self.titleTextField inset:20];
    [self.subtitleTextView pinEdge:NSLayoutAttributeLeft toEdge:NSLayoutAttributeLeft ofView:self.titleTextField inset:-3];
    [self.subtitleTextView pinEdge:NSLayoutAttributeRight toEdge:NSLayoutAttributeRight ofView:self.titleTextField inset:-3];
    [self.subtitleTextView pinToSuperviewEdges:JRTViewPinBottomEdge inset:20];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view.layer setCornerRadius:5];
    [self.view.layer setMasksToBounds:YES];

    [self configureViews];
    [self placeViews];
    [self constrainViews];
}

@end