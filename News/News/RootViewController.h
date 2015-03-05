//
//  RootViewController.h
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import "SwitchedToPageOfIndexDelegate.h"
#import "UIViewController+ScreenSize.h"
#import "NewsTableViewController.h"
#import <UIKit/UIKit.h>
#import "HttpClient.h"

@interface RootViewController : UIViewController <UIPageViewControllerDataSource, SwitchedToPageDelegate>

@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
