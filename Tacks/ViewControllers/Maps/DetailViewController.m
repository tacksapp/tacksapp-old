//
// Created by Ian Dundas on 20/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "DetailViewController.h"
#import "Location.h"
#import "CompactConstraint.h"
#import "UIView+CompactConstraint.h"
#import "UIView+AutoLayout.h"
#import "NSDictionary+ObjectiveSugar.h"
#import "UIView+Positioning.h"

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

- (void)constrainViews {

    self.titleTextField.frame = CGRectMake (20, 20, self.view.width - 40, 40);
    self.subtitleTextView.frame = CGRectMake (20, self.titleTextField.bottom, self.view.width-40, 40);

//    NSDictionary *metrics = @{
//    };
//    NSDictionary *views = NSDictionaryOfVariableBindings(_titleTextField, _subtitleTextView);
//
//    [views each:^(id key, UIView *view) {
//        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
//    }];
//    [self.titleTextField pinToSuperviewEdges:JRTViewPinLeftEdge|JRTViewPinTopEdge inset:20];
//
//    [self.view addCompactConstraints:@[
//            @"_titleTextField.height = 40",
//            @"_titleTextField.width = super.width-40",
//
//            @"_subtitleTextView.top = _titleTextField.bottom + 10",
//            @"_subtitleTextView.left = _titleTextField.left -3",
//            @"_subtitleTextView.width = _titleTextField.width",
//            @"_subtitleTextView.bottom = super.bottom - 20",
//    ] metrics:metrics views:views];
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