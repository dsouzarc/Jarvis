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

@end

@implementation CentralViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
        self.mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:[NSBundle mainBundle]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageViewController = [[UIPageViewController alloc] init];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.pageViewController.view.frame = self.view.bounds;
    
    [self.pageViewController setViewControllers:@[self.mainViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:[self.pageViewController view]];
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

@end