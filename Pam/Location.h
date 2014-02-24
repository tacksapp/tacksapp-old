#import <MapKit/MapKit.h>

@class Place;

@interface Location : NSManagedObject<MKAnnotation>{

}

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) Place *place;
@end
