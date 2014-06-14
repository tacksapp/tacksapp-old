//
// Created by Ian Dundas on 13/02/14.
//

#import <Foundation/Foundation.h>
#import "GVUserDefaults.h"

@interface GVUserDefaults (defaults)
@property(nonatomic, weak) NSString *filterByPlaceObjectID;

- (NSDictionary *)setupDefaults;
@end