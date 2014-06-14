//
//  PMAppDelegate.h
//  Tacks
//
//  Created by Ian Dundas on 25/01/2014.
//  Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMPlacesMenuViewController;
@class JSSlidingViewController;

@interface PMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) PMPlacesMenuViewController *menuViewController;
@property (strong, nonatomic) UINavigationController *mapNavigationController;
@property (strong, nonatomic) JSSlidingViewController *slidingViewController;

@end
