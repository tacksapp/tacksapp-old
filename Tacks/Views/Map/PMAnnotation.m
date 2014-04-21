//
// Created by Ian Dundas on 25/02/14.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <ObjectiveSugar/NSString+ObjectiveSugar.h>
#import "PMAnnotation.h"
#import "Location.h"


@implementation PMAnnotation {

}

-(instancetype)initWithLocation:(Location*)location{
    if (self=[super init]){
        [self setLocation:location];
    }
    return self;
}
- (NSString *)description {
    return NSStringWithFormat(@"Annotation <%p>:%@, %f,%f", self, self.title, self.coordinate.latitude, self.coordinate.longitude);
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    [self.location setCoordinate:newCoordinate];
}

- (CLLocationCoordinate2D)coordinate {
    return self.location.coordinate;
}

- (NSString *)title {
    return self.location.title;
}

- (NSString *)subtitle {
    return self.location.subtitle;
}

@end