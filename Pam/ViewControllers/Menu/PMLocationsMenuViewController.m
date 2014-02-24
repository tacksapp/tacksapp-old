//
// Created by Ian Dundas on 24/02/14.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "PMLocationsMenuViewController.h"
#import "Place.h"
#import "Location.h"
#import "PMMainMapViewController.h"
#import "PMAppDelegate.h"
#import "JSSlidingViewController.h"

static NSString* cellIdentifier = @"PMLocationsMenuViewControllerCell";

@interface PMLocationsMenuViewController ()
@property(nonatomic, strong) NSArray *locations;
@end

@implementation PMLocationsMenuViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Locations"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

    [self refreshData];
}

- (void)refreshData {
    self.locations = [Location where:@{@"place" : self.place}];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    Location *location= [self.locations objectAtIndex:(NSUInteger) indexPath.row];
    [cell.textLabel setText:location.title];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self)weakSelf = self;
    [[AppDelegate slidingViewController] closeSlider:YES completion:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;

        [strongSelf.delegate selectLocation:[strongSelf.locations objectAtIndex:(NSUInteger)indexPath.row]];
    }];
}

@end
