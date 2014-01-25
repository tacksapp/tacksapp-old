//
//  IDAppDelegate.h
//  Pam
//
//  Created by Ian Dundas on 25/01/2014.
//  Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PamIncrementalStore.h"

@interface IDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
