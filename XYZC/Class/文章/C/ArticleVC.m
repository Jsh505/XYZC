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

@interface ArticleVC () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ArticleListCellDelegate>

@property (nonatomic, strong) UIButton * rightBarButton;
@property (nonatomic,strong) UISegmentedControl   *headerSegment;
@property (nonatomic,strong) UIScrollView         *contentScrollview;

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) UITableView * coustromTableView1;
@property (nonatomic, strong) UITableView * coustromTableView2;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * dataSource1;
@property (nonatomic, strong) NSMutableArray * dataSource2;


@end

@implementation ArticleVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatArticleView];
    
    [self loadData];
}

- (void)loadData
{
    //result ，msg ，articleList 列表字段如下：articleid 文章id title 标题content 内容，cdate添加时间 name 作者姓名 nickname作者昵称 userId作者id picturename 图片名称 headpicturename 作者头像图片名称   school 学校 grade 年级 gender 性别 goodnumber 点赞数 commnumber 评论数 isgood  当前用户是否点赞（1  点过 0 未点）
    for (int i = 1; i < 4; i ++)
    {
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
        [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
        [parametersDic setObject:@(i) forKey:@"type"];
        
        [PPNetworkHelper POST:@"queryArticleList.app" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
         {
             [self.dataSource removeAllObjects];
             
             for (NSDictionary * dic in [responseObject objectForKey:@"articleList"])
             {
                 MyarticleModel * model = [[MyarticleModel alloc] initWithDictionary:dic];
                 [self.dataSource addObject:model];
             }
             [self.coustromTableView reloadData];
         } failure:^(NSString *error)
         {
             
         }];
    }
    
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

- (void)pushPerson
{
    //访问个人
    PersonInfoVC * vc = [[PersonInfoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dianzanButton:(UIButton *)button
{
    //点赞
    button.selected = YES;
}

- (void)pinglunButton:(UIButton *)button
{
    //评论
}

#pragma mark - Scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.coustromTableView)
    {
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger ratio = round(offSetX / SCREEN_WIDTH);
        _headerSegment.selectedSegmentIndex = ratio;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.coustromTableView)
    {
        return 3;
    }
    else if (tableView == self.coustromTableView1)
    {
        return 2;
    }
    else
    {
        return 1;
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
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleInfoVC * vc = [[ArticleInfoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_headerSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
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
