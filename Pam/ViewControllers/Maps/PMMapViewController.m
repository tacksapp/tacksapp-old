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
#import "IDTransitioningDelegate.h"
#import "DetailViewController.h"
#import "NSMutableArray+ObjectiveSugar.h"
#import "NSMutableArray+extensions.h"

@interface PMMapViewController ()  <MKMapViewDelegate>

@property(nonatomic, strong) UIButton *centreMapButton;
@property(nonatomic, strong) UIButton *revealMenuButton;
@property(nonatomic, strong) id<MKAnnotation> selectedAnnotation;

@property(nonatomic, strong) MKUserLocation *userLocation; // todo: weak?
@property(nonatomic, strong) NSMutableArray *disabledAnnotationAnimations;

- (void)didSelectAnnotationCallout:(id)sender;

- (void)showEditLocationViewController:(Location *)location fromPoint:(CGPoint)animateFromPoint;

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

    self.disabledAnnotationAnimations = [NSMutableArray new];
    NSArray *locations = [Location all];
    [self plotLocations:locations];

    //    TODO : add observer to catch updated Location ,and remove/re-add annotation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationDidSaveNotification:) name:TKLocationDidSaveNotification object:nil];

}

- (void)plotLocations:(NSArray *)locations {
    [locations each:^(Location *location) {
        [self.mapView addAnnotation:location.annotation];
    }];
}

- (void) receiveLocationDidSaveNotification:(NSNotification*)notification{
    Location *location= notification.object;
    [self.mapView removeAnnotation:location.annotation];

    [self.disabledAnnotationAnimations addObject:location.annotation];
    [self.mapView addAnnotation: location.annotation];

//    [self.mapView performSelector:@selector(selectAnnotation:) withObject:location.annotation afterDelay:0.5];
    [self performSelector:@selector(selectLocation:) withObject:location afterDelay:0.2];
//    [self.mapView.selectedAnnotations arrayByAddingObject:location.annotation];
//    [self setSelectedAnnotation:location.annotation];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Changed Region");
}

#pragma mark Transitions
-(void)showEditLocationViewController:(Location *)location fromPoint:(CGPoint)animateFromPoint{

    IDTransitioningDelegate *transitioningDelegate= [[IDTransitioningDelegate alloc]init];

    UIButton *closeModalButton= [[UIButton alloc] initWithFrame:self.view.bounds];
    [closeModalButton addTarget:self action:@selector(hideEditLocationViewController:) forControlEvents:UIControlEventTouchUpInside];
    [closeModalButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:closeModalButton];

    DetailViewController *detailViewController= [[DetailViewController alloc] initWithLocation:location];
    detailViewController.transitioningDelegate= transitioningDelegate;
    detailViewController.modalPresentationStyle= UIModalPresentationCustom;
    detailViewController.modalInPopover= NO;
    detailViewController.animateFromPoint= animateFromPoint;

    NSLog (@"animate from point: %@", NSStringFromCGPoint (animateFromPoint));

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
        pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        // TODO: can use prepareForReuse on MKAnnotationView to remove GestureRecognisers.
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectAnnotationCallout:)];
//        [pinAnnotationView addGestureRecognizer:tapGestureRecognizer];

//        if ([annotation isKindOfClass:PMTemporaryAnnotation.class]){
//            UITapGestureRecognizer *tapGesture= [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(didTouchOnCallout:)];
//            [pinAnnotationView addGestureRecognizer: tapGesture];
//        }

    }
    else{
        pinAnnotationView.annotation = annotation;
    }
    pinAnnotationView.animatesDrop= ![self.disabledAnnotationAnimations removeObjectAndConfirmChange:annotation];
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;  //or Green or Purple

    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView
        didChangeDragState:(MKAnnotationViewDragState)newState
        fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding){
        if ([annotationView.annotation isKindOfClass:PMAnnotation.class]){
            [((PMAnnotation *)annotationView.annotation).location save];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userLocation= userLocation;
}
// Did select the *annotation* i.e. the point on the map
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [self setSelectedAnnotation:view.annotation];
}
// Did select the popout bubble
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    if ([view.annotation isKindOfClass:PMAnnotation.class]){
        Location *location= ((PMAnnotation*)view.annotation).location;

        CGPoint windowPoint = [control convertPoint:control.bounds.origin toView:nil];
        [self showEditLocationViewController:location fromPoint:windowPoint];
    }
    else{
        NSLog(@"Can't edit location for Annotation of type %@", NSStringFromClass (PMTemporaryAnnotation.class));
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

//todo move
-(void)createNewEmptyLocationAtCoordinate:(CLLocationCoordinate2D)coordinate {
    PMTemporaryAnnotation *annotation= [[PMTemporaryAnnotation alloc]init];
    annotation.coordinate= coordinate;
//    annotation.title= @"New place";

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
