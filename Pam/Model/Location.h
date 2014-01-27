#import <MapKit/MapKit.h>
#import "_Location.h"

@class PMAnnotation;

@interface Location : _Location<MKAnnotation> {}
@property(nonatomic, strong) PMAnnotation *annotation;
@end
