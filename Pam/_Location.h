// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Location.h instead.

#import <CoreData/CoreData.h>


extern const struct LocationAttributes {
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *subtitle;
	__unsafe_unretained NSString *title;
} LocationAttributes;

extern const struct LocationRelationships {
	__unsafe_unretained NSString *place;
} LocationRelationships;

extern const struct LocationFetchedProperties {
} LocationFetchedProperties;

@class Place;






@interface LocationID : NSManagedObjectID {}
@end

@interface _Location : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (LocationID*)objectID;





@property (nonatomic, strong) NSNumber* latitude;



@property float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* subtitle;



//- (BOOL)validateSubtitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Place *place;

//- (BOOL)validatePlace:(id*)value_ error:(NSError**)error_;





@end

@interface _Location (CoreDataGeneratedAccessors)

@end

@interface _Location (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;




- (NSString*)primitiveSubtitle;
- (void)setPrimitiveSubtitle:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (Place*)primitivePlace;
- (void)setPrimitivePlace:(Place*)value;


@end
