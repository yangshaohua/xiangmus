//
//  SearchGongJiJinViewController.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/3/16.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "SearchGongJiJinViewController.h"

@interface SearchGongJiJinViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SearchGongJiJinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self initData];
    
    [self createUI];
}

- (void)setUpNavigation
{
    SYTopNaviBarView *topNavi = [[SYTopNaviBarView alloc] init];
    topNavi.titleLabel.text = NSLocalizedString(@"公积金查询", nil);
    topNavi.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:topNavi];
    [self.view bringSubviewToFront: topNavi];
}

- (void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"logintest(1).html" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (array && [array isKindOfClass:[NSArray class]]) {
        self.dataArray = array;
    }
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenSize.width, kScreenSize.height - kNavigationHeight - kTabbarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate/Datasource
- (void)
@end
