//
//  RootViewController.m
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[HttpClient sharedInstance] getCategoriesSuccess:^(id responseObject) {
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
    
    // Create Data Model:
    
    if ([self isIPhone4]) {
        self.pageImages = @[@"1_ip4.jpg",
                            @"2_ip4.jpg",
                            @"3_ip4.jpg",
                            @"3_ip4.jpg"];
    }
    else if ([self isIPhone5]){
        self.pageImages = @[@"1_ip5.jpg",
                            @"2_ip5.jpg",
                            @"3_ip5.jpg",
                            @"3_ip5.jpg"];
    }
    else if ([self isIPad]){
        self.pageImages = @[@"random nonsense placeholder",
                            @"self.pageImages.count should match the actual number of pages",
                            @"each page corresponds to a different viewController",
                            @"Four viewControllers: iPadTutorialPage1-4"];
    } else{
        NSLog(@"Error at tutorial page: Unknown Screen size");
    }
    
    self.pageControl.numberOfPages = [self.pageImages count];

    // Create UIPageViewController:
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0,
                                                    0,
                                                    [self getScreenWidth],
                                                    [self getScreenHeight]);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // Bring the two buttons to the front, hide the beginStudyButton
    [self.view bringSubviewToFront:self.registerButton];
    [self.view bringSubviewToFront:self.signInButton];
    [self.view bringSubviewToFront:self.pageControl];
    [self.pageControl setCurrentPage:0];
}

- (void) orientationChanged:(NSNotification *)note
{
    self.pageViewController.view.frame = CGRectMake(0,
                                                    0,
                                                    [self getScreenWidth],
                                                    [self getScreenHeight]);
    
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            break;
        default:
            break;
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    [self.view bringSubviewToFront:self.pageControl];
    [self.pageControl setCurrentPage:index];
    
    index++;
    
    if (index == [self.pageImages count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data:
    PageContentViewController *pageContentViewController = nil;
    if ([self isIPad]) {
        NSString* identifier = [NSString stringWithFormat:@"iPadTutorialPage%lu", (unsigned long)index+1];
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier: identifier];
    } else{
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    }
    
    pageContentViewController.delegate = self;
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
        
    if (index == [self.pageImages count] - 1){
        pageContentViewController.isLastPage = YES;
    } else{
        pageContentViewController.isLastPage = NO;
    }
    
    return pageContentViewController;
}

// Total number of pages
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
    //return [self.pageTitles count];
}

// Default page
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Delegate Methods

- (void) contentViewControllerDidSwitchToPageOfIndex:(int)index{
    [self.view bringSubviewToFront:self.pageControl];
    [self.pageControl setCurrentPage:index];
}

// Button Events
- (IBAction)registerButtonClicked:(id)sender {
    
}

- (IBAction)signInButtonClicked:(id)sender {
    
}

// Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SegueFromTutorialToRegister"]) {
        UINavigationController* navigationViewController = (UINavigationController*)[segue destinationViewController];
        
        RegisterViewController* registerViewController = [navigationViewController.viewControllers objectAtIndex:0];
        
        registerViewController.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"SegueFromTutorialToLogin"]){
        UINavigationController* navigationViewController = (UINavigationController*)[segue destinationViewController];
        
        LoginViewController* loginViewController = [navigationViewController.viewControllers objectAtIndex:0];
        
        loginViewController.delegate = self;
    }
}

// Modal Segue Delegate
- (void)childPageDismissed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)beginStudyButtonPressed{
    // Button will trigger the segue itself. Do nothing here.
}

@end
