//
//  NewsDetailViewController.h
//  News
//
//  Created by Shaohuan Li on 5/3/15.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "HttpClient.h"
#import "UIView+Toast.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+ScreenSize.h"

@interface NewsDetailViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) News* news;

@property (weak, nonatomic) IBOutlet UIScrollView *slideShowScrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTextField;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
