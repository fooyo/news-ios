//
//  RootViewController.m
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#define PIXEL_PER_CHAR 10
#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic) int currentPageIndex;

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
    
    [self.view makeToastActivity];
    
    [[HttpClient sharedInstance] getCategoriesSuccess:^(id responseObject) {
        NSMutableArray *categoriesMutableArray = [[NSMutableArray alloc] init];
        for (NSString* category in [responseObject objectForKey:@"categories"]) {
            [categoriesMutableArray addObject: category];
        }
        self.categories = [NSArray arrayWithArray: categoriesMutableArray];
        //[self renderViewAfterCategoryRetrived];
        [self.view hideToastActivity];
    } failure:^(NSInteger statusCode, NSError *error) {
        [self.view makeToast:@"Sorry, network condition is not good. Please try agian later."
                    duration:5
                    position:@"bottom"];
        [self.view hideToastActivity];
    }];
    
    self.categories = @[@"Corgi", @"Shizi", @"Squirral"];
    [self renderViewAfterCategoryRetrived];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Render Views

- (void) renderViewAfterCategoryRetrived{
    // Render scrollView:
    
    CGFloat sumOfCategoryButtonWidths = 0;
    CGFloat buttonHeight = self.scrollView.frame.size.height;
    
    for (int i = 0; i < self.categories.count; i++) {
        NSString* category = [self.categories objectAtIndex: i];
        CGFloat buttonWidth = category.length * PIXEL_PER_CHAR;
        
        // Add button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(sumOfCategoryButtonWidths,
                                  0,
                                  buttonWidth,
                                  buttonHeight);
        [self.scrollView addSubview:button];
        button.tag = i;
        [button addTarget:self
                   action:@selector(categoryButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        
        sumOfCategoryButtonWidths += buttonWidth;
    }
    
    self.scrollView.contentSize =CGSizeMake(sumOfCategoryButtonWidths, buttonHeight);
    
    // Create UIPageViewController:
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    NewsTableViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0,
                                                    self.scrollView.frame.size.height,
                                                    [self getScreenWidth],
                                                    [self getScreenHeight] - self.scrollView.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((NewsTableViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((NewsTableViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }

    index++;
    
    if (index == [self.categories count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NewsTableViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.categories count] == 0) || (index >= [self.categories count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data:
    NewsTableViewController *NewsTableViewController = nil;
    if ([self isIPad]) {
        NSString* identifier = [NSString stringWithFormat:@"iPadTutorialPage%lu", (unsigned long)index+1];
        NewsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier: identifier];
    } else{
        NewsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsTableViewController"];
    }
    
    NewsTableViewController.delegate = self;
    NewsTableViewController.category = self.categories[index];
    NewsTableViewController.pageIndex = index;
    
    return NewsTableViewController;
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
    self.currentPageIndex = index;
}

#pragma mark - Button Click Events

- (void)categoryButtonClicked:(UIButton*)sender{
    if (sender.tag == self.currentPageIndex){
        return;
    }

    CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * sender.tag, 0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
    [self contentViewControllerDidSwitchToPageOfIndex:(int)sender.tag];
}

@end
