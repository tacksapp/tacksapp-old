//
//  PMAppDelegate.m
//  Pam
//
//  Created by Ian Dundas on 25/01/2014.
//  Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PMAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "PMMapViewController.h"
#import "Location.h"
#import "JSSlidingViewController.h"
#import "PMPlacesMenuViewController.h"
#import "Place.h"

@implementation PMAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    [self createSomeDevRecords];

    PMMapViewController *mainMapViewController = [[PMMapViewController alloc] initWithNibName:nil bundle:nil];

    self.menuViewController= [[PMPlacesMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.menuViewController setDelegate:mainMapViewController];

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.menuViewController];

    self.slidingViewController= [[JSSlidingViewController alloc] initWithFrontViewController:mainMapViewController backViewController:self.navigationController];
    self.slidingViewController.useBouncyAnimations=NO;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.slidingViewController; //self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[CoreDataManager sharedManager] saveContext];
}

#pragma mark - Core Data
- (void) createSomeDevRecords{ // TODO delete

    if ([Place count]> 0)
        return;

    NSLog(@"Creating some dev entities.. ");


    Place *place=[Place create:@{
         @"title" : @"Amsterdam",
         @"isDefault": @YES,
    }];

    [Location create:@{
            @"title": @"Home",
            @"latitude":@52.373468,
            @"longitude":@4.8501605,
            @"place": place,
    }];

    [Location create:@{
            @"title": @"Work",
            @"latitude":@52.473468,
            @"longitude":@4.9501605,
            @"place": place,
    }];

    [Location create:@{
            @"title": @"Party",
            @"latitude":@52.273468,
            @"longitude":@4.1501605,
            @"place": place,
    }];

    [place save];
}
@end
