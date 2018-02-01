//
//  CampusDisplayVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "CampusDisplayVC.h"
#import "CampusDisplayHeaderView.h"
#import "CampusDisplayCell.h"
#import "CampusDisplayListModel.h"
#import "CampusInfoVC.h"

@interface CampusDisplayVC ()

@property (nonatomic, strong) CampusDisplayHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation CampusDisplayVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"校园展示";
    
    [self.view addSubview:self.coustromTableView];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
    
    self.coustromTableView.tableHeaderView = self.headerView;
    self.dataSource = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)loadData
{
    [PPNetworkHelper POST:@"campusList.app" parameters:nil hudString:@"加载中..." success:^(id responseObject)
     {
         [self.dataSource removeAllObjects];
         for (NSDictionary * dic in [responseObject objectForKey:@"campusList"])
         {
             CampusDisplayListModel * model = [[CampusDisplayListModel alloc] initWithDictionary:dic];
             [self.dataSource addObject:model];
         }
         self.headerView.model = self.dataSource[0];
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
    cell.model = self.dataSource[indexPath.row + 1];
    return cell;
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CampusInfoVC * vc = [[CampusInfoVC alloc] init];
    vc.model = self.dataSource[indexPath.row + 1];
    vc.customNavBar.title = vc.model.campusName;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Setter/Getter

- (CampusDisplayHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [CampusDisplayHeaderView loadViewFromXIB];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 210 / 375);
    }
    return _headerView;
}

@end
