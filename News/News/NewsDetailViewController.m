//
//  NewsDetailViewController.m
//  News
//
//  Created by Shaohuan Li on 5/3/15.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#define AUTO_SCROLL_INTERVAL 2

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property (nonatomic, strong) NSTimer* slideShowAutoScrollTimer;
@property (nonatomic) int maxPageIndexInBanner;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self renderTexts];
    [self render2DSlideShow];
}

- (void) renderTexts{
    self.titleLabel.text = self.news.title;
    self.timeLabel.text = self.news.time;
    self.categoryLabel.text = self.news.category;
    self.contentTextField.text = self.news.text;
}

- (void) render2DSlideShow{
    //init
    self.slideShowScrollView.delegate = self;
    self.slideShowScrollView.pagingEnabled = YES;
    CGRect frame = self.slideShowScrollView.frame;
    self.slideShowScrollView.frame = CGRectMake(frame.origin.x,
                                                frame.origin.y,
                                                [self getScreenWidth],
                                                frame.size.height);
    
    for (int i = 0; i < [self.news.imageURLs count]; i++) {
        frame.origin.x = self.slideShowScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.slideShowScrollView.frame.size;
        
        //New SubView
        UIImageView *subview1 = [[UIImageView alloc] initWithFrame:frame];
        subview1.clipsToBounds = YES;
        subview1.contentMode = UIViewContentModeScaleAspectFill;
        NSURL* url = [NSURL URLWithString:[self.news.imageURLs objectAtIndex: i]];
        [subview1 sd_setImageWithURL:url
                    placeholderImage:nil];
        
        [self.slideShowScrollView addSubview:subview1];
    }
    
    //Content Size Scrollview
    self.slideShowScrollView.contentSize = CGSizeMake(self.slideShowScrollView.frame.size.width * ([self.news.imageURLs count]), self.slideShowScrollView.frame.size.height);
    [self.view addSubview:self.slideShowScrollView];
    
    if (self.news.imageURLs.count > 1) {
        self.slideShowAutoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:AUTO_SCROLL_INTERVAL
                                                                         target:self
                                                                       selector:@selector(autoScrollToNextPage)
                                                                       userInfo:nil
                                                                        repeats:YES];
    }
}

- (void)autoScrollToNextPage{
    
    CGRect frame = self.slideShowScrollView.frame;
    int currentPageIndex = (int)(self.slideShowScrollView.contentOffset.x / frame.size.width);
    
    currentPageIndex = (currentPageIndex + 1) % (int)self.news.imageURLs.count;
    
    frame.origin.x = frame.size.width * currentPageIndex;
    frame.origin.y = 0;
    [self.slideShowScrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - Button Click Events

- (void)backButtonClicked: (UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end