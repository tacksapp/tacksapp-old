//
// Created by Ian Dundas on 27/01/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PMMainMapViewController.h"
#import "OCMapView.h"
#import "NSArray+ObjectiveSugar.h"
#import "Location.h"
#import "PMAppDelegate.h"
#import "PMTemporaryAnnotation.h"
#import "JSSlidingViewController.h"

@interface PMMainMapViewController()  <MKMapViewDelegate>

@property (nonatomic, strong) UIButton *swipeableButton;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) id<MKAnnotation> selectedAnnotation;

- (void)focusCoordinate:(CLLocationCoordinate2D)coordinate2D;

- (void)revealMenu:(id)sender;
- (void)closeMenu:(id)sender;

- (void)didLongTouchOnMap:(id)sender;
@end



@implementation PMMainMapViewController
@synthesize swipeableButton = _swipeableButton;
@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self mapView]];
    [self.view addSubview:[self swipeableButton]];

    NSArray *points= [Location all];
    [self plotPoints:points];

}

- (void) plotPoints:(NSArray *)points {
    [points each:^(Location *location) {
        [self.mapView addAnnotation:location];
    }];
}

#pragma mark MapView tricks
-(void)focusCoordinate:(CLLocationCoordinate2D)coordinate2D{
//    MKCoordinateSpan span= MKCoordinateSpanMake(0.01, 0.01);
//    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate2D, span);

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate2D, 500, 500);
    [self.mapView setRegion:viewRegion animated:YES];
}

#pragma mark MapDisplayProtocol Delegate methods:
- (void)focusLocation:(Location *)location {
    NSLog(@"Focusing: %@", location);
    [self focusCoordinate:location.coordinate];
}
- (void)selectLocation:(Location *)location {
    [self.mapView selectAnnotation:location animated:YES];
    [self focusLocation:location];
}

#pragma mark MKMapView Delegates:
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [self setSelectedAnnotation:view.annotation];
}

#pragma mark Actions:
-(void) revealMenu:(id)sender{
    [[AppDelegate slidingViewController] openSlider:YES completion:^{}];
}
-(void) closeMenu:(id)sender{
    [[AppDelegate slidingViewController] closeSlider:YES completion:^{}];
}

-(void) didLongTouchOnMap:(UITouch *)sender{

    CLLocationCoordinate2D location= [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];

    PMTemporaryAnnotation *annotation= [[PMTemporaryAnnotation alloc]init];
    annotation.coordinate= location;
    annotation.title= @"New place";

    [self.mapView addAnnotation:annotation];
}

#pragma mark Getters:
- (OCMapView *)mapView {
    if (!_mapView){
        _mapView= [[OCMapView alloc] initWithFrame:self.view.bounds]; // MBXMapView.alloc.initWithFrame(CGRectZero, mapID: "iandundas.map-2sgvzixp")
        _mapView .delegate= self;
        _mapView .mapType= MKMapTypeStandard;
        _mapView .showsUserLocation= true;

        // Add touch events:
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                initWithTarget:self action:@selector(didLongTouchOnMap:)];
        longPressGestureRecognizer .minimumPressDuration= 1.0;
        [_mapView addGestureRecognizer: longPressGestureRecognizer];

    }
    return _mapView;
}

- (UIView *)swipeableButton{
    if(!_swipeableButton){
        float screenHeight=UIScreen.mainScreen.bounds.size.height;

        _swipeableButton= UIButton.new;
        _swipeableButton.frame= CGRectMake (0, screenHeight-100, 16, 50);
        _swipeableButton.backgroundColor= [UIColor redColor];
        [_swipeableButton addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swipeableButton;

}
@end
