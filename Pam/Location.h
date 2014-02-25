#import <MapKit/MapKit.h>

@class Place;
@class PMAnnotation;

@interface Location : NSManagedObject{

}

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) Place *place;

@property (nonatomic) CLLocationCoordinate2D coordinate;

- (PMAnnotation*)annotation;
@end
