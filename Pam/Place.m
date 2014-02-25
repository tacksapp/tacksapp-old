#import "Place.h"


@interface Place ()

// Private interface goes here.

@end

@implementation Place
@dynamic locations, title, isDefault, createdAt, updatedAt;

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

@end
