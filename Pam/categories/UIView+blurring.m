//
// Created by Ian Dundas on 21/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+blurring.h"
#import "UIImage+ImageEffects.h"

@interface UIView()
- (UIImage *)staticBlurImage;
@end


static void * BlurImageViewPropertyKey = &BlurImageViewPropertyKey;

@implementation UIView (blurring)

-(void) blur{
    [self addSubview:self.blurImageView];
}

-(BOOL)isBlurred{
    return self.blurImageView != nil;
}

-(void) unblur{
    self.blurImageView.image= nil;
    [self.blurImageView removeFromSuperview];
    self.blurImageView= nil;
}

-(void) blurWithAnimationDuration:(NSTimeInterval) duration{
    [self.blurImageView setAlpha:0];
    [self addSubview:self.blurImageView];
    [UIView animateWithDuration:duration animations:^{
        [self.blurImageView setAlpha:1];
    }];
}

-(void) unblurWithAnimationDuration:(NSTimeInterval) duration{
    [self.blurImageView setAlpha:1];
    [self addSubview:self.blurImageView];
    [UIView animateWithDuration:duration animations:^{
        [self.blurImageView setAlpha:0];
    } completion:^(BOOL finished) {
        [self unblur];
    }];
}


// http://stackoverflow.com/a/14899909
- (UIImageView *)blurImageView {
    UIImageView *_blurImageView = objc_getAssociatedObject(self, BlurImageViewPropertyKey);

    if (!_blurImageView){
        _blurImageView = UIImageView.new;
        [_blurImageView setImage:self.staticBlurImage];
        [_blurImageView setFrame:self.bounds];
        [self setBlurImageView:_blurImageView];
    }
    return _blurImageView;
}
- (void)setBlurImageView:(UIImageView *)blurImageView {
    objc_setAssociatedObject(self, BlurImageViewPropertyKey, blurImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImage *) staticBlurImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen.scale);
        [self drawViewHierarchyInRect:self.frame afterScreenUpdates:true];
        UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext();

    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.2];
    return [newImage applyBlurWithRadius:5 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
@end