//
// Created by Ian Dundas on 20/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "IDTransitioningDelegate.h"
#import "IDTransitionController.h"


@implementation IDTransitioningDelegate {

}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return IDTransitionController.new;
}
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    IDTransitionController *transitioning= IDTransitionController.new;
    transitioning.isReversed = YES;
    return transitioning;
}
@end

/*
class IDTransitioningDelegate # <UIViewControllerTransitioningDelegate>


        def animationControllerForPresentedController(presented, presentingController: presenting, sourceController: source)
IDTransitionController.new #<UIViewControllerAnimatedTransitioning>
        end

def animationControllerForDismissedController(dismissed)
transitioning = IDTransitionController.new #<UIViewControllerAnimatedTransitioning>
        transitioning.isReversed= true
transitioning
        end

# def animationControllerForPresentedController(presented, presentingController: presenting, sourceController: source)
#   BEPModalTransitionAnimator.new
# end

# def animationControllerForDismissedController(dismissed)
#   BEPModalTransitionAnimator.new
# end


# return id <UIViewControllerInteractiveTransitioning>)
# def interactionControllerForPresentation(animator) # (id <UIViewControllerAnimatedTransitioning>)animator
#   p "requesting INTERACTIVE CONTROLLER"
#   # IDPercentDrivenInteractiveTransitionController *interactiveTransition = [[IDPercentDrivenInteractiveTransitionController alloc] init];
#   # return interactiveTransition;
#   return nil
# end

# def interactionControllerForDismissal(animator)
#   p "requseting DISMISSAL controller"
#   # IDPercentDrivenInteractiveTransitionController *interactiveTransition = [[IDPercentDrivenInteractiveTransitionController alloc] init];
#   # return interactiveTransition;
#   return nil
# end
end*/