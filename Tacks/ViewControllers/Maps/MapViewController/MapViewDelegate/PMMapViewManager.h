//
// Created by Ian Dundas on 08/06/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "PMMapViewController.h"


@protocol PMMapViewControllerDelegate, MapDisplayProtocol;
@class Location;
@class Place;

@interface PMMapViewManager : NSObject <MKMapViewDelegate, MapDisplayProtocol>
@property (nonatomic, weak) id<PMMapViewControllerDelegate> delegate;

@property (nonatomic, strong) Place *filterPlace;

- (instancetype)initWithMapView:(MKMapView *)mapView;

- (void)plotLocations;

- (void)plotLocations:(NSArray *)locations;

- (void)focusAllMapAnnotations;

- (void)focusMapOnCurrentLocation;
- (MKUserLocation *)userLocation;
@end

@protocol PMMapViewControllerDelegate
@property (nonatomic, strong, readonly) MKMapView *mapView;
- (void)showEditLocationViewController:(Location *)location fromPoint:(CGPoint)animateFromPoint;
@end