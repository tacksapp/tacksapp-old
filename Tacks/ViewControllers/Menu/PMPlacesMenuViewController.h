//
// Created by Ian Dundas on 24/02/14.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MapDisplayProtocol;
@class Place;


@interface PMPlacesMenuViewController : UITableViewController
- (void)refreshData;
@property (nonatomic, weak) id<MapDisplayProtocol> delegate;
@end
