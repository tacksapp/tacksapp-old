//
// Created by Ian Dundas on 24/02/14.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <ObjectiveSugar/NSArray+ObjectiveSugar.h>
#import <ObjectiveSugar/NSString+ObjectiveSugar.h>
#import "PMPlacesMenuViewController.h"
#import "Place.h"
#import "PMLocationsMenuViewController.h"
#import "PMMapViewController.h"
#import "PMPlaceTableViewCell.h"

static NSString* cellIdentifier = @"PMRootMenuViewControllerCell";

@interface PMPlacesMenuViewController ()<UIGestureRecognizerDelegate, UIAlertViewDelegate>
@property(nonatomic, strong) NSArray *places;
@property(nonatomic, strong) Place *currentlyEditingPlace;

- (void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;

- (void)startAddPlace;

- (void)startEditPlace:(Place *)place;
@end

@implementation PMPlacesMenuViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Places"];

    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startAddPlace)];

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 1; //seconds
    longPressGestureRecognizer.delegate = self;
    [self.tableView addGestureRecognizer:longPressGestureRecognizer];

    [self refreshData];
}

#pragma mark Gesture Recognisers:
-(void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan){
        CGPoint point = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath){
            // Want to set this row as default
            Place *newDefaultPlace= [self.places objectAtIndex:(NSUInteger) indexPath.row];

            [[Place all] each:^(Place *place) {
                place.isDefault = place==newDefaultPlace;
            }];

            [self refreshData];
        }
    }
}


#pragma mark Add/Edit Location
- (void)startAddPlace {
    // TODO: implement with semi-transparent modal instead

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Place" message:@"Please enter place name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag=1;
    [alert show];
}
-(void)startEditPlace:(Place*)place{
    self.currentlyEditingPlace= place;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSStringWithFormat(@"Edit %@", place.title) message:@"Please enter a new place name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag=2;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1){ // add place
        if (buttonIndex==1){ // OK
            NSString *placeName= [[alertView textFieldAtIndex:0] text];

            Place *place=[Place create:@{
                    @"title" : placeName,
            }];
            [place save];
        }
    }
    else if (alertView.tag==2){ // edit place
        if (buttonIndex==1){ // OK
            NSString *placeName= [[alertView textFieldAtIndex:0] text];
            [self.currentlyEditingPlace setTitle:placeName];
            [self.currentlyEditingPlace save];
        }
        [self setCurrentlyEditingPlace:nil];
    }
    [self refreshData];
}


- (void)refreshData {
    self.places = [Place all];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(!cell){
        cell= [[PMPlaceTableViewCell alloc] initWithReuseIdentifier:cellIdentifier];
    }

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    Place *place= [self.places objectAtIndex:(NSUInteger) indexPath.row];

    [cell.textLabel setText:NSStringWithFormat (@"%@ %@", place.title, [place isDefault]?@"(default)":@"")];
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PMLocationsMenuViewController *viewController= [[PMLocationsMenuViewController alloc] initWithNibName:nil bundle:nil];

    Place *place= [self.places objectAtIndex:(NSUInteger) indexPath.row];
    [viewController setPlace:place];
    [viewController setDelegate:self.delegate];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    Place *place= [self.places objectAtIndex:indexPath.row];
    [self startEditPlace:place];
}

@end
