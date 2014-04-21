//
// Created by Ian Dundas on 23/03/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "PMPlaceTableViewCell.h"
#import "JSSlidingViewController.h"


@implementation PMPlaceTableViewCell {

}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        /*Init Subviews*/
        // self.titleLabel= [[UILabel alloc] initWithFrame:CGRectMake (USAGECELLOUTSIDEPAD, 10, 280, 16)];

        [self configureControls];

        /*Add Subviews*/
        // [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)configureControls {

}
@end