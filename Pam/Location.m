#import "Location.h"

@interface Location ()


@end


@implementation Location
//@synthesize annotation=_annotation;

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.latitude = [self.latitude doubleValue]; // or self.latitudeValue à la MOGen
    coord.longitude = [self.longitude doubleValue];
    return coord;
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

