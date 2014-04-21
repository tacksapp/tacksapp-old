//
// Created by Ian Dundas on 29/01/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MKMapView+zooming.h"


@implementation MKMapView (zooming)

/*
  def max_distance_shown_in_mapview(mapView) # Oliver @ http://stackoverflow.com/a/7994670/349364
    # You first have to get the corner point and convert it to a coordinate
    mapRect = mapView.visibleMapRect
    cornerPointNW = MKMapPointMake(mapRect.origin.x, mapRect.origin.y)
    cornerCoordinate = MKCoordinateForMapPoint(cornerPointNW)

    corner_cllocation = CLLocation.alloc.initWithLatitude(cornerCoordinate.latitude, longitude:cornerCoordinate.longitude)
    center_cllocation = CLLocation.alloc.initWithLatitude(mapView.centerCoordinate.latitude, longitude:mapView.centerCoordinate.longitude)

    # And then calculate the distance
    distance = corner_cllocation.distanceFromLocation(center_cllocation)
    return distance
  end
 */

// Oliver @ http://stackoverflow.com/a/7994670/349364
- (CLLocationDistance)maxDistanceShown {
    MKMapRect mapRect= self.visibleMapRect;

    MKMapPoint cornerPointNW= MKMapPointMake (mapRect.origin.x, mapRect.origin.y);

    CLLocationCoordinate2D cornerCoordinate = MKCoordinateForMapPoint(cornerPointNW);

    CLLocation *cornerCLLocation= [CLLocation.alloc initWithLatitude:cornerCoordinate.latitude longitude:cornerCoordinate.longitude];
    CLLocation *centreCLLocation = [CLLocation.alloc initWithLatitude:self.centerCoordinate.latitude longitude:self.centerCoordinate.longitude];

    // And then calculate the distance
    CLLocationDistance distance = [cornerCLLocation distanceFromLocation:centreCLLocation];

    return distance;
}

@end
