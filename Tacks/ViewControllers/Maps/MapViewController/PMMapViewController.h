//
// Created by Ian Dundas on 27/01/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "PMMapViewManager.h"

@class Location;

@protocol MapDisplayProtocol, PMMapViewControllerDelegate;
@interface PMMapViewController : UIViewController <MapDisplayProtocol, PMMapViewControllerDelegate>


@end

@protocol MapDisplayProtocol
-(void)focusLocation:(Location*)location;
-(void)selectLocation:(Location*)location;
-(void)focusLocations:(NSArray*)locations;
-(MKUserLocation*)userLocation;
@end

