//
//  MyVc.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "MyVC.h"
#import "MessageHomeVC.h"
#import "SetVC.h"
#import "PersonalInformationTVC.h"
#import "MyApplyVC.h"
#import "MyPointsVC.h"
#import "MyFriendVC.h"
#import "MyArticleVC.h"
#import "AboutVC.h"
#import "FeedbackVC.h"
#import "MyWalletVC.h"
#import "MyResumeVC.h"

@interface MyVC ()

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIButton * messageButton;
@property (nonatomic, strong) UIImageView * headerImage;
@property (nonatomic, strong) UILabel * nameLB;
@property (nonatomic, strong) UIImageView * grdenImageView;
@property (nonatomic, strong) UILabel * infoLB;
@property (weak, nonatomic) IBOutlet UILabel *friendsInfoLB;

@end

@implementation MyVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 设置tableView的内边距(能够显示出导航栏和tabBar下覆盖的内容)
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, JSH_TabBarHeight, 0);
    // 设置内容指示器(滚动条)的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.headerImage jsh_sdsetImageWithHeaderimg:[UserSignData share].user.userInfo.pictureName];
    self.nameLB.text = [NSString is_NulllWithObject:[UserSignData share].user.userInfo.name] ? [UserSignData share].user.username : [UserSignData share].user.userInfo.name;
    self.grdenImageView.image = [[UserSignData share].user.userInfo.gender isEqualToString:@"女"] ? [UIImage imageNamed:@"性别_女"] : [UIImage imageNamed:@"性别_男"];
    self.infoLB.text = [NSString stringWithFormat:@"%@ 无参数 %@",[NSString is_NulllWithObject:[UserSignData share].user.userInfo.colleges] ? @"未设置" : [UserSignData share].user.userInfo.colleges,
                                                            [NSString is_NulllWithObject:[UserSignData share].user.userInfo.grade] ? @"未设置" : [UserSignData share].user.userInfo.grade];
    self.friendsInfoLB.text = @"0粉丝·0关注·0好友";
    [self loadFansNumber];
    
}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}


- (void)loadFansNumber
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    
    [PPNetworkHelper POST:@"fansAndFocusFriends.app" parameters:parametersDic hudString:nil success:^(id responseObject)
    {
        
        self.friendsInfoLB.text = [NSString stringWithFormat:@"%@粉丝·%@关注·%@好友",[[responseObject objectForKey:@"fansAndFocusMap"][0] objectForKey:@"fans"],
                                                                                [[responseObject objectForKey:@"fansAndFocusMap"][0] objectForKey:@"focus"],
                                                                                [[responseObject objectForKey:@"fansAndFocusMap"][0] objectForKey:@"friends"]];
    } failure:^(NSString *error)
    {
    }];
}
#pragma mark - Custom Accessors (控件响应方法)

