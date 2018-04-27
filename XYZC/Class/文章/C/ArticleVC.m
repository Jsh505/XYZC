//
//  ArticleVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "ArticleVC.h"
#import "ArticleListCell.h"
#import "WriteArticleVC.h"
#import "ArticleInfoVC.h"
#import "PersonInfoVC.h"
#import "PopoverView.h"
#import "MJRefresh.h"

@interface ArticleVC () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ArticleListCellDelegate>
{
    int _type;
    int _page;
}

@property (nonatomic, strong) UIButton * rightBarButton;
@property (nonatomic,strong) UISegmentedControl   *headerSegment;
@property (nonatomic,strong) UIScrollView         *contentScrollview;

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) UITableView * coustromTableView1;
@property (nonatomic, strong) UITableView * coustromTableView2;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * dataSource1;
@property (nonatomic, strong) NSMutableArray * dataSource2;

// 上提刷新视图
@property (nonatomic) MJRefreshFooter *footRefreshView;

// 下拉刷新视图
@property (nonatomic) MJRefreshHeader *headRefreshView;

@end

@implementation ArticleVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatArticleView];
    
    _type = 1;
    _page = 1;
    self.dataSource = [[NSMutableArray alloc] init];
    self.dataSource1 = [[NSMutableArray alloc] init];
    self.dataSource2 = [[NSMutableArray alloc] init];
    [self loadData];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(loadData) name:@"articleHomeRefush" object:nil];
}

- (void)loadData
{
    //result ，msg ，articleList 列表字段如下：articleid 文章id title 标题content 内容，cdate添加时间 name 作者姓名 nickname作者昵称 userId作者id picturename 图片名称 headpicturename 作者头像图片名称   school 学校 grade 年级 gender 性别 goodnumber 点赞数 commnumber 评论数 isgood  当前用户是否点赞（1  点过 0 未点）
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:@(_type) forKey:@"type"];
    [parametersDic setObject:@(_page) forKey:@"intPage"];
    
    [PPNetworkHelper POST:@"queryArticleList.app" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
     {
         if ([responseObject objectForKey:@"articleList"] > 0)
         {
             switch (_type)
             {
                 case 1:
                 {
                     if (_page == 1)
                     {
                         [self.dataSource removeAllObjects];
                     }
                     for (NSDictionary * dic in [responseObject objectForKey:@"articleList"])
                     {
                         MyarticleModel * model = [[MyarticleModel alloc] initWithDictionary:dic];
                         [self.dataSource addObject:model];
                     }
                     [self.coustromTableView reloadData];
                     [self endRefreshingWithScrollerView:self.coustromTableView];
                     break;
                 }
                 case 2:
                 {
                     if (_page == 1)
                     {
                         [self.dataSource1 removeAllObjects];
                     }
                     for (NSDictionary * dic in [responseObject objectForKey:@"articleList"])
                     {
                         MyarticleModel * model = [[MyarticleModel alloc] initWithDictionary:dic];
                         [self.dataSource1 addObject:model];
                     }
                     [self.coustromTableView1 reloadData];
                     [self endRefreshingWithScrollerView:self.coustromTableView1];
                     break;
                 }
                 case 3:
                 {
                     if (_page == 1)
                     {
                         [self.dataSource2 removeAllObjects];
                     }
                     for (NSDictionary * dic in [responseObject objectForKey:@"articleList"])
                     {
                         MyarticleModel * model = [[MyarticleModel alloc] initWithDictionary:dic];
                         [self.dataSource2 addObject:model];
                     }
                     [self.coustromTableView2 reloadData];
                     break;
                 }
                 default:
                     break;
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
         [self endRefreshingWithScrollerView:self.coustromTableView2];
     } failure:^(NSString *error)
     {
         if (_page != 1)
         {
             _page --;
         }
         [MBProgressHUD showErrorMessage:error];
         [self endRefreshingWithScrollerView:self.coustromTableView2];
     }];
    
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)rightBarButtonClicked
{
    //新建
    WriteArticleVC * vc = [[WriteArticleVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)segCChanged:(UISegmentedControl*)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    CGRect frame = self.contentScrollview.frame;
    frame.origin.x = index * CGRectGetWidth(self.contentScrollview.frame);
    frame.origin.y = 0;
    [self.contentScrollview scrollRectToVisible:frame animated:YES];
    _type = (int)index + 1;
    _page = 1;
    switch (_type)
    {
        case 1:
        {
            if (self.dataSource.count == 0)
            {
                [self loadData];
            }
            break;
        }
        case 2:
        {
            if (self.dataSource1.count == 0)
            {
                [self loadData];
            }
            break;
        }
        case 3:
        {
            if (self.dataSource2.count == 0)
            {
                [self loadData];
            }
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)creatArticleView
{
    [self.customNavBar sd_addSubviews:@[self.headerSegment, self.rightBarButton]];
    
    self.headerSegment.sd_layout
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight + 6)
    .centerXIs(SCREEN_WIDTH / 2)
    .widthIs(SCREEN_WIDTH - 100)
    .heightIs(30);
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 0)
    .heightIs(44)
    .widthRatioToView(self.view, 0.15)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
    [self.headerSegment setSelectedSegmentIndex:0];
    
    [self.view addSubview:self.contentScrollview];
    
    self.contentScrollview.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .leftSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight);
}

- (NSArray<PopoverAction *> *)QQActions
{
    PopoverAction *dashangAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"文章打赏"] title:@"打赏" handler:^(PopoverAction *action)
                                 {
                                     
                                 }];
    PopoverAction *sharAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"文章分享"] title:@"分享" handler:^(PopoverAction *action)
                                 {
                                     
                                 }];
    
    PopoverAction *jubaoFriAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"文章举报"] title:@"举报" handler:^(PopoverAction *action)
                                     {
                                         
                                     }];
    NSArray * array = @[dashangAction, sharAction, jubaoFriAction];
    return array;
}

