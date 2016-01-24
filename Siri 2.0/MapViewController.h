//
//  MapViewController.h
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/24/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

#import "PVAttractionAnnotation.h"
#import "ParseCommunicator.h"
#import "Constants.h"

@interface MapViewController : UIViewController <MKOverlay, MKMapViewDelegate, MKAnnotation>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil houndHandlerInformation:(NSDictionary*)houndHandlerInformation setOfPoints:(NSMutableArray*)setOfPoints;

@end