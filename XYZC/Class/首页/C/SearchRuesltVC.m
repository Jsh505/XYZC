//
//  SearchRueslt.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/27.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "SearchRuesltVC.h"
#import "HomeListCell.h"
#import "PositionListModel.h"
#import "JobInfoVC.h"

@interface SearchRuesltVC ()

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation SearchRuesltVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.k
    self.customNavBar.title = @"搜索结果";
    
    [self.view addSubview:self.coustromTableView];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customNavBar removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.customNavBar];
}

- (void)loadData
{
    //    type  职位类型(如 销售 工程师 财务) area区域 sex 性别要求（无  男  女） workDate 上班时段 （上午  下午 晚上）welfare 福利待遇   intPage  非空 当前页数，从1开始
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:self.searchText forKey:@"jobContent"];
    [parametersDic setObject:@(1) forKey:@"intPage"];
    
    [PPNetworkHelper POST:@"positionList.app" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
     {
         if ([responseObject objectForKey:@"positionList"] > 0)
         {
             for (NSDictionary * dic in [responseObject objectForKey:@"positionList"])
             {
                 PositionListModel * model = [[PositionListModel alloc] initWithDictionary:dic];
                 [self.dataSource addObject:model];
             }
         }
         
         [self.coustromTableView reloadData];
     } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
     }];
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"HomeListCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PositionListModel * model = self.dataSource[indexPath.row];
    JobInfoVC * vc = [[JobInfoVC alloc] init];
    vc.id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Setter/Getter

@end
