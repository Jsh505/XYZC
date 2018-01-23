//
//  MyFriendVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/3.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyFriendVC.h"
#import "FollowCell.h"
#import "FansModel.h"

@interface MyFriendVC () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, FollowCellDelegate>
{
    int _type;
}

@property (nonatomic, strong) UISegmentedControl   *headerSegment;
@property (nonatomic, strong) UIScrollView         *contentScrollview;

@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) UITableView * coustromTableView1;
@property (nonatomic, strong) UITableView * coustromTableView2;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * dataSource1;
@property (nonatomic, strong) NSMutableArray * dataSource2;
@end

@implementation MyFriendVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.customNavBar sd_addSubviews:@[self.headerSegment]];
    
    self.headerSegment.sd_layout
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight + 6)
    .centerXIs(SCREEN_WIDTH / 2)
    .widthIs(SCREEN_WIDTH - 150)
    .heightIs(30);
    [self.headerSegment setSelectedSegmentIndex:0];
    
    [self.view addSubview:self.contentScrollview];
    
    self.contentScrollview.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .leftSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight);
    
    _type = 1;
    self.dataSource = [[NSMutableArray alloc] init];
    self.dataSource1 = [[NSMutableArray alloc] init];
    self.dataSource2 = [[NSMutableArray alloc] init];
    
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:@(_type) forKey:@"type"];
    
    [PPNetworkHelper POST:@"fansList.app" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
    {
        switch (_type)
        {
            case 1:
            {
                [self.dataSource removeAllObjects];
                for (NSDictionary * dic in [responseObject objectForKey:@"fansList"])
                {
                    FansModel * model = [[FansModel alloc] initWithDictionary:dic];
                    model.type = _type;
                    [self.dataSource addObject:model];
                }
                [self.coustromTableView reloadData];
                break;
            }
            case 2:
            {
                [self.dataSource1 removeAllObjects];
                for (NSDictionary * dic in [responseObject objectForKey:@"fansList"])
                {
                    FansModel * model = [[FansModel alloc] initWithDictionary:dic];
                    model.type = _type;
                    [self.dataSource1 addObject:model];
                }
                [self.coustromTableView1 reloadData];
                break;
            }
            case 3:
            {
                [self.dataSource2 removeAllObjects];
                for (NSDictionary * dic in [responseObject objectForKey:@"fansList"])
                {
                    FansModel * model = [[FansModel alloc] initWithDictionary:dic];
                    model.type = _type;
                    [self.dataSource2 addObject:model];
                }
                [self.coustromTableView2 reloadData];
                break;
            }
            default:
                break;
        }
    } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
    }];
}

#pragma mark - Custom Accessors (控件响应方法)

-(void)segCChanged:(UISegmentedControl*)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    CGRect frame = self.contentScrollview.frame;
    frame.origin.x = index * CGRectGetWidth(self.contentScrollview.frame);
    frame.origin.y = 0;
    [self.contentScrollview scrollRectToVisible:frame animated:YES];
    _type = (int)index + 1;
    [self loadData];
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.coustromTableView && scrollView != self.coustromTableView1 && scrollView != self.coustromTableView2)
    {
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger ratio = round(offSetX / SCREEN_WIDTH);
        _headerSegment.selectedSegmentIndex = ratio;
        _type = (int)ratio + 1;
        [self loadData];
    }
}

- (void)moreButton:(UIButton *)button Model:(FansModel *)model
{
    //cell代理
    switch (model.type)
    {
        case 1:
        {
            //取消关注
            NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
            [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
            [parametersDic setObject:@(model.userId) forKey:@"fansFriendUserId"];
            [parametersDic setObject:@(2) forKey:@"type"];
            
            [PPNetworkHelper POST:@"deleteFocusFriends.app" parameters:parametersDic hudString:@"加好友..." success:^(id responseObject)
             {
                 [MBProgressHUD showInfoMessage:@"操作成功"];
                 [self loadData];
             } failure:^(NSString *error)
             {
                 [MBProgressHUD showErrorMessage:error];
             }];
            
            break;
        }
        case 2:
        {
            //加好友
            NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
            [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
            [parametersDic setObject:@(model.userId) forKey:@"fansFriendUserId"];
            [parametersDic setObject:@(1) forKey:@"type"];
            
            [PPNetworkHelper POST:@"addFansOrFriends.app" parameters:parametersDic hudString:@"加好友..." success:^(id responseObject)
            {
                [MBProgressHUD showInfoMessage:@"操作成功"];
                [self loadData];
            } failure:^(NSString *error)
             {
                [MBProgressHUD showErrorMessage:error];
            }];
            
            break;
        }
        case 3:
        {
            //聊天
            EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"13080808285" conversationType:EMConversationTypeChat];
            [self.navigationController pushViewController:chatController animated:YES];
            break;
        }
        default:
            break;
    }
}

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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"FollowCell" owner:nil options:nil];
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
    
}


#pragma mark - Setter/Getter

- (UISegmentedControl *)headerSegment
{
    if (!_headerSegment)
    {
        _headerSegment = [[UISegmentedControl alloc]init];
        //        _headerSegment.frame = CGRectMake(50 , JSH_StatusBarHeight + 6, SCREEN_WIDTH - 100, 30);
        //添加小按钮
        [_headerSegment insertSegmentWithTitle:@"关注" atIndex:0 animated:YES];
        [_headerSegment insertSegmentWithTitle:@"粉丝" atIndex:1 animated:YES];
        [_headerSegment insertSegmentWithTitle:@"好友" atIndex:2 animated:YES];
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
