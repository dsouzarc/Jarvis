//
//  MapViewController.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/24/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSDictionary *houndHandlerInformation;
@property (strong, nonatomic) NSMutableArray *parseData;

@end

@implementation MapViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil houndHandlerInformation:(NSDictionary *)houndHandlerInformation setOfPoints:(NSMutableArray *)setOfPoints
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.houndHandlerInformation = houndHandlerInformation;
        self.parseData = setOfPoints;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.mapType = MKMapTypeHybrid;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake([[Constants getInstance] getMyLocation].coordinate, span);
    self.mapView.region = region;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        NSMutableArray *pointsToDisplay = [ParseCommunicator getNewsItemsNearMe];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            for(NSDictionary *pointToDisplay in pointsToDisplay) {
                
                PVAttractionAnnotation *annotation = [[PVAttractionAnnotation alloc] init];
                
                PFGeoPoint *geoPoint = pointToDisplay[@"location_coordinates"];
                CGPoint point = CGPointMake(geoPoint.latitude, geoPoint.longitude);
                annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
                
                annotation.title = pointToDisplay[@"title"];
                annotation.subtitle = pointToDisplay[@"business_name"];
                
                [self.mapView addAnnotation:annotation];
            }
        });
    });
    
    /*NSString *thePath = [[NSBundle mainBundle] pathForResource:@"EntranceToGoliathRoute" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
    NSInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
    }
    
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    [self.mapView addOverlay:myPolyline];*/
}

#pragma mark - Add methods


@end