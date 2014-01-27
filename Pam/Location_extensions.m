//
//  PMLocation_extensions.m
//  Pam
//
//  Created by Ian Dundas on 26/01/2014.
//  Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Location_extensions.h"
#import "PMAnnotation.h"

@implementation Location (model)

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.latitude = [self.latitude doubleValue]; // or self.latitudeValue à la MOGen
    coord.longitude = [self.longitude doubleValue];
    return coord;
}

- (PMAnnotation *)annotation {
    if (!_annotation){
        _annotation= [[PMAnnotation alloc]init];
        [_annotation setTitle:self.title];
        [_annotation setSubtitle:self.subtitle];
        [_annotation setCoordinate:self.coordinate];
    }
    return _annotation;
}

@end
