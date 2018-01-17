//
//  MyResumeVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/11.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyResumeVC.h"
#import "MyResumeHeaderCell.h"
#import "MyResumeEducationCell.h"
#import "MyResumeWorkCell.h"
#import "MyResumeCertificateCell.h"
#import "MyResumeEvaluateCell.h"
#import "PersonalInformationTVC.h"
#import "AddEducationVC.h"
#import "AddWorkVC.h"
#import "AddCertificateVC.h"
#import "EditEvaluateVC.h"

@interface MyResumeVC () <UITableViewDelegate, UITableViewDataSource, MyResumeHeaderCellDelegate>
{
    BOOL _isHaveResume;  //有无简历
}

@property (nonatomic, strong) UIButton * rightBarButton;
@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) NSDictionary * resumeData;

@end

@implementation MyResumeVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(loadData) name:@"MyResumeRefshData" object:nil];
    self.customNavBar.title = @"我的简历";
    
    _isHaveResume = NO;
    [self.view addSubview:self.coustromTableView];
    
    [self.customNavBar sd_addSubviews:@[self.rightBarButton]];
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 0)
    .heightIs(44)
    .widthRatioToView(self.view, 0.2)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    
    [PPNetworkHelper POST:@"queryResumeByUserId.app" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
    {
        _isHaveResume = YES;
        [UserSignData share].user.userInfo = [[UserInfoModel alloc] initWithDictionary:[[responseObject objectForKey:@"resume"] objectForKey:@"selfInfo"]];
        [[UserSignData share] storageData:[UserSignData share].user];
        self.resumeData = [[NSDictionary alloc] initWithDictionary:[responseObject objectForKey:@"resume"]];
        [self.coustromTableView reloadData];
        
    } failure:^(NSString *error)
    {
        _isHaveResume = NO;
    }];
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)headerButtonClicked:(UIButton *)send
{
    //点击头部添加按钮
    switch (send.tag - 100) {
        case 1:
        {
            //教育经历
            AddEducationVC * vc = [[AddEducationVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            //工作经历
            AddWorkVC * vc = [[AddWorkVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            //技能证书
            AddCertificateVC * vc = [[AddCertificateVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            //自我评价
            EditEvaluateVC * vc = [[EditEvaluateVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)rightBarButtonClicked
{
    //预览
}

#pragma mark - Deletate/DataSource (相关代理)

- (void)editButton
{
    //个人资料
    PersonalInformationTVC * vc = [[UIStoryboard storyboardWithName:@"PersonalInformationTVC" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalInformationTVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * titleArray = @[@"教育经历",@"工作经历",@"技能/证书"];
    if (section != 0)
    {
        if (section == 4)
        {
            //自我评价
            UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
            headerView.backgroundColor = [UIColor whiteColor];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            lineView.backgroundColor = [UIColor backgroudColor];
            [headerView addSubview:lineView];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 45)];
            label.text = @"自我评价";
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor colorWithHexString:@"FF7B2E"];
            label.font = [UIFont systemFontOfSize:17];
            [headerView addSubview:label];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake( SCREEN_WIDTH - 60, 10, 60, 45);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:@"编辑" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"修改简历"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"FF7B2E"] forState:UIControlStateNormal];
            button.contentMode = UIViewContentModeRight;
            button.tag = 100 + section;
            [button addTarget:self action:@selector(headerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
            
            return headerView;
        }
        else if ((section == 1 && [[self.resumeData objectForKey:@"eduList"] count] == 0) ||
                (section == 2 && [[self.resumeData objectForKey:@"workHisList"] count] == 0) ||
                 (section == 3 && [[self.resumeData objectForKey:@"certList"] count] == 0))
        {
            //无教育经历
            UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
            headerView.backgroundColor = [UIColor whiteColor];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            lineView.backgroundColor = [UIColor backgroudColor];
            [headerView addSubview:lineView];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45)];
            label.text = [NSString stringWithFormat:@"+   添加%@",titleArray[section - 1]];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithHexString:@"FF7B2E"];
            label.font = [UIFont systemFontOfSize:17];
            [headerView addSubview:label];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake( 0, 0, SCREEN_WIDTH, 55);
            button.backgroundColor = [UIColor clearColor];
            button.tag = 100 + section;
            [button addTarget:self action:@selector(headerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
            
            return headerView;
        }
        else
        {
            //有数据
            UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
            headerView.backgroundColor = [UIColor whiteColor];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            lineView.backgroundColor = [UIColor backgroudColor];
            [headerView addSubview:lineView];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 45)];
            label.text = titleArray[section - 1];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor colorWithHexString:@"FF7B2E"];
            label.font = [UIFont systemFontOfSize:17];
            [headerView addSubview:label];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake( SCREEN_WIDTH - 60, 10, 60, 45);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:@"＋添加" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"FF7B2E"] forState:UIControlStateNormal];
            button.contentMode = UIViewContentModeRight;
            button.tag = 100 + section;
            [button addTarget:self action:@selector(headerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
            
            return headerView;
        }
        
    }
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0)
    {
        return 55;
    }
    else
    {
        return 0.01;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return [[self.resumeData objectForKey:@"eduList"] count];
    }
    else if (section == 2)
    {
        return [[self.resumeData objectForKey:@"workHisList"] count];
    }
    else if (section == 3)
    {
        return [[self.resumeData objectForKey:@"certList"] count];
    }
    else
    {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 220;
    }
    else if (indexPath.section == 1)
    {
        tableView.estimatedRowHeight = 130;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return tableView.rowHeight;
    }
    else if (indexPath.section == 2)
    {
        tableView.estimatedRowHeight = 90;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return tableView.rowHeight;
    }
    else if (indexPath.section == 3)
    {
        tableView.estimatedRowHeight = 110;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return tableView.rowHeight;
    }
    else
    {
        tableView.estimatedRowHeight = 44;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return tableView.rowHeight;
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MyResumeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeHeaderCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeHeaderCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.model = [UserSignData share].user;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        MyResumeEducationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeEducationCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeEducationCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = [self.resumeData objectForKey:@"eduList"][indexPath.row];
        return cell;
    }
    else if (indexPath.section == 2)
    {
        MyResumeWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeWorkCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeWorkCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = [self.resumeData objectForKey:@"workHisList"][indexPath.row];
        return cell;
    }
    else if (indexPath.section == 3)
    {
        MyResumeCertificateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeCertificateCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeCertificateCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = [self.resumeData objectForKey:@"certList"][indexPath.row];
        return cell;
    }
    else if (indexPath.section == 4)
    {
        MyResumeEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeEvaluateCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeEvaluateCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        static NSString * CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        AddEducationVC * vc = [[AddEducationVC alloc] init];
        vc.model = [self.resumeData objectForKey:@"eduList"][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2)
    {
        AddWorkVC * vc = [[AddWorkVC alloc] init];
        vc.model = [self.resumeData objectForKey:@"workHisList"][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3)
    {
        AddCertificateVC * vc = [[AddCertificateVC alloc] init];
        vc.model = [self.resumeData objectForKey:@"certList"][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
}

#pragma mark - Setter/Getter

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setTitle:@"预览" forState: UIControlStateNormal];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

- (UITableView *)coustromTableView
{
    if (!_coustromTableView)
    {
        _coustromTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, JSH_NavbarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin) style:UITableViewStylePlain];
        _coustromTableView.delegate = self;
        _coustromTableView.dataSource = self;
        _coustromTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coustromTableView.showsVerticalScrollIndicator = NO;
        _coustromTableView.showsHorizontalScrollIndicator = NO;
    }
    return _coustromTableView;
}

@end
