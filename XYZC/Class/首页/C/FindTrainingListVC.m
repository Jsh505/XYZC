//
//  FindTrainingListVC.m
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "FindTrainingListVC.h"
#import "HomeListCell.h"
#import "QZConditionFilterView.h"
#import "CultivateListModel.h"
#import "FindTrainingVC.h"

@interface FindTrainingListVC ()
{
    int _page;
}

@property (nonatomic, strong) NSArray * selectedDataSource1Ary;
@property (nonatomic, strong) NSArray * selectedDataSource2Ary;
@property (nonatomic, strong) NSArray * selectedDataSource3Ary;
@property (nonatomic, strong) QZConditionFilterView * conditionFilterView;

@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation FindTrainingListVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"找培训";
    [self creatFindJobListView];
    
    _page = 1;
    self.dataSource = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.conditionFilterView dismiss];
}

- (void)loadData
{
    //    type  职位类型(如 销售 工程师 财务) area区域 sex 性别要求（无  男  女） workDate 上班时段 （上午  下午 晚上）welfare 福利待遇   intPage  非空 当前页数，从1开始
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(_page) forKey:@"intPage"];
    
    [PPNetworkHelper POST:@"cultivateList.app" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
     {
         if ([responseObject objectForKey:@"cultivateList"] > 0)
         {
             if (_page == 1)
             {
                 [self.dataSource removeAllObjects];
             }
             for (NSDictionary * dic in [responseObject objectForKey:@"cultivateList"])
             {
                 CultivateListModel * model = [[CultivateListModel alloc] initWithDictionary:dic];
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

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)

- (void)push2LoadMoreWithScrollerView:(UIScrollView *)scrollerView
{
    _page ++;
    [self loadData];
}

#pragma mark - Private (.m 私有方法)

- (void)creatFindJobListView
{
    [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
    self.coustromTableView.frame = CGRectMake(0, JSH_NavbarAndStatusBarHeight + 50, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - 50);
    [self.view addSubview:self.coustromTableView];
    
    // 设置初次加载显示的默认数据 即初次加载还没有选择操作之前要显示的标题数据
    self.selectedDataSource1Ary = @[@"类型"];
    self.selectedDataSource2Ary = @[@"区域"];
    self.selectedDataSource3Ary = @[@"综合排序"];
    
    // 传入数据源，对应三个tableView顺序
    self.conditionFilterView.dataAry1 = @[@"不限",@"送餐员",@"促销",@"礼仪"];
    self.conditionFilterView.dataAry2 = @[@"2-1",@"2-2",@"2-3",@"2-4",@"2-5"];
    self.conditionFilterView.dataAry3 = @[@"综合排序",@"最新发布",@"理我最近"];
    
    // 初次设置默认显示数据(标题)，内部会调用block 进行第一次数据加载
    [self.conditionFilterView bindChoseArrayDataSource1:_selectedDataSource1Ary DataSource2:_selectedDataSource2Ary DataSource3:_selectedDataSource3Ary];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, JSH_NavbarAndStatusBarHeight, SCREEN_WIDTH, 50)];
    lineView.backgroundColor = [UIColor backgroudColor];
    [lineView addSubview:self.conditionFilterView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH * 3 / 4, 10, SCREEN_WIDTH * 1 / 4, 39);
    [button setTitle:@"筛选" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(screenbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [lineView addSubview:button];
    [self.view addSubview:lineView];
    
}

- (void)startRequest
{
    NSString *source1 = [NSString stringWithFormat:@"%@",self.selectedDataSource1Ary.firstObject];
    NSString *source2 = [NSString stringWithFormat:@"%@",self.selectedDataSource2Ary.firstObject];
    NSString *source3 = [NSString stringWithFormat:@"%@",self.selectedDataSource3Ary.firstObject];
    NSDictionary *dic = [_conditionFilterView keyValueDic];
    // 可以用字符串在dic换成对应英文key
    
    NSLog(@"\n第一个条件:%@\n  第二个条件:%@\n  第三个条件:%@\n",source1,source2,source3);
}

- (void)screenbuttonClicked
{
    //筛选点击
    
}



#pragma mark - Deletate/DataSource (相关代理)

#pragma mark UITableViewDataSource

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
    cell.cultivateListModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CultivateListModel * model = self.dataSource[indexPath.row];
    FindTrainingVC * vc = [[FindTrainingVC alloc] init];
    vc.id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Setter/Getter

- (QZConditionFilterView *)conditionFilterView
{
    if (!_conditionFilterView)
    {
        // FilterBlock 选择下拉菜单选项触发
        _conditionFilterView = [QZConditionFilterView conditionFilterViewWithFilterBlock:^(BOOL isFilter, NSArray *dataSource1Ary, NSArray *dataSource2Ary, NSArray *dataSource3Ary)
                                {
                                    // 1.isFilter = YES 代表是用户下拉选择了某一项
                                    // 2.dataSource1Ary 选择后第一组选择的数据  2 3一次类推
                                    // 3.如果你的项目没有清空筛选条件的功能，可以无视else 我们的app有清空之前的条件，重置，所以才有else的逻辑
                                    if (isFilter)
                                    {
                                        //网络加载请求 存储请求参数
                                        _selectedDataSource1Ary = dataSource1Ary;
                                        _selectedDataSource2Ary = dataSource2Ary;
                                        _selectedDataSource3Ary = dataSource3Ary;
                                    }
                                    else
                                    {
                                        // 不是筛选，全部赋初值（在这个工程其实是没用的，因为tableView是选中后必选的，即一旦选中就没有空的情况，但是如果可以清空筛选条件的时候就有必要 *重新* reset data）
                                        _selectedDataSource1Ary = @[@"类型"];
                                        _selectedDataSource2Ary = @[@"区域"];
                                        _selectedDataSource3Ary = @[@"综合排序"];
                                    }
                                    //                                    _conditionFilterView.delegate = self;
                                    // 开始网络请求
                                    [self startRequest];
                                }];
    }
    return _conditionFilterView;
}

@end
