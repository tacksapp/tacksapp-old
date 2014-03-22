//
// Created by Ian Dundas on 21/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (blurring)
@property (nonatomic, strong) UIImageView *blurImageView;

- (void)blur;

- (BOOL)isBlurred;

- (void)unblur;

- (void)blurWithAnimationDuration:(NSTimeInterval)duration;

- (void)unblurWithAnimationDuration:(NSTimeInterval)duration;
@end