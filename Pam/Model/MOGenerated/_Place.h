// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Place.h instead.

#import <CoreData/CoreData.h>


extern const struct PlaceAttributes {
	__unsafe_unretained NSString *title;
} PlaceAttributes;

extern const struct PlaceRelationships {
	__unsafe_unretained NSString *locations;
} PlaceRelationships;

extern const struct PlaceFetchedProperties {
} PlaceFetchedProperties;

@class Location;



@interface PlaceID : NSManagedObjectID {}
@end

@interface _Place : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PlaceID*)objectID;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *locations;

- (NSMutableSet*)locationsSet;





@end

@interface _Place (CoreDataGeneratedAccessors)

- (void)addLocations:(NSSet*)value_;
- (void)removeLocations:(NSSet*)value_;
- (void)addLocationsObject:(Location*)value_;
- (void)removeLocationsObject:(Location*)value_;

@end

@interface _Place (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableSet*)primitiveLocations;
- (void)setPrimitiveLocations:(NSMutableSet*)value;


@end
