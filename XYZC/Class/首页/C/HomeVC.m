//
//  HomeVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/27.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "HomeVC.h"
#import "FL_Button.h"
#import "PYSearch.h"
#import "SearchRuesltVC.h"
#import "TLCityPickerController.h"
#import "BaseNavigationController.h"
#import "SDCycleScrollView.h"
#import "HomeTypeChoseCell.h"
#import "QZConditionFilterView.h"
#import "HomeListCell.h"
#import "DdTestVC.h"
#import "FindJobListVC.h"
#import "FindTrainingListVC.h"
#import "JobInfoVC.h"
#import "PositionListModel.h"

@interface HomeVC () <PYSearchViewControllerDelegate, TLCityPickerDelegate, SDCycleScrollViewDelegate, HomeTypeChoseCellDelegate, QZConditionFilterViewDelegate>
{
    int _page;
}

@property (nonatomic, strong) FL_Button * leftBarButton;
@property (nonatomic, strong) UIButton * searchButton;
@property (nonatomic, strong) UIButton * rightBarButton;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic, strong) SDCycleScrollView * cycleScrollTextView;

@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, strong) NSArray * selectedDataSource1Ary;
@property (nonatomic, strong) NSArray * selectedDataSource2Ary;
@property (nonatomic, strong) NSArray * selectedDataSource3Ary;
@property (nonatomic, strong) QZConditionFilterView * conditionFilterView;

@property (nonatomic, strong) NSMutableArray * photoArray;
@property (nonatomic, strong) NSMutableArray * textArray;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation HomeVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatHomeView];
    
    self.cityName = @"成都";
    
    self.photoArray = [[NSMutableArray alloc] init];
    self.textArray = [[NSMutableArray alloc] init];
    
     [self loadScrollData];
    
    _page = 1;
    self.dataSource = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)loadScrollData
{
    //轮播图
    [PPNetworkHelper POST:@"pictureList.app" parameters:nil hudString:nil responseCache:^(id responseCache)
     {
         [self.photoArray removeAllObjects];
         NSMutableArray * array = [[NSMutableArray alloc] init];
         for (NSDictionary *dic in [responseCache objectForKey:@"pictureList"])
         {
             [self.photoArray addObject:dic];
             [array addObject:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,[dic objectForKey:@"picturename"]]];
         }
         
         [self.cycleScrollView setImageURLStringsGroup:array];
    } success:^(id responseObject)
     {
         if (self.photoArray.count == 0)
         {
             [self.photoArray removeAllObjects];
             NSMutableArray * array = [[NSMutableArray alloc] init];
             for (NSDictionary *dic in [responseObject objectForKey:@"pictureList"])
             {
                 [self.photoArray addObject:dic];
                 [array addObject:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,[dic objectForKey:@"picturename"]]];
             }
             
             [self.cycleScrollView setImageURLStringsGroup:array];
         }
    } failure:^(NSString *error) {
    }];
    //文字轮播
    [PPNetworkHelper POST:@"textList.app" parameters:nil hudString:nil responseCache:^(id responseCache)
    {
        [self.textArray removeAllObjects];
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [responseCache objectForKey:@"textList"])
        {
            [self.textArray addObject:dic];
            [array addObject:[dic objectForKey:@"text"]];
        }
        
        [self.cycleScrollTextView setTitlesGroup:array];
    } success:^(id responseObject)
     {
         if (self.textArray.count == 0)
         {
             [self.textArray removeAllObjects];
             NSMutableArray * array = [[NSMutableArray alloc] init];
             for (NSDictionary *dic in [responseObject objectForKey:@"textList"])
             {
                 [self.textArray addObject:dic];
                 [array addObject:[dic objectForKey:@"text"]];
             }
             
             [self.cycleScrollTextView setTitlesGroup:array];
         }
    } failure:^(NSString *error) {
    }];
}