#pragma mark - Deletate/DataSource (相关代理)

- (void)moreButton:(UIButton *)button
{
    //更多操作
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    [popoverView showToView:button withActions:[self QQActions]];
}

- (void)pushPersonWithModel:(MyarticleModel *)model
{
    //访问个人
    PersonInfoVC * vc = [[PersonInfoVC alloc] init];
    vc.userId = model.userId;
    vc.customNavBar.title = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dianzanButton:(UIButton *)button Model:(MyarticleModel *)model
{
    //点赞
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:@(model.id) forKey:@"articleId"];
    
    [PPNetworkHelper POST:@"goodArticle.app" parameters:parametersDic hudString:nil success:^(id responseObject)
    {
        button.selected = !button.selected;
        if (button.selected)
        {
            [button setTitle:[NSString stringWithFormat:@"%d",[button.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:[NSString stringWithFormat:@"%d",[button.titleLabel.text intValue] - 1] forState:UIControlStateNormal];
        }
    } failure:^(NSString *error)
    {
        [MBProgressHUD showErrorMessage:error];
    }];
    
}

- (void)pinglunButton:(UIButton *)button
{
    //评论
}

#pragma mark - Scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.coustromTableView && scrollView != self.coustromTableView1 && scrollView != self.coustromTableView2)
    {
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger ratio = round(offSetX / SCREEN_WIDTH);
        _headerSegment.selectedSegmentIndex = ratio;
        _type = (int)ratio + 1;
        _page = 1;
        switch (_type)
        {
            case 1:
            {
                if (self.dataSource.count == 0)
                {
                    [self loadData];
                }
                break;
            }
            case 2:
            {
                if (self.dataSource1.count == 0)
                {
                    [self loadData];
                }
                break;
            }
            case 3:
            {
                if (self.dataSource2.count == 0)
                {
                    [self loadData];
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.coustromTableView)
    {
        return self.dataSource.count;
    }
    else if (tableView == self.coustromTableView1)
    {
        return self.dataSource1.count;
    }
    else
    {
        return self.dataSource2.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 275 / 375;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleListCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ArticleListCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    if (tableView == self.coustromTableView)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    else if (tableView == self.coustromTableView1)
    {
        cell.model = self.dataSource1[indexPath.row];
    }
    else
    {
        cell.model = self.dataSource2[indexPath.row];
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleInfoVC * vc = [[ArticleInfoVC alloc] init];
    if (tableView == self.coustromTableView)
    {
        vc.model = self.dataSource[indexPath.row];
    }
    else if (tableView == self.coustromTableView1)
    {
        vc.model = self.dataSource1[indexPath.row];
    }
    else
    {
        vc.model = self.dataSource2[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark MJRefresh下拉刷新
///    添加下拉刷新
- (void)addpull2RefreshWithTableView:(UIScrollView *)tableView WithIsInset:(BOOL)isInset
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pull2RefreshWithScrollerView:)];
    tableView.mj_header = header;
    _headRefreshView = tableView.mj_header;
    [tableView.mj_header endRefreshing];
    // 外观设置
    // 设置文字
    [header setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:13];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
}

///   添加上提加载
- (void)addPush2LoadMoreWithTableView:(UITableView *)tableView WithIsInset:(BOOL)isInset
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(push2LoadMoreWithScrollerView:)];
    tableView.mj_footer = footer;
    
    _footRefreshView = tableView.mj_footer;
    [tableView.mj_footer endRefreshing];
    // 设置文字
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多数据可供加载" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    
}

//下拉刷新
- (void)pull2RefreshWithScrollerView:(UIScrollView *)scrollerView
{
    
}

//上提加载
- (void)push2LoadMoreWithScrollerView:(UIScrollView *)scrollerView
{
    _page ++;
    [self loadData];
}

- (void)endRefreshingWithScrollerView:(UIScrollView *)scrollerView
{
    [scrollerView.mj_header endRefreshing];
    [scrollerView.mj_footer endRefreshing];
}

#pragma mark - Setter/Getter

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setTitle:@"" forState: UIControlStateNormal];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBarButton setImage:[UIImage imageNamed:@"文章新建"] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

- (UISegmentedControl *)headerSegment
{
    if (!_headerSegment)
    {
        _headerSegment = [[UISegmentedControl alloc]init];
//        _headerSegment.frame = CGRectMake(50 , JSH_StatusBarHeight + 6, SCREEN_WIDTH - 100, 30);
        //添加小按钮
        [_headerSegment insertSegmentWithTitle:@"热门" atIndex:0 animated:YES];
        [_headerSegment insertSegmentWithTitle:@"同城" atIndex:1 animated:YES];
        [_headerSegment insertSegmentWithTitle:@"关注" atIndex:2 animated:YES];
        //设置样式
        [_headerSegment setTintColor:[UIColor colorWithHexString:@"484848"]];
        //设置字体样式
        [_headerSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"484848"]} forState:UIControlStateNormal];
        [_headerSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor mainColor]} forState:UIControlStateSelected];
        //添加事件
        [_headerSegment addTarget:self action:@selector(segCChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _headerSegment;
}

- (UIScrollView *)contentScrollview
{
    if (!_contentScrollview)
    {
        _contentScrollview = [[UIScrollView alloc] init];
//        [_contentScrollview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin)];
        _contentScrollview.pagingEnabled = YES;
        _contentScrollview.delegate = self;
        _contentScrollview.showsHorizontalScrollIndicator = NO;
        _contentScrollview.bounces = false;
        //方向锁
        _contentScrollview.directionalLockEnabled = YES;
        //取消自动布局
        self.automaticallyAdjustsScrollViewInsets = NO;
        //为scrollview设置大小  需要计算调整
        _contentScrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight);
        
        [_contentScrollview addSubview:self.coustromTableView];
        [_contentScrollview addSubview:self.coustromTableView1];
        [_contentScrollview addSubview:self.coustromTableView2];
        [self addPush2LoadMoreWithTableView:self.coustromTableView WithIsInset:NO];
        [self addPush2LoadMoreWithTableView:self.coustromTableView1 WithIsInset:NO];
        [self addPush2LoadMoreWithTableView:self.coustromTableView2 WithIsInset:NO];
    }
    return _contentScrollview;
}


- (UITableView *)coustromTableView
{
    if (!_coustromTableView)
    {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableView;
}

- (UITableView *)coustromTableView1
{
    if (!_coustromTableView1)
    {
        _coustromTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight) style:UITableViewStylePlain];
        _coustromTableView1.delegate = self;
        _coustromTableView1.dataSource = self;
        _coustromTableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView1.showsVerticalScrollIndicator = NO;
        _coustromTableView1.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableView1;
}

- (UITableView *)coustromTableView2
{
    if (!_coustromTableView2)
    {
        _coustromTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight) style:UITableViewStylePlain];
        _coustromTableView2.delegate = self;
        _coustromTableView2.dataSource = self;
        _coustromTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView2.showsVerticalScrollIndicator = NO;
        _coustromTableView2.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableView2;
}

@end
