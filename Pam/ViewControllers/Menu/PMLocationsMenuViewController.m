//
// Created by Ian Dundas on 24/02/14.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <ObjectiveSugar/NSString+ObjectiveSugar.h>
#import "PMLocationsMenuViewController.h"
#import "Place.h"
#import "Location.h"
#import "PMMapViewController.h"
#import "PMAppDelegate.h"
#import "JSSlidingViewController.h"
#import "PMLocationTableViewCell.h"

static NSString* cellIdentifier = @"PMLocationsMenuViewControllerCell";

@interface PMLocationsMenuViewController ()
@property(nonatomic, strong) NSArray *locations;

@end

@implementation PMLocationsMenuViewController {

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TKLocationDidSaveNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.place.title];
    [self.tableView registerClass:[PMLocationTableViewCell class] forCellReuseIdentifier:cellIdentifier];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:TKLocationDidSaveNotification
                                               object:nil];
    [self refreshData];
}

- (void)refreshData { // TODO: implement using a FRController instead
    self.locations = [Location where:@{@"place" : self.place} order:@{@"title" : @"ASC"}];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section){
        case 0:
            return 1;
        case 1:
            return self.locations.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        [cell.textLabel setText:@"Show all"];
    }
    else if (indexPath.section==1){
        Location *location= [self.locations objectAtIndex:(NSUInteger) indexPath.row];
        [cell.textLabel setText:location.title];

        if (self.delegate.userLocation){
            CLLocationDistance distance = [location.clLocation distanceFromLocation:self.delegate.userLocation.location];
            [cell.detailTextLabel setText: NSStringWithFormat(@"%.0f km", distance/1000)];
        }
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0){
        __weak typeof(self)weakSelf = self;
        [[AppDelegate slidingViewController] closeSlider:YES completion:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;

            [strongSelf.delegate focusLocations:self.locations];
        }];
    }
    else if (indexPath.section==1){
        __weak typeof(self)weakSelf = self;
        [[AppDelegate slidingViewController] closeSlider:YES completion:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;

            Location *location= [strongSelf.locations objectAtIndex:(NSUInteger)indexPath.row];
            [strongSelf.delegate selectLocation:location];
        }];
    }
}

@end
