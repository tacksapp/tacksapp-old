//
//  PMLocation_extensions.h
//  Pam
//
//  Created by Ian Dundas on 26/01/2014.
//  Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Model.h"

@class PMAnnotation;

@interface Location (model) <MKAnnotation>
@property(nonatomic, strong) PMAnnotation *annotation;
@end
