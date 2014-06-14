//
// Created by Ian Dundas on 27/01/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "PMMapViewManager.h"

@class Location, Place;

@protocol MapDisplayProtocol, PMMapViewControllerDelegate;
@interface PMMapViewController : UIViewController <MapDisplayProtocol, PMMapViewControllerDelegate>{
    @protected
        MKMapView *_mapView;
}
@end

@protocol MapDisplayProtocol
- (void)filterByPlace:(Place *)place;
-(void)focusLocation:(Location*)location;
-(void)focusLocations:(NSArray*)locations;
-(void)selectLocation:(Location*)location;
-(MKUserLocation*)userLocation;
@end

