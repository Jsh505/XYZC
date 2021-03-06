//
//  ArticleInfoVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ArticleInfoVC.h"
#import "ArticleInfoHeaderView.h"
#import "ArticleInfoCell.h"
#import "ArticleInfoCommentCell.h"
#import "CampusInfoCommentModel.h"
#import "XHInputView.h"
#import "ArticleInfoMoreCell.h"
#import "PersonInfoVC.h"
#import "AllCommentListVC.h"

@interface ArticleInfoVC () <XHInputViewDelagete, ArticleInfoCellDelegate, ArticleInfoCommentCellDelegate>

@property (nonatomic, strong) ArticleInfoHeaderView * headerView;
@property (nonatomic, strong) UIButton * footerButton;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) MyarticleModel * myarticleModel;

@end

@implementation ArticleInfoVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"文章详情";
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(loadData) name:@"campusRefush" object:nil];
    
    [self.view addSubview:self.coustromTableView];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 45)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
    
    [self.view addSubview:self.footerButton];
   
    self.dataSource = [[NSMutableArray alloc] init];
    [self loadData];
    [self loadDetailData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.model.id) forKey:@"articleId"];
    [parametersDic setObject:@(1) forKey:@"type"];
    
    [PPNetworkHelper POST:@"selectCommentByArticleId.app" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"commentList"] count] > 0)
         {
             [self.dataSource removeAllObjects];
             for (NSDictionary * dic in [responseObject objectForKey:@"commentList"])
             {
                 CampusInfoCommentModel * model = [[CampusInfoCommentModel alloc] initWithDictionary:dic];
                 model.secondCommentList = [[NSMutableArray alloc] init];
                 for (NSDictionary * secondCommentList in [dic objectForKey:@"secondCommentList"])
                 {
                     CampusInfoCommentModel * secondModel = [[CampusInfoCommentModel alloc] initWithDictionary:secondCommentList];
                     [model.secondCommentList addObject:secondModel];
                 }
                 [self.dataSource addObject:model];
             }
             [self.coustromTableView reloadData];
         }
     } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
     }];
    
    
}

- (void)loadDetailData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.model.id) forKey:@"articleId"];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    
    [PPNetworkHelper POST:@"queryArticleDetail.app" parameters:parametersDic hudString:nil success:^(id responseObject)
     {
         self.myarticleModel = [[MyarticleModel alloc] initWithDictionary:[responseObject objectForKey:@"articleList"]];
         self.headerView.model = self.myarticleModel;
         self.coustromTableView.tableHeaderView = self.headerView;
         
     } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
     }];
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)guanzhuButtonCilick
{
    //关注
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:@(self.myarticleModel.userId) forKey:@"fansFriendUserId"];
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

- (void)dianzanButtonCilick
{
    //点赞
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:@(self.myarticleModel.id) forKey:@"articleId"];
    
    [PPNetworkHelper POST:@"goodArticle.app" parameters:parametersDic hudString:nil success:^(id responseObject)
     {
         self.headerView.dianzanButton.selected = !self.headerView.dianzanButton.selected;
         if (self.headerView.dianzanButton.selected)
         {
             [self.headerView.dianzanButton setTitle:[NSString stringWithFormat:@"%d",[self.headerView.dianzanButton.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
         }
         else
         {
             [self.headerView.dianzanButton setTitle:[NSString stringWithFormat:@"%d",[self.headerView.dianzanButton.titleLabel.text intValue] - 1] forState:UIControlStateNormal];
         }
     } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
     }];
}

- (void)footerButtonClicked
{
    //评论
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        /** 代理 */
        inputView.delegate = self;
        /** 占位符文字 */
        inputView.placeholder = @"评论:";
        /** 设置最大输入字数 */
        inputView.maxCount = 999;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        /** 更多属性设置,详见XHInputView.h文件 */
    } sendBlock:^BOOL(NSString *text)
     {
         if(text.length)
         {
             NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
             [parametersDic setObject:@(self.myarticleModel.id) forKey:@"articleId"];
             [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
             [parametersDic setObject:text forKey:@"commentContent"];
             [parametersDic setObject:@(1) forKey:@"type"];
             
             [PPNetworkHelper POST:@"addComment.app" parameters:parametersDic hudString:@"评论中..." success:^(id responseObject)
              {
                  [MBProgressHUD showInfoMessage:@"评论成功"];
                  [self loadData];
              } failure:^(NSString *error) {
                  [MBProgressHUD showErrorMessage:error];
              }];
             return YES;//return YES,收起键盘
         }
         else
         {
             [MBProgressHUD showInfoMessage:@"评论内容不能为空"];
             return NO;//return NO,不收键盘
         }
     }];
}

