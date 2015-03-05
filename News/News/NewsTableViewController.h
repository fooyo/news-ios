//
//  NewsTableViewController.h
//  News
//
//  Created by Shaohuan Li on 5/3/15.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTableCell.h"
#import "SwitchedToPageOfIndexDelegate.h"
#import "News.h"
#import "HttpClient.h"
#import "UIView+Toast.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString* category;
@property (weak, nonatomic) IBOutlet UITableView *newsTable;
@property (weak) id<SwitchedToPageDelegate> delegate;
@property NSUInteger pageIndex;
@property NSString *imageFile;

@end