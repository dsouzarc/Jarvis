//
//  CentralViewController.h
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/24/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HoundSDK/HoundSDK.h>

#import "MainViewController.h"
#import "MapViewController.h"
#import "Constants.h"
#import "HoundHandler.h"
#import "ParseCommunicator.h"

@interface CentralViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, MapViewControllerDelegate, HoundHandlerDelegate>

@end
