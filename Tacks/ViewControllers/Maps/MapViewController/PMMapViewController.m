//
// Created by Ian Dundas on 27/01/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PMMapViewController.h"
#import "Location.h"
#import "PMAppDelegate.h"
#import "JSSlidingViewController.h"
#import "IDTransitioningDelegate.h"
#import "DetailViewController.h"
#import "Place.h"

@interface PMMapViewController ()
@property(nonatomic, strong) PMMapViewManager *manager;
//@property(nonatomic, strong) DetailViewController *detailViewController;
@property(nonatomic, strong) IDTransitioningDelegate *detailViewTransitioningDelegate;

@property(nonatomic, strong) UIButton *centreMapButton;
@property(nonatomic, strong) UIButton *revealMenuButton;

- (void)didTouchRevealMenuButton:(id)sender;
@end



@implementation PMMapViewController
@synthesize revealMenuButton = _revealMenuButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self mapView]];
    [self.view addSubview:[self revealMenuButton]];
    [self.view addSubview:[self centreMapButton]];

    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]
            initWithTitle:@"Focus"
                    style:UIBarButtonItemStylePlain
                   target:self.manager
                   action:@selector (focusAllMapAnnotations)];
    [self filterByPlace:nil];
}

- (void) filterByPlace:(Place *)place{
    if (place){
        self.title= place.title;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.title= @"All";
    }
    [self.manager setFilterPlace:place];
    [self.manager plotLocations];
    [self.manager focusAllMapAnnotations];
}

#pragma mark Transitions

-(void)showEditLocationViewController:(Location *)location fromPoint:(CGPoint)animateFromPoint{

    UIButton *closeModalButton= [[UIButton alloc] initWithFrame:self.view.bounds];
    [closeModalButton addTarget:self action:@selector(hideEditLocationViewController:) forControlEvents:UIControlEventTouchUpInside];
    [closeModalButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:closeModalButton];

    DetailViewController *detailViewController = [[DetailViewController alloc] initWithLocation:location];
    detailViewController.transitioningDelegate= self.detailViewTransitioningDelegate;
    detailViewController.modalPresentationStyle= UIModalPresentationCustom;
    detailViewController.modalInPopover= NO;
    detailViewController.animateFromPoint= animateFromPoint;

    NSLog (@"Edit Location: animate from point: %@", NSStringFromCGPoint (animateFromPoint));
    [self presentViewController:detailViewController animated:YES completion:^{

    }];
}

- (void)hideEditLocationViewController:(id)sender {
    if ([sender isKindOfClass:UIButton.class])
        [sender removeFromSuperview];

    [self dismissViewControllerAnimated:YES completion:^{
        // Removed edit modal from view
    }];
}




#pragma mark MapDisplayProtocol Delegate methods:
- (void)focusLocation:(Location *)location {
    [self.manager focusLocation:location];
}
- (void)focusLocations:(NSArray*)locations {
    [self.manager focusLocations:locations];
}

- (void)selectLocation:(Location *)location {
    [self.manager selectLocation:location];
}
- (MKUserLocation *)userLocation {
    return self.manager.userLocation;
}

#pragma mark Touch Actions:
-(void)didTouchRevealMenuButton:(id)sender{
    [[AppDelegate slidingViewController] openSlider:YES completion:^{
//        [AppDelegate slidingViewController].locked=YES;
    }];
}
-(void)didTouchCentreMapButton:(id)sender{
    [self.manager focusMapOnCurrentLocation];
}


#pragma mark Accessors:
- (MKMapView *)mapView {
    if (!_mapView){
        _mapView= [[MKMapView alloc] initWithFrame:self.view.bounds];
        // _mapView= [[OCMapView alloc] initWithFrame:self.view.bounds];
        // _mapView= MBXMapView.alloc.initWithFrame(CGRectZero, mapID: "iandundas.map-2sgvzixp")

        _mapView .mapType= MKMapTypeStandard;
    }
    return _mapView;
}

- (PMMapViewManager *)manager {
    if (!_manager){
        _manager = [[PMMapViewManager alloc] initWithMapView:self.mapView];
        _manager.delegate= self;
    }
    return _manager;
}

- (UIView *)revealMenuButton {
    if(!_revealMenuButton){
        float screenHeight=UIScreen.mainScreen.bounds.size.height;

        _revealMenuButton = UIButton.new;
        _revealMenuButton.frame= CGRectMake (0, screenHeight-100, 16, 50);
        _revealMenuButton.backgroundColor= [UIColor redColor];
        [_revealMenuButton addTarget:self action:@selector (didTouchRevealMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _revealMenuButton;
}

- (IDTransitioningDelegate *)detailViewTransitioningDelegate {
    if(!_detailViewTransitioningDelegate){
        _detailViewTransitioningDelegate = [[IDTransitioningDelegate alloc]init];
    }
    return _detailViewTransitioningDelegate;
}

- (UIButton *)centreMapButton{
    if (!_centreMapButton){
        _centreMapButton= [UIButton buttonWithType:UIButtonTypeCustom];

        float buttonWidth=35.0f;
        float buttonHeight=35.0f;
        float buttonPadding=15.0f;

        _centreMapButton.frame= CGRectMake (self.view.bounds.size.width, self.view.bounds.size.height, buttonWidth, buttonHeight);
        _centreMapButton.frame= CGRectOffset (_centreMapButton.frame, -buttonWidth-buttonPadding, -buttonHeight-buttonPadding);
        _centreMapButton.backgroundColor= UIColor.redColor;
        [_centreMapButton addTarget:self action:@selector (didTouchCentreMapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centreMapButton;
}
@end
