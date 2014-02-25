
@interface Place : NSManagedObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSSet *locations;

@property (nonatomic) BOOL isDefault;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@end
