//
// Created by Ian Dundas on 24/02/14.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Place;
@protocol MapDisplayProtocol;

@interface PMLocationsMenuViewController : UITableViewController

@property (nonatomic, strong) Place *place;
@property (nonatomic, weak) id<MapDisplayProtocol> delegate;

- (void)refreshData;
@end
