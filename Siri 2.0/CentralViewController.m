//
//  CentralViewController.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/24/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "CentralViewController.h"

@interface CentralViewController ()

@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) MapViewController *mapViewController;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) HoundHandler *houndHandler;

@end

@implementation CentralViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
        self.mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:[NSBundle mainBundle]];
        self.mapViewController.delegate = self;
        
        self.houndHandler = [HoundHandler getInstance];
        self.houndHandler.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageViewController = [[UIPageViewController alloc] init];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.pageViewController.view.frame = self.view.frame;
    
    [self.pageViewController setViewControllers:@[self.mainViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if(viewController == self.mainViewController) {
        return self.mapViewController;
    }
    else if(viewController == self.mapViewController) {
        return self.mainViewController;
    }
    
    return nil;
}

- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(viewController == self.mainViewController) {
        return self.mapViewController;
    }
    else if(viewController == self.mapViewController) {
        return self.mainViewController;
    }
    
    return nil;
}

- (void) userWantsToReturnToMainViewController
{
    [self.pageViewController setViewControllers:@[self.mainViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
}



/****************************************************************
 *
 *              HoundHandler Delegate
 *
 *****************************************************************/

# pragma mark HoundHandler Delegate

- (void) noResponse
{
    NSLog(@"NO RESPONSE");
}

- (void) notUnderstandableResponse
{
    
    NSLog(@"NOT UNDERSTANDABLE");
}

- (void) commandNotSupported:(NSString*)commandKind transcription:(NSString*)transcription
{
    NSLog(@"NOT SUPPORTED");
}

//TODO: Pause main UI while (and after) we figure this out

- (void) wantsEventsNearThem
{
    NSLog(@"Wants event near them");
}

- (void) wantsEventsNearThem:(int)radius
{
    NSLog(@"Wants event near them: %d", radius);
    NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMe];
    [self.mapViewController setDataPoints:dataPoints];
    [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void) wantsEventsNearThemWithKeyWords:(NSArray*)keyWords
{
    NSLog(@"Wants event near them: %@", keyWords);
    NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMeWithKeyWords:keyWords];
    [self.mapViewController setDataPoints:dataPoints];
    [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void) wantsEventsNearThem:(int)radius keyWords:(NSArray*)keyWords
{
    NSLog(@"Wants event near them: %d\t%@", radius, keyWords);
    NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMe:radius keyWords:keyWords];
    [self.mapViewController setDataPoints:dataPoints];
    [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void) wantsNewsItemsNearThem
{
    NSLog(@"Wants News Items near them");
    NSMutableArray *dataPoints = [ParseCommunicator getNewsItemsNearMe];
    [self.mapViewController setDataPoints:dataPoints];
    [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void) wantsNewsItemsNearThem:(int)radius
{
    NSLog(@"Wants News Items near them: %d", radius);
    NSMutableArray *dataPoints = [ParseCommunicator getNewsItemsNearMe:radius];
    [self.mapViewController setDataPoints:dataPoints];
    [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void) wantsNewsItemsNearThemWithKeyWords:(NSArray*)keyWords
{
    NSLog(@"Wants News Items near them: %@", keyWords);
    NSMutableArray *dataPoints = [ParseCommunicator  getNewsItemsNearMeWithKeyWords:keyWords];
    [self.mapViewController setDataPoints:dataPoints];
    [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void) wantsNewsItemsNearThem:(int)radius keyWords:(NSArray*)keyWords
{
    NSLog(@"Wants News Items near them: %d\t%@", radius, keyWords);
    NSMutableArray *dataPoints = [ParseCommunicator getNewsItemsNearMe:radius keyWords:keyWords];
    [self.mapViewController setDataPoints:dataPoints];
    [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void) wantsCommunityService
{
    NSLog(@"COMMUNITY SERVICES");
    NSArray *keyWords = @[@"happy", @"happiness", @"community", @"service", @"help", @"old", @"homeless", @"kind", @"caring", @"red", @"cross", @"act", @"of", @"kindness", @"soup", @"kitch", @"food", @"drive"];
    NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMeWithKeyWords:keyWords];
    [dataPoints addObjectsFromArray:[ParseCommunicator getNewsItemsNearMeWithKeyWords:keyWords]];
    NSLog(@"LEAVING HERE WITH: %ld", dataPoints.count);
    [self.mapViewController setDataPoints:dataPoints];
    [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


@end