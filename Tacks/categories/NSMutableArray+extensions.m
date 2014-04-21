//
// Created by Ian Dundas on 25/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "NSMutableArray+extensions.h"


@implementation NSMutableArray (extensions)
-(BOOL)removeObjectAndConfirmChange:(id)object{
    @synchronized (self) {
        int before= [self count];

        [self removeObject:object];

        int after= [self count];

        return before > after;
    }
}
@end