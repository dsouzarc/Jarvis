//
//  MainViewController.h
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <HoundSDK/HoundSDK.h>

#import "Constants.h"
#import "ParseCommunicator.h"
#import "HoundHandler.h"
#import "PQFBouncingBalls.h"
#import "VisualizerLineView.h"
#import "MapViewController.h"

@interface MainViewController : UIViewController

- (void) showLoadingAnimation;
- (void) hideLoadingAnimation;

- (void) showText:(NSString*)text;

@end