- (void)headerImageViewCilickWithModel:(CampusInfoCommentModel *)model
{
    //点击头像
    CampusInfoCommentModel * newModel = (CampusInfoCommentModel *)model;
    PersonInfoVC * vc =  [[PersonInfoVC alloc] init];
    vc.userId = newModel.userId;
    vc.customNavBar.title = newModel.nickName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentButtonCilickWithModel:(CampusInfoCommentModel *)model
{
    CampusInfoCommentModel * newModel = (CampusInfoCommentModel *)model;
    //平路别人的评论
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        
        /** 代理 */
        inputView.delegate = self;
        
        /** 占位符文字 */
        inputView.placeholder = [NSString stringWithFormat:@"评论%@:",newModel.nickName];
        /** 设置最大输入字数 */
        inputView.maxCount = 999;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text)
     {
         if(text.length)
         {
             NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
             [parametersDic setObject:@(self.myarticleModel.id) forKey:@"articleId"];
             [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
             [parametersDic setObject:text forKey:@"commentContent"];
             [parametersDic setObject:@(newModel.id) forKey:@"commentId"];
             [parametersDic setObject:@(1) forKey:@"type"];
             
             [PPNetworkHelper POST:@"addComment.app" parameters:parametersDic hudString:@"评论中..." success:^(id responseObject)
              {
                  [MBProgressHUD showInfoMessage:@"评论成功"];
                  [self loadData];
              } failure:^(NSString *error) {
                  [MBProgressHUD showErrorMessage:error];
              }];
             return YES;//return YES,收起键盘
         }
         else
         {
             [MBProgressHUD showInfoMessage:@"评论内容不能为空"];
             return NO;//return NO,不收键盘
         }
     }];
}

- (void)commentNameLBCilickWithModel:(BaseModel *)model
{
    //点击评论人的昵称
    CampusInfoCommentModel * newModel = (CampusInfoCommentModel *)model;
    PersonInfoVC * vc =  [[PersonInfoVC alloc] init];
    vc.userId = newModel.userId;
    vc.customNavBar.title = newModel.nickName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)

#pragma mark - XHInputViewDelagete
/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
    
    //[IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //[IQKeyboardManager sharedManager].enable = NO;
    
}

/** XHInputView 将要影藏 */
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
    
    //[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    //[IQKeyboardManager sharedManager].enable = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CampusInfoCommentModel * model = self.dataSource[section];
    if (model.secondCommentList.count > 2)
    {
        return 4;
    }
    else
    {
        return 1 + model.secondCommentList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 90;
        return tableView.rowHeight;
    }
    else if (indexPath.row == 3)
    {
        return 30;
    }
    else
    {
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 20;
        return tableView.rowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ArticleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleInfoCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ArticleInfoCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.campusInfoModel = self.dataSource[indexPath.section];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        ArticleInfoMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleInfoMoreCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ArticleInfoMoreCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        ArticleInfoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleInfoCommentCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ArticleInfoCommentCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CampusInfoCommentModel * model = self.dataSource[indexPath.section];
        cell.delegate = self;
        cell.model = model.secondCommentList[indexPath.row - 1];
        return cell;
    }
    
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        CampusInfoCommentModel * model = self.dataSource[indexPath.section];
        AllCommentListVC * vc = [[AllCommentListVC alloc] init];
        vc.model = model;
        vc.type = 1;
        vc.articleId = self.myarticleModel.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//属性字符串
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"";
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
}


#pragma mark - Setter/Getter

- (ArticleInfoHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [ArticleInfoHeaderView loadViewFromXIB];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.text = self.model.content;
        textLabel.numberOfLines = 0;//根据最大行数需求来设置
        textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 20, 9999);//labelsize的最大值
        //关键语句
        CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 200 / 375 + 165 + expectSize.height);
        
//        _headerView.model = self.myarticleModel;
        [_headerView.guanzhuButton addTarget:self action:@selector(guanzhuButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.dianzanButton addTarget:self action:@selector(dianzanButtonCilick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UIButton *)footerButton
{
    if (!_footerButton)
    {
        _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerButton.frame = CGRectMake(0, SCREEN_HEIGHT - JSH_SafeBottomMargin - 45, SCREEN_WIDTH, 45);
        _footerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_footerButton setTitle:@"发布评论" forState: UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _footerButton.backgroundColor = [UIColor mainColor];
        [_footerButton addTarget:self action:@selector(footerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}

@end
