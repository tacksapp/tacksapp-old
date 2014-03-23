//
// Created by Ian Dundas on 20/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class IDTransitioningDelegate;
@class Location;


@interface DetailViewController : UIViewController
// TODO: maybe shouldn't be strong, is a delegate?
@property(nonatomic, strong) IDTransitioningDelegate *transitioningDelegate;

//@property(nonatomic) CLLocationCoordinate2D sourceCoordinate;
@property(nonatomic) CGPoint animateFromPoint;

@property(nonatomic, strong) Location *location;

- (id)initWithLocation:(Location *)location;
@end