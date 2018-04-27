//
//  EnterpriseVC.m
//  XYZC
//
//  Created by 贾仕海 on 2018/2/2.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "EnterpriseListVC.h"
#import "CampusDisplayHeaderView.h"
#import "CampusDisplayCell.h"
#import "EntArtListModel.h"
#import "EnterpriseInfoVC.h"

@interface EnterpriseListVC ()
{
    int _page;
}

@property (nonatomic, strong) CampusDisplayHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation EnterpriseListVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"企业展示";
    
    [self.view addSubview:self.coustromTableView];
    [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
    
    self.coustromTableView.tableHeaderView = self.headerView;
    self.dataSource = [[NSMutableArray alloc] init];
    _page = 1;
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(_page) forKey:@"intPage"];
    
    [PPNetworkHelper POST:@"entArtList.app" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
     {
         if ([responseObject objectForKey:@"entArtList"] > 0)
         {
             if (_page == 1)
             {
                 [self.dataSource removeAllObjects];
             }
             for (NSDictionary * dic in [responseObject objectForKey:@"entArtList"])
             {
                 EntArtListModel * model = [[EntArtListModel alloc] initWithDictionary:dic];
                 [self.dataSource addObject:model];
             }
         }
         else
         {
             if (_page != 1)
             {
                 _page --;
                 [MBProgressHUD showInfoMessage:@"暂无更多数据"];
             }
         }
         self.headerView.entArtListModel = self.dataSource[0];
         [self.coustromTableView reloadData];
         [self endRefreshing];
     } failure:^(NSString *error)
     {
         if (_page != 1)
         {
             _page --;
         }
         [MBProgressHUD showErrorMessage:error];
         [self endRefreshing];
     }];
}

- (void)push2LoadMoreWithScrollerView:(UIScrollView *)scrollerView
{
    _page ++;
    [self loadData];
}


#pragma mark - Custom Accessors (控件响应方法)

- (void)headerViewSingleTap
{
    EnterpriseInfoVC * vc = [[EnterpriseInfoVC alloc] init];
    vc.model = self.dataSource[0];
    vc.customNavBar.title = vc.model.entName;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CampusDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CampusDisplayCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"CampusDisplayCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.entArtListModel = self.dataSource[indexPath.row + 1];
    return cell;
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnterpriseInfoVC * vc = [[EnterpriseInfoVC alloc] init];
    vc.model = self.dataSource[indexPath.row + 1];
    vc.customNavBar.title = vc.model.entName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter/Getter

- (CampusDisplayHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [CampusDisplayHeaderView loadViewFromXIB];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 210 / 375);
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewSingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_headerView addGestureRecognizer:singleRecognizer];
    }
    return _headerView;
}

@end
