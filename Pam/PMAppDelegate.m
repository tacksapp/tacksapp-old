//
//  PMAppDelegate.m
//  Pam
//
//  Created by Ian Dundas on 25/01/2014.
//  Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <DVCoreDataFinders/NSManagedObject+DVCoreDataFinders.h>
#import <MapKit/MapKit.h>
#import "PMAppDelegate.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "Location.h"
#import "PMMainMapViewController.h"

@implementation PMAppDelegate

@synthesize moContext = _moContext;

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [self setUpCoreDataStack];
    [self createSomeDevRecords];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    PMMainMapViewController *mainMapViewController = [[PMMainMapViewController alloc] initWithManagedObjectContext:self.moContext];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainMapViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
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
    [self saveContext];
}

#pragma mark - Core Data
- (void) createSomeDevRecords{ //todo deleteme
    Location *entity = [Location insertIntoContext:self.moContext];
    entity.title = @"Home";
    entity.latitude= @52.373468;
    entity.longitude=@4.8501605;

    NSError *error;
    [self.moContext save:&error];
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.moContext;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)setUpCoreDataStack
{
    if (self.moContext){
        NSLog(@"Warning: tried to setup core data a second time.");
        return;
    }
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Database.sqlite"];
    
    NSDictionary *options = @{NSPersistentStoreFileProtectionKey: NSFileProtectionComplete,
                              NSMigratePersistentStoresAutomaticallyOption:@YES};
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
    if (!store)
    {
        NSLog(@"Error adding persistent store. Error %@",error);
        
        NSError *deleteError = nil;
        if ([[NSFileManager defaultManager] removeItemAtURL:url error:&deleteError])
        {
            error = nil;
            store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
        }
        
        if (!store)
        {
            // Also inform the user...
            NSLog(@"Failed to create persistent store. Error %@. Delete error %@",error,deleteError);
            abort();
        }
    }
    
    _moContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _moContext.persistentStoreCoordinator = psc;
}

//
//- (NSManagedObjectContext *)moContext {
//    if (_managedObjectContext) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    
//    return _managedObjectContext;
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    if (_managedObjectModel) {
//        return _managedObjectModel;
//    }
//    
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Pam" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    if (_persistentStoreCoordinator) {
//        return _persistentStoreCoordinator;
//    }
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    
//    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[_persistentStoreCoordinator addPersistentStoreWithType:[PamIncrementalStore type] configuration:nil URL:nil options:nil error:nil];
//    
//    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"Pam.sqlite"];
//    
//    NSDictionary *options = @{
//        NSInferMappingModelAutomaticallyOption : @(YES),
//        NSMigratePersistentStoresAutomaticallyOption: @(YES)
//    };
//    
//    NSError *error = nil;
//    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}

@end
