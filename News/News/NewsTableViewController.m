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

@end

@implementation NewsTableViewController

@synthesize newsTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    newsTable.delegate = self;
    newsTable.dataSource = self;
    
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
    [self.view makeToastActivity];
    [[HttpClient sharedInstance] getNewsWithOffset: offset
                                      withCategory: self.category
    success:^(id responseObject) {
        [self.view hideToastActivity];
        for (NSDictionary* newsDict in [responseObject objectForKey:@"news"]) {
            News* news = [News convertFromNewsDictionaryToNewsObject: newsDict];
            [self.newsArray addObject: news];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger statusCode, NSError *error) {
        [self.view hideToastActivity];
        [self.view makeToast:@"Oops.. please check your network" duration:5 position:@"bottom"];
    }];
    
    // Test
    NSDictionary* newsDict = @{
                           @"title": @"Corgi1",
                           @"text": @"as;ldkfa;slkfjas;ldkfjsa;ldkfja;slkdjfa;slkdjfsal;kdjf",
                           @"category": @"corgi",
                           @"time": @"Yesterday 10:30am",
                           @"images": @[@"http://thewithouse.com/wp-content/uploads/2013/11/corgi-3.jpg",
                                        @"http://stuffpoint.com/dogs/image/208632-dogs-adorable-corgi-puppies-running-ddddd.jpg",
                                        @"https://poolhouse.s3.amazonaws.com/blog-assets-two/2014/08/corgicute.jpg"]
                           };
    News* news = [News convertFromNewsDictionaryToNewsObject:newsDict];
    [self.newsArray addObject: news];
    [self.tableView reloadData];
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
        [cell.thumbImage sd_setImageWithURL:[NSURL URLWithString:[news.imageURLs objectAtIndex:0]] placeholderImage:nil];
    } else{
        cell.thumbImage.image = nil;
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
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
}

@end