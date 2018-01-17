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

@interface PersonInfoVC ()

@property (nonatomic, strong) ArticlPersonInfoHeaderView * headerView;
@property (nonatomic, strong) ChoseLabelView * choseLabelView;

@end

@implementation PersonInfoVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"XXXX";
    
    [self.view addSubview:self.coustromTableView];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
    
    self.coustromTableView.tableHeaderView = self.headerView;
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)labelmageViewSingleTap
{
    //选择标签
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


#pragma mark - Deletate/DataSource (相关代理)

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
    return 3;
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
        [_headerView.fansButton addTarget:self action:@selector(fansButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headerView;
}

- (ChoseLabelView *)choseLabelView
{
    if (!_choseLabelView)
    {
        _choseLabelView = [[ChoseLabelView alloc] initWithFrame:self.view.bounds];
    }
    return _choseLabelView;
}

@end
