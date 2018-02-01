//
//  AllCommentListVC.m
//  XYZC
//
//  Created by 贾仕海 on 2018/2/1.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "AllCommentListVC.h"
#import "XHInputView.h"
#import "AllCommentCell.h"

@interface AllCommentListVC () <XHInputViewDelagete>

@property (nonatomic, strong) UIButton * footerButton;

@end

@implementation AllCommentListVC

#pragma mark - Lifecycle(生命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"评论详情";
    
    [self.view addSubview:self.coustromTableView];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 45)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
    
    [self.view addSubview:self.footerButton];
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)footerButtonClicked
{
    //评论
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        
        /** 代理 */
        inputView.delegate = self;
        
        /** 占位符文字 */
        inputView.placeholder = [NSString stringWithFormat:@"评论%@:",self.model.nickName];
        /** 设置最大输入字数 */
        inputView.maxCount = 9999;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text)
     {
         if(text.length)
         {
             NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
             [parametersDic setObject:@(self.model.id) forKey:@"campusArtId"];
             [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
             [parametersDic setObject:text forKey:@"commentContent"];
             [parametersDic setObject:@(self.model.commentId) forKey:@"commentId"];
             
             [PPNetworkHelper POST:@"addCampusArtComment" parameters:parametersDic hudString:@"评论中..." success:^(id responseObject)
              {
                  [MBProgressHUD showInfoMessage:@"评论成功"];
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

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + self.model.secondCommentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 110;
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCommentCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"AllCommentCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0)
    {
        cell.model = self.model;
    }
    else
    {
        cell.model = self.model.secondCommentList[indexPath.row - 1];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Setter/Getter

- (UIButton *)footerButton
{
    if (!_footerButton)
    {
        _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerButton.frame = CGRectMake(0, SCREEN_HEIGHT - JSH_SafeBottomMargin - 45, SCREEN_WIDTH, 45);
        _footerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_footerButton setTitle:@"评论" forState: UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _footerButton.backgroundColor = [UIColor mainColor];
        [_footerButton addTarget:self action:@selector(footerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}


@end
