#import "Location.h"
#import "Place.h"
#import "NSString+ObjectiveSugar.h"
#import "PMAnnotation.h"

@interface Location ()
+ (NSMutableDictionary *)sharedAnnotations;
@end


@implementation Location
@dynamic latitude, longitude, title, subtitle, place, createdAt, updatedAt;

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


#pragma mark NSManagedObject boilerplate:
- (void)awakeFromInsert{
    [super awakeFromInsert];

    if(!self.createdAt)
        self.createdAt = [NSDate date];
}
- (void) willSave{
    [super willSave];

    if (self.updatedAt==nil || [self.updatedAt compare:[NSDate dateWithTimeIntervalSinceNow: -5]]==NSOrderedAscending){
        self.updatedAt= [NSDate date];
    }
}

- (PMAnnotation*)annotation{
    PMAnnotation *annotation= [[Location sharedAnnotations] objectForKey:self.objectID];

    if (!annotation){
        annotation= [[PMAnnotation alloc]initWithLocation:self];
        [[Location sharedAnnotations] setObject:annotation forKey:self.objectID];
    }
    return annotation;
}

+ (NSMutableDictionary *)sharedAnnotations {
    static NSMutableDictionary *_sharedAnnotations = nil;

    @synchronized (self) {
        if (_sharedAnnotations == nil) {
            _sharedAnnotations = [[NSMutableDictionary alloc] init];
        }
    }
    return _sharedAnnotations;
}
@end

