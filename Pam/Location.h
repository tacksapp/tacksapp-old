#import <MapKit/MapKit.h>

@class Place;
@class PMAnnotation;

FOUNDATION_EXPORT NSString *const TKLocationDidSaveNotification;

@interface Location : NSManagedObject{

}

@property (nonatomic, strong) NSString *primitiveTitle;

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) Place *place;

@property (nonatomic) CLLocationCoordinate2D coordinate;

- (CLLocation *)clLocation;

- (PMAnnotation*)annotation;
@end
