//
// Created by Ian Dundas on 23/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "PMMenuTableViewCell.h"
#import "JSSlidingViewController.h"


@implementation PMMenuTableViewCell {

}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureControls];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width-= JSSlidingViewControllerDefaultVisibleFrontPortionWhenOpen;
    frame.size.width-= 15; // padding that's also on the left by default
    [super setFrame:frame];
}

- (void)configureControls {

}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self configureControls];
}

@end