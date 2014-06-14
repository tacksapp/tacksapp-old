//
// Created by Ian Dundas on 25/02/14.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Location;

@interface PMAnnotation : NSObject <MKAnnotation>
@property(nonatomic) BOOL animateOnAdd;

- (instancetype)initWithLocation:(Location *)location;
@property(nonatomic, strong) Location *location;
@end