- (void)loadData
{
//    type  职位类型(如 销售 工程师 财务) area区域 sex 性别要求（无  男  女） workDate 上班时段 （上午  下午 晚上）welfare 福利待遇   intPage  非空 当前页数，从1开始
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(_page) forKey:@"intPage"];
    
    [PPNetworkHelper POST:@"positionList.app" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
    {
        if ([responseObject objectForKey:@"positionList"] > 0)
        {
            if (_page == 1)
            {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary * dic in [responseObject objectForKey:@"positionList"])
            {
                PositionListModel * model = [[PositionListModel alloc] initWithDictionary:dic];
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

- (void)push2LoadMoreWithScrollerView:(UIScrollView *)scrollerView
{
    _page ++;
    [self loadData];
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)leftBarButtonClicked
{
    
    
    [self.conditionFilterView dismiss];
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.loactionCityName = self.cityName;
    //    cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{

    }];
}

- (void)searchButtonClicked
{
    [self.conditionFilterView dismiss];
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[SearchRuesltVC alloc] init] animated:YES];
    }];
    // 3. Set style for popular search and search history
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault;
//    [searchViewController setSearchBarBackgroundColor:[UIColor mainColor]];
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)rightBarButtonClicked
{
    //签到
    [self.conditionFilterView dismiss];

    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:[NSString nowDate] forKey:@"signDate"];

    [PPNetworkHelper POST:@"addSignin.app" parameters:parametersDic hudString:@"签到中..." success:^(id responseObject)
    {
        [MBProgressHUD showInfoMessage:@"签到成功"];

    } failure:^(NSString *error)
    {
        [MBProgressHUD showErrorMessage:error];
    }];
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)creatHomeView
{
    [self.view addSubview:self.coustromTableView];
    
    [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
    
    [self.customNavBar sd_addSubviews:@[self.leftBarButton, self.searchButton, self.rightBarButton]];
    
    self.leftBarButton.sd_layout
    .leftSpaceToView(self.customNavBar, 5)
    .heightIs(44)
    .widthRatioToView(self.view, 0.2)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 5)
    .heightRatioToView(self.leftBarButton, 1)
    .widthRatioToView(self.leftBarButton, 1)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
    self.searchButton.sd_layout
    .leftSpaceToView(self.leftBarButton, 5)
    .rightSpaceToView(self.rightBarButton, 5)
    .heightIs(30)
    .centerYEqualToView(self.leftBarButton);
    [self.searchButton setSd_cornerRadius:@(15)];
    
    self.coustromTableView.tableHeaderView = self.headerView;

    // 设置初次加载显示的默认数据 即初次加载还没有选择操作之前要显示的标题数据
    self.selectedDataSource1Ary = @[@"类型"];
    self.selectedDataSource2Ary = @[@"区域"];
    self.selectedDataSource3Ary = @[@"综合"];
    
    // 传入数据源，对应三个tableView顺序
    self.conditionFilterView.dataAry1 = @[];
    self.conditionFilterView.dataAry2 = @[];
    self.conditionFilterView.dataAry3 = @[];
    
    // 初次设置默认显示数据(标题)，内部会调用block 进行第一次数据加载
    [self.conditionFilterView bindChoseArrayDataSource1:_selectedDataSource1Ary DataSource2:_selectedDataSource2Ary DataSource3:_selectedDataSource3Ary];
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


#pragma mark - Deletate/DataSource (相关代理)

- (void)choseButtonCilickWithType:(HomeTypeChoseCellButtonType)type
{
    //选择类型回调
    [self.conditionFilterView dismiss];
    switch (type)
    {
        case testButton:
        {
            //做测试
            DdTestVC * vc = [[DdTestVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case findJobButton:
        {
            //找工作
            FindJobListVC * vc = [[FindJobListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case findPeiXunButton:
        {
            //找培训
            FindTrainingListVC * vc = [[FindTrainingListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case tishengButton:
        {
            //提升
            
            break;
        }
        default:
            break;
    }
}

- (void)typeButtonCilick
{
    //筛选点击
//    [self.coustromTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)screenbuttonClicked
{
    //筛选点击
//    [self.coustromTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    FindJobListVC * vc = [[FindJobListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - QZConditionFilterViewDelegate

#pragma mark - TLCityPickerDelegate
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    NSLog(@"%@",city.cityName);
    
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    

}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // Refresh and display the search suggustions
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else
    {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        lineView.backgroundColor = [UIColor backgroudColor];
        return lineView;
    }
    else
    {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
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
        
        UIButton * cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cleanButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        cleanButton.backgroundColor = [UIColor clearColor];
        [cleanButton addTarget:self action:@selector(screenbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [lineView addSubview:cleanButton];
        
        return lineView;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return self.dataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return SCREEN_WIDTH * 140 / 375;
    }
    else
    {
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        HomeTypeChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTypeChoseCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"HomeTypeChoseCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        return cell;
    }
    else
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

- (FL_Button *)leftBarButton
{
    if (!_leftBarButton)
    {
        _leftBarButton = [[FL_Button alloc] initWithAlignmentStatus:FLAlignmentStatusCenter];
        _leftBarButton.fl_padding = 3;
        [_leftBarButton setTitle:@"成都" forState: UIControlStateNormal];
        _leftBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBarButton setImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
        _leftBarButton.backgroundColor = [UIColor clearColor];
        [_leftBarButton addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBarButton;
}

- (UIButton *)searchButton
{
    if (!_searchButton)
    {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _searchButton.alpha = 0.7;
        [_searchButton setTitle:@"搜索" forState: UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
        _searchButton.contentMode = UIViewContentModeLeft;
        _searchButton.backgroundColor = [UIColor whiteColor];
        [_searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setTitle:@" 打卡" forState: UIControlStateNormal];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBarButton setImage:[UIImage imageNamed:@"签到"] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 200 / 375)];
        [_headerView addSubview:self.cycleScrollView];
        [_headerView addSubview:self.cycleScrollTextView];
    }
    return _headerView;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView)
    {
        //    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) delegate:self placeholderImage:Default_General_Image];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 200 / 375 - 30) shouldInfiniteLoop:YES imageNamesGroup:@[@"轮播1",@"轮播2",@"轮播1"]];
        _cycleScrollView.showPageControl = NO;
//        _cycleScrollView.titlesGroup = @[@"1111",@"2222",@"3333"];
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _cycleScrollView.titleLabelTextColor = [UIColor titleColor];
        //加载网络视图
        //    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    }
    return _cycleScrollView;
}

- (SDCycleScrollView *)cycleScrollTextView
{
    if (!_cycleScrollTextView)
    {
        //    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) delegate:self placeholderImage:Default_General_Image];
        _cycleScrollTextView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, SCREEN_WIDTH * 200 / 375 - 30, SCREEN_WIDTH, 30) shouldInfiniteLoop:YES imageNamesGroup:@[@"轮播1",@"轮播2",@"轮播1"]];
        _cycleScrollTextView.showPageControl = NO;
        _cycleScrollTextView.titlesGroup = @[@"1111",@"2222",@"3333"];
        _cycleScrollTextView.onlyDisplayText = YES;
        _cycleScrollTextView.titleLabelBackgroundColor = [UIColor whiteColor];
        _cycleScrollTextView.titleLabelTextColor = [UIColor titleColor];
        //加载网络视图
        //    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    }
    return _cycleScrollTextView;
}

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
                _selectedDataSource3Ary = @[@"综合"];
            }
            _conditionFilterView.delegate = self;
            // 开始网络请求
            [self startRequest];
        }];
    }
    return _conditionFilterView;
}

@end
