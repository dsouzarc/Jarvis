//
//  MapViewController.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/24/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet UIButton *houndifyMicrophoneButton;


@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSDictionary *houndHandlerInformation;
@property (strong, nonatomic) NSMutableArray *parseData;
@property (strong, nonatomic) NSMutableArray *annotations;

@end

@implementation MapViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil houndHandlerInformation:(NSDictionary *)houndHandlerInformation setOfPoints:(NSMutableArray *)setOfPoints
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.houndHandlerInformation = houndHandlerInformation;
        self.parseData = setOfPoints;
        self.annotations = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.houndHandlerInformation = [[NSDictionary alloc] init];
        self.parseData = [[NSMutableArray alloc] init];
        self.annotations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setDataPoints:(NSMutableArray *)dataPoints
{
    if(self.annotations.count > 0) {
        for(PVAttractionAnnotation *annotation in self.annotations) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    self.annotations = [[NSMutableArray alloc] init];
    self.parseData = dataPoints;
    for(NSDictionary *pointToDisplay in dataPoints) {
        NSLog(@"ADDING POINT: ");
        PVAttractionAnnotation *annotation = [[PVAttractionAnnotation alloc] init];
        
        PFGeoPoint *geoPoint = pointToDisplay[@"location_coordinates"];
        CGPoint point = CGPointMake(geoPoint.latitude, geoPoint.longitude);
        annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        
        annotation.title = pointToDisplay[@"title"];
        annotation.subtitle = pointToDisplay[@"business_name"];
        
        [self.mapView addAnnotation:annotation];
        [self.annotations addObject:annotation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houndifyMicrophoneButton.clipsToBounds = YES;
    self.houndifyMicrophoneButton.layer.cornerRadius = self.houndifyMicrophoneButton.frame.size.width / 2.0;
    
    self.mapView.mapType = MKMapTypeHybrid;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake([[Constants getInstance] getMyLocation].coordinate, span);
    self.mapView.region = region;
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        NSMutableArray *pointsToDisplay = [ParseCommunicator getNewsItemsNearMe];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {

        });
    });*/
    
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.houndifyMicrophoneButton.alpha = 0.0f;
    self.houndifyMicrophoneButton.center = CGPointMake(-100.0, self.view.center.y);
    
    /*[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateState) name:HoundVoiceSearchStateChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(audioLevel:) name:HoundVoiceSearchAudioLevelNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hotPhrase) name:HoundVoiceSearchHotPhraseNotification object:nil];
    
    [self updateState];*/
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Translates from bottom to middle of screen
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^(void) {
                         self.houndifyMicrophoneButton.alpha = 1.0f;
                         self.houndifyMicrophoneButton.frame = CGRectMake(0, 0, self.houndifyMicrophoneButton.frame.size.width * 2.0, self.houndifyMicrophoneButton.frame.size.height * 2.0);
                         self.houndifyMicrophoneButton.center = self.view.center;
                     }
                     completion:^(BOOL completed) {
                         //Translattes back down to appropriate location
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options:UIViewAnimationOptionTransitionNone
                                          animations:^(void) {
                                              self.houndifyMicrophoneButton.alpha = 1.5f;
                                              self.houndifyMicrophoneButton.frame = CGRectMake(self.view.center.x, 432, 80, 80); //0, 0, self.houndifyMicrophoneButton.frame.size.width * (2/3), self.houndifyMicrophoneButton.frame.size.height * (2/3));
                                              self.houndifyMicrophoneButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (40 + 80));
                                          }
                                          completion:^(BOOL completed) {
                                          }
                          ];
                     }
     ];
    
    //All while spinning
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 30 * 2.0 ];
    rotationAnimation.duration = 1.1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.timeOffset = 0.0;
    rotationAnimation.repeatCount = 1.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.houndifyMicrophoneButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    self.houndifyMicrophoneButton.layer.shadowRadius = 7.0f;
    self.houndifyMicrophoneButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.houndifyMicrophoneButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.houndifyMicrophoneButton.layer.shadowOpacity = 0.5f;
    self.houndifyMicrophoneButton.layer.masksToBounds = NO;
    
    [UIView animateWithDuration:1.0f delay:0
                        options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAutoreverse
                     animations:^{
                         [UIView setAnimationRepeatCount:INT_MAX];
                         self.houndifyMicrophoneButton.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     }
                     completion:^(BOOL finished) {
                         self.houndifyMicrophoneButton.layer.shadowRadius = 0.0f;
                         self.houndifyMicrophoneButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         self.houndifyMicrophoneButton.frame = CGRectMake(self.view.center.x, 432, 80, 80); //0, 0, self.houndifyMicrophoneButton.frame.size.width * (2/3), self.houndifyMicrophoneButton.frame.size.height * (2/3));
                         self.houndifyMicrophoneButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (40 + 80));
                         NSLog(@"DECREASING: %@", NSStringFromCGRect(self.houndifyMicrophoneButton.frame));
                     }
     ];
    
}

- (IBAction)longPressMicrophone:(id)sender {
    [self.delegate userWantsToReturnToMainViewController];
}

@end