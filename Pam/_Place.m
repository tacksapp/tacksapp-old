// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Place.m instead.

#import "_Place.h"

const struct PlaceAttributes PlaceAttributes = {
	.title = @"title",
};

const struct PlaceRelationships PlaceRelationships = {
	.locations = @"locations",
};

const struct PlaceFetchedProperties PlaceFetchedProperties = {
};

@implementation PlaceID
@end

@implementation _Place

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Place";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Place" inManagedObjectContext:moc_];
}

- (PlaceID*)objectID {
	return (PlaceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic title;






@dynamic locations;

	
- (NSMutableSet*)locationsSet {
	[self willAccessValueForKey:@"locations"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"locations"];
  
	[self didAccessValueForKey:@"locations"];
	return result;
}
	






@end
