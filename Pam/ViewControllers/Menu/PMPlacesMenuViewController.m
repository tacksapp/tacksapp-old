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

static NSString* cellIdentifier = @"PMRootMenuViewControllerCell";

@interface PMPlacesMenuViewController ()<UIGestureRecognizerDelegate, UIAlertViewDelegate>
@property(nonatomic, strong) NSArray *places;
- (void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;
@end

@implementation PMPlacesMenuViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Places"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

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


#pragma mark Add Location
- (void)startAddPlace {
    // TODO: implement with semi-transparent modal instead

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Place" message:@"Please enter place name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        NSString *placeName= [[alertView textFieldAtIndex:0] text];

        Place *place=[Place create:@{
                @"title" : placeName,
        }];
        [place save];

        [self refreshData];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    Place *place= [self.places objectAtIndex:(NSUInteger) indexPath.row];

    [cell.textLabel setText:NSStringWithFormat (@"%@%@", place.title, [place isDefault]?@"!":@"")];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PMLocationsMenuViewController *viewController= [[PMLocationsMenuViewController alloc] initWithNibName:nil bundle:nil];

    Place *place= [self.places objectAtIndex:(NSUInteger) indexPath.row];
    [viewController setPlace:place];
    [viewController setDelegate:self.delegate];

    [self.navigationController pushViewController:viewController animated:YES];

}

@end
