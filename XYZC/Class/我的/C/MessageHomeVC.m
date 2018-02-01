//
//  MessageHomeVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/2.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MessageHomeVC.h"
#import "MessageCell.h"
#import "YUSegment.h"
#import "MessageNotifCommentCell.h"

@interface MessageHomeVC () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    //原来的页码
    NSUInteger _oldPage;
}

@property (nonatomic, strong) UISegmentedControl   *headerSegment;
@property (nonatomic, strong) UIScrollView         *contentScrollview;
@property (nonatomic, strong) UITableView * coustromTableViewOfMessage;

@property (nonatomic, strong) UIView * notifBackgroundView;
@property (nonatomic, strong) YUSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView         *contentScrollviewOfNotif;
@property (nonatomic, strong) UITableView * coustromTableViewOfNotifComment;
@property (nonatomic, strong) UITableView * coustromTableViewOfNotifFriend;
@property (nonatomic, strong) UITableView * coustromTableViewOfNotifFans;

@end

@implementation MessageHomeVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _oldPage = 0;
    [self creatMessageView];
}

#pragma mark - Custom Accessors (控件响应方法)

-(void)segCChanged:(UISegmentedControl*)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    CGRect frame = self.contentScrollview.frame;
    frame.origin.x = index * CGRectGetWidth(self.contentScrollview.frame);
    frame.origin.y = 0;
    [self.contentScrollview scrollRectToVisible:frame animated:YES];
}

- (void)segmentedControlTapped:(YUSegmentedControl *)sender
{
    //类型选择
    NSInteger index = sender.selectedSegmentIndex;
    CGRect frame = self.contentScrollviewOfNotif.frame;
    frame.origin.x = index * CGRectGetWidth(self.contentScrollviewOfNotif.frame);
    frame.origin.y = 0;
    [self.contentScrollviewOfNotif scrollRectToVisible:frame animated:YES];
    _oldPage = index;
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)creatMessageView
{
    [self.customNavBar sd_addSubviews:@[self.headerSegment]];
    
    self.headerSegment.sd_layout
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight + 6)
    .centerXIs(SCREEN_WIDTH / 2)
    .widthIs(150)
    .heightIs(30);
    
    [self.headerSegment setSelectedSegmentIndex:0];
    
    [self.view addSubview:self.contentScrollview];
    
    self.contentScrollview.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .leftSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight);
}


#pragma mark - Deletate/DataSource (相关代理)

#pragma mark - Scrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollview)
    {
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger ratio = round(offSetX / SCREEN_WIDTH);
        self.headerSegment.selectedSegmentIndex = ratio;
    }
    else if (scrollView == self.contentScrollviewOfNotif)
    {
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger ratio = round(offSetX / SCREEN_WIDTH);
        
        [self.segmentedControl segmentDidSelectAtIndex:ratio didDeselectAtIndex:_oldPage];
        if (_oldPage < ratio)
        {
            _oldPage ++;
        }
        else if (_oldPage > ratio)
        {
            _oldPage --;
        }
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.coustromTableViewOfMessage)
    {
        return 3;
    }
    else if (tableView == self.coustromTableViewOfNotifComment)
    {
        return 3;
    }
    else if (tableView == self.coustromTableViewOfNotifFriend)
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
    if (tableView == self.coustromTableViewOfMessage)
    {
        return 90;
    }
    else if (tableView == self.coustromTableViewOfNotifComment)
    {
        return 190;
    }
    else if (tableView == self.coustromTableViewOfNotifFriend)
    {
        return 190;
    }
    else
    {
        return 190;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _coustromTableViewOfMessage)
    {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MessageCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageNotifCommentCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MessageNotifCommentCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
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
        [_headerSegment insertSegmentWithTitle:@"消息" atIndex:0 animated:YES];
        [_headerSegment insertSegmentWithTitle:@"通知" atIndex:1 animated:YES];
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
        _contentScrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight);
        
        [_contentScrollview addSubview:self.coustromTableViewOfMessage];
        [_contentScrollview addSubview:self.notifBackgroundView];
    }
    return _contentScrollview;
}

