#import "Location.h"
#import "Place.h"
#import "NSString+ObjectiveSugar.h"

@interface Location ()
@end


@implementation Location
@dynamic latitude, longitude, title, subtitle, place;

- (NSString *)description {
    return NSStringWithFormat(@"%@:%f,%f", self.title, self.coordinate.latitude, self.coordinate.longitude);
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.latitude = self.latitude;
    coord.longitude = self.longitude;
    return coord;
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    self.latitude= newCoordinate.latitude;
    self.longitude= newCoordinate.longitude;
}


//- (PMAnnotation *)annotation {
//    if (!_annotation){
//        _annotation= [[PMAnnotation alloc]init];
//        [_annotation setTitle:self.title];
//        [_annotation setSubtitle:self.subtitle];
//        [_annotation setCoordinate:self.coordinate];
//    }
//    return _annotation;
//}
@end