- (void)setButtonClicked
{
    //设置
    SetVC * vc = [[SetVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageButtonClicked
{
    //消息
    MessageHomeVC * vc = [[MessageHomeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerViewSingleTap
{
    //个人信息
    PersonalInformationTVC * vc = [[UIStoryboard storyboardWithName:@"PersonalInformationTVC" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalInformationTVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)

#pragma mark - Deletate/DataSource (相关代理)

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark --UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    if (sec == 0 && row == 0)
    {
        //我的简历
        MyResumeVC * vc = [[MyResumeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 0 && row == 1)
    {
        //我的申请
        MyApplyVC * vc = [[MyApplyVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 1 && row == 0)
    {
        //积分
        MyPointsVC * vc = [[MyPointsVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 1 && row == 1)
    {
        //好友
        MyFriendVC * vc = [[MyFriendVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 1 && row == 2)
    {
        //我的文章
        MyArticleVC * vc = [[MyArticleVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 1 && row == 3)
    {
        //我的钱包
        MyWalletVC * vc = [[MyWalletVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 2 && row == 0)
    {
        //关于
        AboutVC * vc = [[AboutVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 2 && row == 1)
    {
        //反馈
        FeedbackVC * vc = [[FeedbackVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - Setter/Getter

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"484848"];
        
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewSingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_headerView addGestureRecognizer:singleRecognizer];
        
        UIView * navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, JSH_NavbarAndStatusBarHeight)];
        navBarView.backgroundColor = [UIColor mainColor];
        [_headerView addSubview:navBarView];
        
        UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, JSH_StatusBarHeight, 100, JSH_NavBarHeight)];
        titleLB.text = @"个人中心";
        titleLB.textAlignment = NSTextAlignmentLeft;
        titleLB.textColor = [UIColor blackColor];
        titleLB.font = [UIFont systemFontOfSize:17];
        [navBarView addSubview:titleLB];
        
        [navBarView addSubview:self.messageButton];
        
        UIButton * setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        setButton.frame = CGRectMake(SCREEN_WIDTH - JSH_NavBarHeight, JSH_StatusBarHeight, JSH_NavBarHeight, JSH_NavBarHeight);
        [setButton setImage:[UIImage imageNamed:@"我的_设置"] forState:UIControlStateNormal];
        [setButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        setButton.backgroundColor = [UIColor clearColor];
        [setButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [navBarView addSubview:setButton];
        
        [_headerView sd_addSubviews:@[self.headerImage, self.nameLB, self.grdenImageView, self.infoLB]];
        
        self.headerImage.sd_layout
        .centerXIs(SCREEN_WIDTH / 2)
        .topSpaceToView(navBarView, -10)
        .widthIs(60)
        .heightIs(60);
        
        self.nameLB.sd_layout
        .centerXIs(SCREEN_WIDTH / 2 - 5)
        .topSpaceToView(self.headerImage, 5)
        .autoWidthRatio(0)
        .heightIs(20);
        [self.nameLB setSingleLineAutoResizeWithMaxWidth:180];
        
        self.grdenImageView.sd_layout
        .centerYEqualToView(self.nameLB)
        .leftSpaceToView(self.nameLB, 3)
        .widthIs(17)
        .heightIs(17);
        
        self.infoLB.sd_layout
        .centerXIs(SCREEN_WIDTH / 2)
        .topSpaceToView(self.nameLB, 5)
        .autoWidthRatio(0)
        .heightIs(20);
        [self.infoLB setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return _headerView;
}

- (UIButton *)messageButton
{
    if (!_messageButton)
    {
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageButton.frame = CGRectMake(SCREEN_WIDTH - JSH_NavBarHeight * 2, JSH_StatusBarHeight, JSH_NavBarHeight, JSH_NavBarHeight);
        [_messageButton setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
        [_messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _messageButton.backgroundColor = [UIColor clearColor];
        [_messageButton addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

- (UIImageView *)headerImage
{
    if (!_headerImage)
    {
        _headerImage = [[UIImageView alloc] init];
        _headerImage.image = [UIImage imageNamed:@"头像"];
        _headerImage.layer.cornerRadius = 30;
        _headerImage.layer.masksToBounds = YES;
        _headerImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _headerImage.layer.borderWidth = 2;
    }
    return _headerImage;
}

- (UILabel *)nameLB
{
    if (!_nameLB)
    {
        _nameLB = [[UILabel alloc] init];
        _nameLB.text = @"昵称";
        _nameLB.textAlignment = NSTextAlignmentCenter;
        _nameLB.textColor = [UIColor mainColor];
        _nameLB.font = [UIFont systemFontOfSize:17];
    }
    return _nameLB;
}

- (UIImageView *)grdenImageView
{
    if (!_grdenImageView)
    {
        _grdenImageView = [[UIImageView alloc] init];
        _grdenImageView.image = [UIImage imageNamed:@"性别_女"];
    }
    return _grdenImageView;
}

- (UILabel *)infoLB
{
    if (!_infoLB)
    {
        _infoLB = [[UILabel alloc] init];
        _infoLB.text = @"西安大学 中文系 2019届";
        _infoLB.textAlignment = NSTextAlignmentCenter;
        _infoLB.textColor = [UIColor whiteColor];
        _infoLB.font = [UIFont systemFontOfSize:14];
    }
    return _infoLB;
}


@end
