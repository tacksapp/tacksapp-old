//
// Created by Ian Dundas on 21/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "IDTransitionController.h"
#import "UIView+blurring.h"
#import "DetailViewController.h"


@implementation IDTransitionController {

}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.isReversed? 0.8: 1.2;
}

- (float)transitionDamping:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.isReversed? 0.9:0.8;
}

- (float)transitionInitialSpringVelocity:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 10;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    UIView *inView= transitionContext.containerView;

    UIViewController *fromViewController= [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView= fromViewController.view;
    UIViewController *toViewController= [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView= toViewController.view;

    [inView setBackgroundColor: [UIColor clearColor]];

    CGRect finalRect;
    CGPoint sourcePoint;

    if (self.isReversed){
        [inView insertSubview:toView belowSubview:fromView];
        [toView unblurWithAnimationDuration: [self transitionDuration:transitionContext]*0.7];

        sourcePoint= inView.center;
        finalRect= CGRectMake (sourcePoint.x, sourcePoint.y, 10, 10);
    }
    else{
        [fromView blurWithAnimationDuration:[self transitionDuration:transitionContext]*0.7];

        // TODO remove reliance on DetailViewController (and use inView.centre if not exist)
        sourcePoint= ((DetailViewController *)toViewController).animateFromPoint;
        finalRect= CGRectMake (20, 70, 280, 160) ; // TODO use CGRectInset etc to make this fit different screens (fromView.frame, 20, 70)

        CGRect initialRect= CGRectMake (sourcePoint.x, sourcePoint.y, 10, 10);

        toView.alpha= 0.0;
        toView.frame= initialRect;

        [inView insertSubview:toView aboveSubview:fromView];
    }

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:[self transitionDamping:transitionContext]
          initialSpringVelocity:[self transitionInitialSpringVelocity:transitionContext]
                        options:0
                     animations:^{
                         if ([self isReversed]) {
                             fromView.frame = finalRect;
                             fromView.alpha = 0;
                         }
                         else {
                             toView.alpha = 1;
                             toView.frame = finalRect;
                         }
                     } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }
    ];


}

@end