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
@property(nonatomic, strong) id<MKAnnotation> selectedAnnotation;

@property(nonatomic, strong) MKUserLocation *userLocation; // todo: weak?
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
    [self focusCoordinate:location.coordinate];
}
- (void)focusLocations:(NSArray*)locations {
    [self.mapView showAnnotations:[locations map:^id (Location *location) {
        return location.annotation;
    }] animated:YES];
}
- (void)selectLocation:(Location *)location {
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

    static NSString *defaultPinID = @"identifier";

    if ([annotation isKindOfClass:MKUserLocation.class])
        return nil; // keep the blue dot.

    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinAnnotationView == nil){
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        pinAnnotationView.enabled = YES;
        pinAnnotationView.canShowCallout = YES;
        pinAnnotationView.draggable= YES;
        pinAnnotationView.animatesDrop= YES;

//        if ([annotation isKindOfClass:PMTemporaryAnnotation.class]){
//            UITapGestureRecognizer *tapGesture= [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(didTouchOnCallout:)];
//            [pinAnnotationView addGestureRecognizer: tapGesture];
//        }

//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        //Accessoryview for the annotation view in ios.
//        pinAnnotationView.rightCalloutAccessoryView = btn;
    }
    else{
        pinAnnotationView.annotation = annotation;
    }

    pinAnnotationView.pinColor = MKPinAnnotationColorRed;  //or Green or Purple
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView
        didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding){
        if ([annotationView.annotation isKindOfClass:PMAnnotation.class]){
            [((PMAnnotation *)annotationView.annotation).location save];
        }
    }
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
-(void) didLongTouchOnMap:(UIGestureRecognizer *)sender{

    if (sender.state==UIGestureRecognizerStateBegan){
        CLLocationCoordinate2D coordinate= [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        [self createNewEmptyLocationAtCoordinate:coordinate];
    }
}
-(void) didTouchOnCalloutWithAnnotation:(id<MKAnnotation>)annotation{

}

//todo move
-(void)createNewEmptyLocationAtCoordinate:(CLLocationCoordinate2D)coordinate {
    PMTemporaryAnnotation *annotation= [[PMTemporaryAnnotation alloc]init];
    annotation.coordinate= coordinate;
    annotation.title= @"New place";

    [self.mapView addAnnotation:annotation];
}

#pragma mark Getters:
- (MKMapView *)mapView {
    if (!_mapView){
        _mapView= [[MKMapView alloc] initWithFrame:self.view.bounds]; // MBXMapView.alloc.initWithFrame(CGRectZero, mapID: "iandundas.map-2sgvzixp")
//        _mapView= [[OCMapView alloc] initWithFrame:self.view.bounds]; // MBXMapView.alloc.initWithFrame(CGRectZero, mapID: "iandundas.map-2sgvzixp")
        _mapView .delegate= self;
        _mapView .mapType= MKMapTypeStandard;
        _mapView .showsUserLocation= true;

        // Add touch events:
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                initWithTarget:self action:@selector(didLongTouchOnMap:)];
        longPressGestureRecognizer .minimumPressDuration= 0.55;
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
