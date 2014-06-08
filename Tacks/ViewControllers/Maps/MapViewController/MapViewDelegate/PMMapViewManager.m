//
// Created by Ian Dundas on 08/06/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <ObjectiveSugar/NSArray+ObjectiveSugar.h>
#import "PMMapViewManager.h"
#import "NSMutableArray+extensions.h"
#import "PMAnnotation.h"
#import "Location.h"
#import "PMTemporaryAnnotation.h"


@interface PMMapViewManager ()
@property(nonatomic, strong) NSMutableArray *disabledAnnotationAnimations;
@property(nonatomic, strong) id<MKAnnotation> selectedAnnotation;

@property(nonatomic, weak) MKMapView *mapView;
@end

@implementation PMMapViewManager {}

-(instancetype)initWithMapView:(MKMapView*)mapView{
    if (self = [super init]) {

        // Configure MapView:
        _mapView= mapView;
        _mapView .delegate= self;
        _mapView .showsUserLocation= true;

        _disabledAnnotationAnimations = [NSMutableArray new];

        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                initWithTarget:self action:@selector(didLongTouchOnMap:)];
        longPressGestureRecognizer .minimumPressDuration= 0.55;
        [_mapView addGestureRecognizer: longPressGestureRecognizer];

        // TODO : also add observer to catch updated Location ,and remove/re-add annotation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationDidSaveNotification:) name:TKLocationDidSaveNotification object:nil];
    }
    return self;
}


#pragma mark Drawing on the Map:
- (void)plotLocations:(NSArray *)locations {
    [locations each:^(Location *location) {
        [self.mapView addAnnotation:location.annotation];
    }];
}

//todo refactor
-(void)createAndEditLocationAtCoordinate:(CLLocationCoordinate2D)coordinate {
    PMTemporaryAnnotation *annotation= [[PMTemporaryAnnotation alloc]init];
    annotation.coordinate= coordinate;
//    annotation.title= @"New place";

    [self.mapView addAnnotation:annotation];
}

-(void)editLocation:(Location *)location{
    [self editLocation:location fromPoint:CGPointMake (0, 0)];
}
-(void)editLocation:(Location *)location fromPoint:(CGPoint)point{
    [self.delegate showEditLocationViewController:location fromPoint:point];
}

#pragma mark Notifications:
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


#pragma mark MapView tricks
-(void)focusCoordinate:(CLLocationCoordinate2D)coordinate2D{
//    MKCoordinateSpan span= MKCoordinateSpanMake(0.01, 0.01);
//    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate2D, span);

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate2D, 500, 500);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void) focusMapOnCurrentLocation{
    if (self.userLocation)
        [self focusCoordinate:self.userLocation.location.coordinate];
//        [self.mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];
    else{
        // TODO: show notification that we don't have a user location.
        NSLog(@"User location not available");
    }
}

#pragma mark MKMapViewDelegate:
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Changed Region");
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
    NSLog(@"updated location");
    // also available at self.userLocation
}

#pragma mark Touch Events:
// Did select the *annotation* i.e. the point on the map
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [self setSelectedAnnotation:view.annotation];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"Did add annotation views: %@", views);

    [views each:^(MKAnnotationView *annotationView) {
        if ([annotationView.annotation isKindOfClass:MKUserLocation.class]){
            // We're adding to the map the Current Location pin point

            annotationView.rightCalloutAccessoryView = [UIButton
                    buttonWithType:UIButtonTypeContactAdd
            ];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"Did deselect annotation view: %@", view);
}

// Did select the popout bubble
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    if ([view.annotation isKindOfClass:PMAnnotation.class]){
        Location *location= ((PMAnnotation*)view.annotation).location;
        CGPoint windowPoint = [control convertPoint:control.bounds.origin toView:nil];

        [self editLocation:location fromPoint:windowPoint];
    }
    else{
        [self createAndEditLocationAtCoordinate:view.annotation.coordinate];

        NSLog(@"Can't edit location for Annotation of type %@", NSStringFromClass (PMTemporaryAnnotation.class));
    }
}

//- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers{
//}
//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay{
//}
-(void) didLongTouchOnMap:(UIGestureRecognizer *)sender{

    if (sender.state==UIGestureRecognizerStateBegan){
        CLLocationCoordinate2D coordinate= [self.mapView
                    convertPoint:[sender locationInView:self.mapView]
            toCoordinateFromView:self.mapView
        ];

        [self createAndEditLocationAtCoordinate:coordinate];
    }
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

#pragma mark User Location
- (MKUserLocation *)userLocation{
    return self.mapView.userLocation;
}

#pragma mark - Setters:
- (void)setSelectedAnnotation:(id <MKAnnotation>)selectedAnnotation {
    _selectedAnnotation = selectedAnnotation;

    if ([NSStringFromClass(selectedAnnotation.class) isEqualToString:@"MKModernUserLocationView"]){
        NSLog (@"Debug: did select current location");
    }

}

@end