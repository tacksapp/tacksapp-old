//
// Created by Ian Dundas on 27/01/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class OCMapView;
@class Location;

@protocol MapDisplayProtocol
-(void)focusLocation:(Location*)location;
-(void) selectLocation:(Location*)location;
@end

@interface PMMainMapViewController : UIViewController <MapDisplayProtocol>

@property (nonatomic, strong) OCMapView *mapView;
@end