- (UITableView *)coustromTableViewOfMessage
{
    if (!_coustromTableViewOfMessage)
    {
        _coustromTableViewOfMessage = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight) style:UITableViewStylePlain];
        _coustromTableViewOfMessage.delegate = self;
        _coustromTableViewOfMessage.dataSource = self;
        _coustromTableViewOfMessage.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableViewOfMessage.showsVerticalScrollIndicator = NO;
        _coustromTableViewOfMessage.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableViewOfMessage;
}

- (UIView *)notifBackgroundView
{
    if (!_notifBackgroundView)
    {
        _notifBackgroundView =[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight)];
        _notifBackgroundView.backgroundColor = [UIColor whiteColor];
        
        [_notifBackgroundView addSubview:self.segmentedControl];
        [_notifBackgroundView addSubview:self.contentScrollviewOfNotif];
    }
    return _notifBackgroundView;
}

- (YUSegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        _segmentedControl = [[YUSegmentedControl alloc] initWithTitles:@[@"评论", @"好友", @"粉丝"]];
        _segmentedControl.indicator.locate = YUSegmentedControlIndicatorLocateBottom;
        _segmentedControl.backgroundColor = [UIColor mainColor];
        _segmentedControl.frame = CGRectMake(0, -1, SCREEN_WIDTH, 41);
        _segmentedControl.indicator.backgroundColor = [UIColor blackColor];
        [_segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIScrollView *)contentScrollviewOfNotif
{
    if (!_contentScrollviewOfNotif)
    {
        _contentScrollviewOfNotif = [[UIScrollView alloc] init];
        [_contentScrollviewOfNotif setFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 40)];
        _contentScrollviewOfNotif.pagingEnabled = YES;
        _contentScrollviewOfNotif.delegate = self;
        _contentScrollviewOfNotif.showsHorizontalScrollIndicator = NO;
        _contentScrollviewOfNotif.bounces = false;
        //方向锁
        _contentScrollviewOfNotif.directionalLockEnabled = YES;
        //取消自动布局
        self.automaticallyAdjustsScrollViewInsets = NO;
        //为scrollview设置大小  需要计算调整
        _contentScrollviewOfNotif.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight - 40);
        
        [_contentScrollviewOfNotif addSubview:self.coustromTableViewOfNotifComment];
        [_contentScrollviewOfNotif addSubview:self.coustromTableViewOfNotifFriend];
        [_contentScrollviewOfNotif addSubview:self.coustromTableViewOfNotifFans];
        
        
    }
    return _contentScrollviewOfNotif;
}

- (UITableView *)coustromTableViewOfNotifComment
{
    if (!_coustromTableViewOfNotifComment)
    {
        _coustromTableViewOfNotifComment = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight - 40) style:UITableViewStylePlain];
        _coustromTableViewOfNotifComment.delegate = self;
        _coustromTableViewOfNotifComment.dataSource = self;
        _coustromTableViewOfNotifComment.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableViewOfNotifComment.showsVerticalScrollIndicator = NO;
        _coustromTableViewOfNotifComment.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableViewOfNotifComment;
}

- (UITableView *)coustromTableViewOfNotifFriend
{
    if (!_coustromTableViewOfNotifFriend)
    {
        _coustromTableViewOfNotifFriend = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight - 40) style:UITableViewStylePlain];
        _coustromTableViewOfNotifFriend.delegate = self;
        _coustromTableViewOfNotifFriend.dataSource = self;
        _coustromTableViewOfNotifFriend.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableViewOfNotifFriend.showsVerticalScrollIndicator = NO;
        _coustromTableViewOfNotifFriend.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableViewOfNotifFriend;
}

- (UITableView *)coustromTableViewOfNotifFans
{
    if (!_coustromTableViewOfNotifFans)
    {
        _coustromTableViewOfNotifFans = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight - 40) style:UITableViewStylePlain];
        _coustromTableViewOfNotifFans.delegate = self;
        _coustromTableViewOfNotifFans.dataSource = self;
        _coustromTableViewOfNotifFans.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableViewOfNotifFans.showsVerticalScrollIndicator = NO;
        _coustromTableViewOfNotifFans.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableViewOfNotifFans;
}

@end
