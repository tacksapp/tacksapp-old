//
//  TacksTests.m
//  TacksTests
//
//  Created by Ian Dundas on 25/01/2014.
//  Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Model.h"
#import "NSManagedObject+DVCoreDataFinders.h"
#import "NSArray+ObjectiveSugar.h"

@interface TacksTests : XCTestCase
-(void)setUp;
-(void)tearDown;

@property(nonatomic, strong) NSManagedObjectContext *moContext;
@end

@implementation TacksTests

- (void)setUp {
    [super setUp];
    
    // Setup Core Data:
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moContext = [[NSManagedObjectContext alloc] init];
    self.moContext.persistentStoreCoordinator = psc;
}

- (void)tearDown {
    self.moContext = nil;
    [super tearDown];
}

#pragma mark Tests:

-(void)testStartingStateIsSane{
    NSError *error;
    NSUInteger count= [Location countAllInContext:self.moContext error:&error];

    XCTAssertNil(error, @"Can count Location entities");
    XCTAssertTrue(count==0, @"Count starts at zero");
}
- (void)testCanCreateEntityInstance
{
    Location *entity = [Location insertIntoContext:self.moContext];
    entity.title = @"a title";
    entity.latitude= @1.23;
    entity.longitude=@1.45;

    NSError *error;
    [self.moContext save:&error];
    XCTAssertNil(error, @"Save a Core Data model instance");

    NSUInteger count= [Location countAllInContext:self.moContext error:&error];
    XCTAssertTrue(count==1, @"Count is now one");
}

-(void) testCanRetrieveAnyEntityInstance
{
    Location *entity = [Location insertIntoContext:self.moContext];
    entity.title = @"a title";
    entity.latitude= @1.23;
    entity.longitude=@1.45;

    NSError *error;
    [self.moContext save:&error];

    NSArray *entities= [Location findAllInContext:self.moContext error:&error];
    XCTAssert([entities.first respondsToSelector:@selector(latitude)], @"Location object was retrieved");
}

@end
