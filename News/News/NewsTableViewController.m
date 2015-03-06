//
//  NewsTableViewController.m
//  News
//
//  Created by Shaohuan Li on 5/3/15.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsDetailViewController.h"
#define INVALID_OFFSET -1

@interface NewsTableViewController ()

@property (strong, nonatomic) NSMutableArray* newsArray;
@property (nonatomic) int offSet;
@property (nonatomic) BOOL isLoadingNextPage;

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.newsTable.delegate = self;
    self.newsTable.dataSource = self;
    
    self.newsArray = [[NSMutableArray alloc] init];
    self.offSet = INVALID_OFFSET;
    [self loadNewsDataFromServer];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.delegate contentViewControllerDidSwitchToPageOfIndex:(int)self.pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data

- (void)loadNewsDataFromServer{
    NSNumber* offset = self.offSet == INVALID_OFFSET ? nil : [NSNumber numberWithInt: self.offSet];
    
    //[self.view hideToastActivity];
    [self.view makeToastActivity];
    self.isLoadingNextPage = YES;
    
    [[HttpClient sharedInstance] getNewsWithOffset: offset
                                      withCategory: self.category
    success:^(id responseObject) {
        
        self.isLoadingNextPage = NO;
        [self.view hideToastActivity];
        
        NSDictionary* newsDicts = [responseObject objectForKey:@"news"];
                                               
        for (NSDictionary* newsDict in newsDicts) {
            News* news = [News convertFromNewsDictionaryToNewsObject: newsDict];
            [self.newsArray addObject: news];
        }
        [self.tableView reloadData];

        int newOffset = (int)[(NSString*)[responseObject objectForKey:@"offset"] integerValue];
        self.offSet = newOffset == INVALID_OFFSET ? self.offSet : newOffset;
        
        if (newsDicts.count == 0 && self.offSet == INVALID_OFFSET) {
            [self.view makeToast:@"There isn't any news from this category yet. Please try again later" duration:5 position:@"bottom"];
        } else if (newsDicts.count == 0 && self.offSet != INVALID_OFFSET){
            [self.view makeToast:@"No more news in this category. Please try again later" duration:5 position:@"bottom"];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
        self.isLoadingNextPage = NO;
        [self.view hideToastActivity];
        
        [self.view makeToast:@"Oops.. please check your network" duration:5 position:@"bottom"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *newsTableIdentifier = @"NewsCell";
    
    NewsTableCell *cell = (NewsTableCell *)[tableView dequeueReusableCellWithIdentifier:newsTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    News* news = [self.newsArray objectAtIndex: indexPath.row];
    
    cell.titleLabel.text = news.title;
    cell.sourceLabel.text = news.time;
    
    if (news.imageURLs.count > 0) {
        [cell.thumbImage sd_setImageWithURL:[NSURL URLWithString:[news.imageURLs objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    } else{
        cell.thumbImage.image = [UIImage imageNamed:@"placeholder.jpg"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsDetailViewController *newsDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    
    newsDetailViewController.news = [self.newsArray objectAtIndex: indexPath.row];
    newsDetailViewController.category = self.category;
    
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
}

// Delegate to inform the app to load the next page.
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // If loading next page, or the current page has nothing to show, don't load the next page.
    if (self.isLoadingNextPage == YES) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    if (offsetY > contentHeight - scrollView.frame.size.height){
        [self loadNewsDataFromServer];
    }
}

@end