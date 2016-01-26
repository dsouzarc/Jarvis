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
    [self.mainViewController showText:@"No response"];
}

- (void) notUnderstandableResponse
{
    [self.mainViewController showText:@"Command not understood"];
}

- (void) commandNotSupported:(NSString*)commandKind transcription:(NSString*)transcription
{
    NSLog(@"NOT SUPPORTED");
    [self.mainViewController showText:@"Command not supported"];
}

//TODO: Pause main UI while (and after) we figure this out

- (void) wantsEventsNearThem
{
    NSLog(@"Wants event near them");
    [self.mainViewController showText:@"Events near me"];
    [self.mainViewController showLoadingAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMe];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) wantsEventsNearThem:(int)radius
{
    NSLog(@"Wants event near them: %d", radius);
    [self.mainViewController showText:[NSString stringWithFormat:@"Events near me: %d miles", radius]];
    [self.mainViewController showLoadingAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMe:radius];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) wantsEventsNearThemWithKeyWords:(NSArray*)keyWords
{
    NSLog(@"Wants event near them: %@", keyWords);
    [self.mainViewController showText:[NSString stringWithFormat:@"Events near me: %@", keyWords]];
    [self.mainViewController showLoadingAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMeWithKeyWords:keyWords];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) wantsEventsNearThem:(int)radius keyWords:(NSArray*)keyWords
{
    NSLog(@"Wants event near them: %d\t%@", radius, keyWords);
    [self.mainViewController showText:[NSString stringWithFormat:@"Events near me: %d miles\t%@", radius, keyWords]];
    [self.mainViewController showLoadingAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMe:radius keyWords:keyWords];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) wantsNewsItemsNearThem
{
    NSLog(@"Wants News Items near them");
    [self.mainViewController showText:@"News items near them"];
    [self.mainViewController showLoadingAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *dataPoints = [ParseCommunicator getNewsItemsNearMe];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) wantsNewsItemsNearThem:(int)radius
{
    NSLog(@"Wants News Items near them: %d", radius);
    [self.mainViewController showText:[NSString stringWithFormat:@"News Items near me: %d miles", radius]];
    [self.mainViewController showLoadingAnimation];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *dataPoints = [ParseCommunicator getNewsItemsNearMe:radius];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) wantsNewsItemsNearThemWithKeyWords:(NSArray*)keyWords
{
    [self.mainViewController showText:[NSString stringWithFormat:@"News items near me: %@", keyWords]];
    [self.mainViewController showLoadingAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *dataPoints = [ParseCommunicator getNewsItemsNearMeWithKeyWords:keyWords];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) wantsNewsItemsNearThem:(int)radius keyWords:(NSArray*)keyWords
{
    NSLog(@"Wants News Items near them: %d\t%@", radius, keyWords);
    
    [self.mainViewController showText:[NSString stringWithFormat:@"News items near me: %@\t%d", keyWords, radius]];
    
    [self.mainViewController showLoadingAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *dataPoints = [ParseCommunicator getNewsItemsNearMe:radius keyWords:keyWords];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) wantsCommunityService
{
    NSLog(@"COMMUNITY SERVICES");
    [self.mainViewController showText:@"Community service"];
    [self.mainViewController showLoadingAnimation];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSArray *keyWords = @[@"happy", @"happiness", @"community", @"service", @"help", @"old", @"homeless", @"kind", @"caring", @"red", @"cross", @"act", @"of", @"kindness", @"soup", @"kitch", @"food", @"drive"];
       NSMutableArray *dataPoints = [ParseCommunicator getEventsNearMeWithKeyWords:keyWords];
        [dataPoints addObjectsFromArray:[ParseCommunicator getKindness]];
        
        NSLog(@"WE GOT THE DATA");
        
        
        //[dataPoints addObjectsFromArray:[ParseCommunicator getNewsItemsNearMeWithKeyWords:keyWords]];
        
        //[dataPoints addObjectsFromArray:[ParseCommunicator getFamily]];
        //[dataPoints addObjectsFromArray:[ParseCommunicator getHousing]];
        [self showMapViewWithData:dataPoints];
    });
}

- (void) showMapViewWithData:(NSMutableArray*)dataPoints
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.mapViewController setDataPoints:dataPoints];
        [self.pageViewController setViewControllers:@[self.mapViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self.mainViewController hideLoadingAnimation];
    });
}

@end