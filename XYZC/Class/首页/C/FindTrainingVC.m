//
//  FindTrainingVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/8.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "FindTrainingVC.h"
#import "FindTrainingMainCell.h"
#import "FindTrainingTimeCell.h"
#import "FindTrainingInfoCell.h"
#import "JobInfoCell.h"
#import "PopoverView.h"
#import "FindTrainModel.h"


@interface FindTrainingVC () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * rightBarButton;
@property (nonatomic, strong) UISegmentedControl   *headerSegment;
@property (nonatomic, strong) UIScrollView         *contentScrollview;
@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UITableView * rightCoustromTableView;
@property (nonatomic, strong) FindTrainModel * dataModel;

@end

@implementation FindTrainingVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.customNavBar sd_addSubviews:@[self.headerSegment, self.rightBarButton]];
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 0)
    .heightIs(44)
    .widthRatioToView(self.view, 0.2)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
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
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight);
    
    self.coustromTableView.tableFooterView = self.footerView;
    
    [self loadData];
}
- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.id) forKey:@"id"];
    
    [PPNetworkHelper POST:@"cultivateById.app" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
    {
        self.dataModel = [[FindTrainModel alloc] initWithDictionary:[responseObject objectForKey:@"cultivateList"][0]];
        [self.coustromTableView reloadData];
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
}

- (void)onlineButtonClicked
{
    //在线咨询
}

- (void)phoneButtonClicked
{
    //电话咨询
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)rightBarButtonClicked
{
    //更多
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    [popoverView showToView:self.rightBarButton withActions:[self QQActions]];
}

- (NSArray<PopoverAction *> *)QQActions
{
    PopoverAction *sharAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"分享"] title:@"分享" handler:^(PopoverAction *action)
                                      {

                                      }];
    
    PopoverAction *tousuFriAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"投诉"] title:@"投诉" handler:^(PopoverAction *action)
                                   {
                                       
                                   }];
    NSArray * array = @[sharAction,tousuFriAction];
    return array;
}

#pragma mark - Deletate/DataSource (相关代理)
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollview)
    {
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger ratio = round(offSetX / SCREEN_WIDTH);
        self.headerSegment.selectedSegmentIndex = ratio;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.coustromTableView)
    {
        return 4;
    }
    else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.coustromTableView)
    {
        if (indexPath.row == 0)
        {
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 330;
            return tableView.rowHeight;
        }
        else if (indexPath.row == 1)
        {
            return 95;
        }
        else
        {
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 50;
            return tableView.rowHeight;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.estimatedRowHeight = 50;
            return tableView.rowHeight;
        }
        else
        {
            return 175;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.coustromTableView)
    {
        if (indexPath.row == 0)
        {
            FindTrainingMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTrainingMainCellident"];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"FindTrainingMainCell" owner:nil options:nil];
                cell = array[0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.model = self.dataModel;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            FindTrainingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTrainingTimeCellident"];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"FindTrainingTimeCell" owner:nil options:nil];
                cell = array[0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.shangkeStartTimeLB.text = self.dataModel.startDate;
            cell.shangkeStartLB.text = [NSString stringWithFormat:@"%@-%@ 午休：%@-%@",self.dataModel.attendClassStartTime,self.dataModel.attendClassEndTime,self.dataModel.siestaStartTime,self.dataModel.siestaEndTime];
            return cell;
        }
        else
        {
            FindTrainingInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindTrainingInfoCellident"];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"FindTrainingInfoCell" owner:nil options:nil];
                cell = array[0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row == 2)
            {
                cell.tyoeLB.text = @"培训内容";
                cell.infoLB.text = self.dataModel.trainingContent;
            }
            else
            {
                cell.tyoeLB.text = @"师资力量";
                cell.infoLB.text = self.dataModel.teacherStrength;
            }
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            JobInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobInfoCellident"];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"JobInfoCell" owner:nil options:nil];
                cell = array[0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.titleLB.text = self.dataModel.companyName;
            cell.infoLB.text = self.dataModel.companyInfo;
            return cell;
        }
        else
        {
            FindTrainingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobFindTrainingTimeCellident"];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"FindTrainingTimeCell" owner:nil options:nil];
                cell = array[2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.phoneLB.text = self.dataModel.phone;
            return cell;
        }
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
        [_headerSegment insertSegmentWithTitle:@"培训" atIndex:0 animated:YES];
        [_headerSegment insertSegmentWithTitle:@"机构" atIndex:1 animated:YES];
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
        _contentScrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight);
        [_contentScrollview addSubview:self.coustromTableView];
        [_contentScrollview addSubview:self.rightCoustromTableView];
    }
    return _contentScrollview;
}

- (UITableView *)coustromTableView
{
    if (!_coustromTableView)
    {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableView;
}

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setImage:[UIImage imageNamed:@"右键_更多"] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _footerView.backgroundColor = [UIColor backgroudColor];
        
        UIButton * onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        onlineButton.frame = CGRectMake(15, 8, (SCREEN_WIDTH - 45) * 0.4, 44);
        [onlineButton setTitle:@"在线咨询" forState: UIControlStateNormal];
        onlineButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [onlineButton setTitleColor:[UIColor colorWithHexString:@"FFD400"] forState:UIControlStateNormal];
        onlineButton.layer.cornerRadius = 3;
        onlineButton.layer.borderColor = [UIColor colorWithHexString:@"FFD400"].CGColor;
        onlineButton.layer.borderWidth = 1;
        [onlineButton addTarget:self action:@selector(onlineButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:onlineButton];
        
        UIButton * phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneButton.frame = CGRectMake((SCREEN_WIDTH - 45) * 0.4 + 30, 8, (SCREEN_WIDTH - 45) * 0.6, 44);
        [phoneButton setTitle:@"电话咨询" forState: UIControlStateNormal];
        phoneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneButton.backgroundColor = [UIColor colorWithHexString:@"16BF3E"];
        phoneButton.layer.cornerRadius = 3;
        [phoneButton addTarget:self action:@selector(phoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:phoneButton];
        
    }
    return _footerView;
}

- (UITableView *)rightCoustromTableView
{
    if (!_rightCoustromTableView)
    {
        _rightCoustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight) style:UITableViewStylePlain];
        _rightCoustromTableView.delegate = self;
        _rightCoustromTableView.dataSource = self;
        _rightCoustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightCoustromTableView.showsVerticalScrollIndicator = NO;
        _rightCoustromTableView.showsHorizontalScrollIndicator = NO;
    }
    return _rightCoustromTableView;
}

@end
