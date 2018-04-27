//
//  PersonInfoVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "PersonInfoVC.h"
#import "ArticleListCell.h"
#import "ArticlPersonInfoHeaderView.h"
#import "ChoseLabelView.h"
#import "PersonsFansListVC.h"
#import "FindTrainModel.h"
#import "PopoverView.h"
#import "GiftLabelVC.h"
#import "MyarticleModel.h"

@interface PersonInfoVC () <ArticleListCellDelegate, ChoseLabelViewDelegate>
{
    NSString * _phone;
}

@property (nonatomic, strong) ArticlPersonInfoHeaderView * headerView;
@property (nonatomic, strong) ChoseLabelView * choseLabelView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation PersonInfoVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.coustromTableView];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.coustromTableView.tableHeaderView = self.headerView;
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:@(self.userId) forKey:@"articleUserId"];
    
    [PPNetworkHelper POST:@"queryUserInfoFromArticle.app" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
     {
//         MyarticleModel * model = [[MyarticleModel alloc] initWithDictionary:[responseObject objectForKey:@"selfInfo"]];
//         self.headerView.model = model;
         _phone = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"selfInfo"] objectForKey:@"phone"]];
         self.headerView.userNameLB.text = [[responseObject objectForKey:@"selfInfo"] objectForKey:@"name"];

//         [self.headerView.headerImageView jsh_sdsetImageWithURL:[[responseObject objectForKey:@"selfInfo"] objectForKey:@"backgroundMap"] placeholderImage:Default_General_Image];
         [self.headerView.userHeaderImageView jsh_sdsetImageWithHeaderimg:[[responseObject objectForKey:@"selfInfo"] objectForKey:@"pictureName"]];

         self.headerView.schoolLB.text = [NSString stringWithFormat:@"%@ %@",[[responseObject objectForKey:@"selfInfo"] objectForKey:@"colleges"],[[responseObject objectForKey:@"selfInfo"] objectForKey:@"grade"]];

         if ([NSString is_NulllWithObject:[[responseObject objectForKey:@"otherInfo"] objectForKey:@"labelPicName"]])
         {
             self.headerView.labelmageView.image = [UIImage imageNamed:@"0标签"];
         }
         else
         {
             self.headerView.labelmageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@标签",[[responseObject objectForKey:@"otherInfo"] objectForKey:@"labelPicName"]]];
         }
         
         self.headerView.labelLB.text = [[responseObject objectForKey:@"otherInfo"] objectForKey:@"labelName"];
         
         self.headerView.fansLB.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"otherInfo"] objectForKey:@"fansNumber"]];
         self.headerView.guanzhuLB.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"otherInfo"] objectForKey:@"focusNumber"]];
         self.headerView.wenzhangLB.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"otherInfo"] objectForKey:@"articleNumbers"]];
         
         if ([[[responseObject objectForKey:@"otherInfo"] objectForKey:@"isFocus"] intValue] == 1)
         {
             self.headerView.guanzhuButton.selected = YES;
         }
         self.headerView.infoLB.text = [[responseObject objectForKey:@"selfInfo"] objectForKey:@"perSignature"];
         
         if ([[[responseObject objectForKey:@"selfInfo"] objectForKey:@"gender"] isEqualToString:@"男"])
         {
             self.headerView.grdenImageView.image = [UIImage imageNamed:@"文章个人性别男"];
         }
         else
         {
             self.headerView.grdenImageView.image = [UIImage imageNamed:@"文章个人性别女"];
         }
         
         [self.dataSource removeAllObjects];
         for (NSDictionary *dic in [responseObject objectForKey:@"articleList"])
         {
             PersonArticleModel * model = [[PersonArticleModel alloc] initWithDictionary:dic];
             [self.dataSource addObject:model];
         }
         [self.coustromTableView reloadData];
         
     } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
     }];
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)sendMessageButtonCilick
{
    //消息
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:_phone conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)guanzhuButtonCilick
{
    //关注
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:@(self.userId) forKey:@"fansFriendUserId"];
    [parametersDic setObject:@(2) forKey:@"type"];
    
    [PPNetworkHelper POST:@"addFansOrFriends.app" parameters:parametersDic hudString:@"加好友..." success:^(id responseObject)
     {
         [MBProgressHUD showInfoMessage:@"操作成功"];
         self.headerView.guanzhuButton.selected = !self.headerView.guanzhuButton.selected;
     } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
     }];
}

- (void)labelmageViewSingleTap
{
    //选择标签弹窗
    [self.choseLabelView showWithView:self.view];
}

- (void)fansButtonCilick
{
    //粉丝
    PersonsFansListVC * vc = [[PersonsFansListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

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

- (void)giftButtonCilick
{
    //赠送标签
    GiftLabelVC * vc = [[GiftLabelVC alloc] init];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreButton:(UIButton *)button
{
    //更多操作
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    [popoverView showToView:button withActions:[self QQActions]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 40)];
    lineView.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    label.text = @"文章精选";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [lineView addSubview:label];
    
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
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
    cell.personArticleModel = self.dataSource[indexPath.row];
    return cell;
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Setter/Getter

- (ArticlPersonInfoHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [ArticlPersonInfoHeaderView loadViewFromXIB];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 150 / 375 + 265);
        _headerView.labelmageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelmageViewSingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_headerView.labelmageView addGestureRecognizer:singleRecognizer];
        
        [_headerView.sendMessageButton addTarget:self action:@selector(sendMessageButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.guanzhuButton addTarget:self action:@selector(guanzhuButtonCilick) forControlEvents:UIControlEventTouchUpInside];
//        [_headerView.fansButton addTarget:self action:@selector(fansButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headerView;
}

- (ChoseLabelView *)choseLabelView
{
    if (!_choseLabelView)
    {
        _choseLabelView = [[ChoseLabelView alloc] initWithFrame:self.view.bounds];
        _choseLabelView.userId = self.userId;
        _choseLabelView.delegate = self;
        _choseLabelView.titleLB.text = [NSString stringWithFormat:@"%@的标签",self.customNavBar.title];
    }
    return _choseLabelView;
}

@end
