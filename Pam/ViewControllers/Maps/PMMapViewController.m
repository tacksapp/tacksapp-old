//
// Created by Ian Dundas on 27/01/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PMMapViewController.h"
#import "OCMapView.h"
#import "NSArray+ObjectiveSugar.h"
#import "Location.h"
#import "PMAppDelegate.h"
#import "PMTemporaryAnnotation.h"
#import "JSSlidingViewController.h"
#import "PMAnnotation.h"

@interface PMMapViewController ()  <MKMapViewDelegate>

@property(nonatomic, strong) UIButton *centreMapButton;
@property(nonatomic, strong) UIButton *revealMenuButton;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) id<MKAnnotation> selectedAnnotation;

@property(nonatomic, weak) MKUserLocation *userLocation; // todo: strong?

- (void)focusCoordinate:(CLLocationCoordinate2D)coordinate2D;

- (void)didTouchRevealMenu:(id)sender;
- (void)didLongTouchOnMap:(id)sender;
@end



@implementation PMMapViewController
@synthesize revealMenuButton = _revealMenuButton;
@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self mapView]];
    [self.view addSubview:[self revealMenuButton]];
    [self.view addSubview:[self centreMapButton]];

    NSArray *locations = [Location all];
    [self plotLocations:locations];

}

- (void)plotLocations:(NSArray *)locations {
    [locations each:^(Location *location) {
        [self.mapView addAnnotation:location.annotation];
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
    NSLog(@"Selecting annotation: %@", location.annotation, location.annotation.description);

    [self.mapView.annotations each:^(id object) {
        NSLog(@"Existing annotation: %@", object);
    }];

    [self focusLocation:location];
    [self.mapView selectAnnotation:location.annotation animated:YES];
}

#pragma mark MKMapView Delegates:
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [self setSelectedAnnotation:view.annotation];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userLocation= userLocation;
}
- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation{
    // if it's a cluster

    MKPinAnnotationView *pinView = nil;

    static NSString *defaultPinID = @"identifier";
    pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];

    if ( pinView == nil )
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];

        pinView.enabled = YES;
        pinView.canShowCallout = YES;

//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//
//        //Accessoryview for the annotation view in ios.
//        pinView.rightCalloutAccessoryView = btn;
    }
    else
    {
        pinView.annotation = annotation;
    }


    if ([annotation isKindOfClass:[OCAnnotation class]]) {
        pinView.pinColor = MKPinAnnotationColorGreen;  //or Green or Purple

        // create your custom cluster annotationView here!
        NSLog(@"Is a cluster containing: ");
        [((OCAnnotation *) annotation).annotationsInCluster each:^(id object) {
            NSLog(@" -> %@", object);
        }];

    }
    else{
        pinView.pinColor = MKPinAnnotationColorRed;  //or Green or Purple
    }
//    // If it's a single annotation
//    else if([annotation isKindOfClass:[Your_Annotation class]]){


//        return pinView;
//    }
//    return Your_annotationView;
    return pinView;
}

#pragma mark Actions:
-(void)didTouchRevealMenu:(id)sender{
    [[AppDelegate slidingViewController] openSlider:YES completion:^{
//        [AppDelegate slidingViewController].locked=YES;
    }];
}
-(void)didTouchCentreMap:(id)sender{
    if (self.userLocation)
        [self.mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];
    else{
        // TODO: show notification that we don't have a user location.
        NSLog(@"User location not available");
    }
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
        _mapView= [[MKMapView alloc] initWithFrame:self.view.bounds]; // MBXMapView.alloc.initWithFrame(CGRectZero, mapID: "iandundas.map-2sgvzixp")
//        _mapView= [[OCMapView alloc] initWithFrame:self.view.bounds]; // MBXMapView.alloc.initWithFrame(CGRectZero, mapID: "iandundas.map-2sgvzixp")
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

- (UIView *)revealMenuButton {
    if(!_revealMenuButton){
        float screenHeight=UIScreen.mainScreen.bounds.size.height;

        _revealMenuButton = UIButton.new;
        _revealMenuButton.frame= CGRectMake (0, screenHeight-100, 16, 50);
        _revealMenuButton.backgroundColor= [UIColor redColor];
        [_revealMenuButton addTarget:self action:@selector(didTouchRevealMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _revealMenuButton;
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
        [_centreMapButton addTarget:self action:@selector(didTouchCentreMap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centreMapButton;
}
@end
