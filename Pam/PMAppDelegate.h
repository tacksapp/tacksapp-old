//
//  PMAppDelegate.h
//  Pam
//
//  Created by Ian Dundas on 25/01/2014.
//  Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *moContext;

- (void)saveContext;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
