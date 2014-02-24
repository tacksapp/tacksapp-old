//
// Created by Ian Dundas on 24/02/14.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "PMPlacesMenuViewController.h"
#import "Place.h"
#import "PMLocationsMenuViewController.h"
#import "PMMainMapViewController.h"

static NSString* cellIdentifier = @"PMRootMenuViewControllerCell";

@interface PMPlacesMenuViewController ()
@property(nonatomic, strong) NSArray *places;

@end

@implementation PMPlacesMenuViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Places"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    Place *place= [self.places objectAtIndex:(NSUInteger) indexPath.row];
    [cell.textLabel setText:place.title];
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
