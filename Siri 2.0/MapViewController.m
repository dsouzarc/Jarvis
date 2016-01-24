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
    

    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake([[Constants getInstance] getMyLocation].coordinate, span);
    self.mapView.region = region;
}

#pragma mark - Add methods


@end