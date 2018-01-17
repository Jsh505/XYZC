//
//  AddWorkVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/12.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "AddWorkVC.h"
#import "MyResumeAddNormlCell.h"
#import "MyResumeAddTFCell.h"
#import "MyResumeAddInfoTFCell.h"
#import "UITextView+YLTextView.h"

@interface AddWorkVC () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isBegin;
}

@property (nonatomic, strong) UIButton * rightBarButton;
@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) UIView * footerView;

@property (nonatomic, strong) UIView * masView;
@property (nonatomic, strong) UIDatePicker * datePicker;

@property (nonatomic, strong) UITextField * nameTF;
@property (nonatomic, strong) UILabel * beginTimeLB;
@property (nonatomic, strong) UILabel * endTimeLB;
@property (nonatomic, strong) UITextView * infoTextView;

@end

@implementation AddWorkVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"工作经历";
    
    self.coustromTableView.tableFooterView = self.footerView;
    [self.view addSubview:self.coustromTableView];
    
    if (self.model)
    {
        [self.customNavBar sd_addSubviews:@[self.rightBarButton]];
        
        self.rightBarButton.sd_layout
        .rightSpaceToView(self.customNavBar, 0)
        .heightIs(44)
        .widthRatioToView(self.view, 0.2)
        .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.infoTextView.placeholder = @"请输入";
    self.infoTextView.limitLength = @(800);
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)sureButtonClicked
{
    //确认
    if (self.nameTF.text.length == 0 || [self.beginTimeLB.text isEqualToString:@"请选择"] || [self.infoTextView.text isEqualToString:@"请选择"])
    {
        [MBProgressHUD showInfoMessage:@"请确认必填信息是否完善"];
        return;
    }

    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.resumeId) forKey:@"resumeId"];
    [parametersDic setObject:self.nameTF.text forKey:@"companyName"];
    [parametersDic setObject:self.beginTimeLB.text forKey:@"startDate"];
    [parametersDic setObject:self.endTimeLB.text forKey:@"endDate"];
    [parametersDic setObject:self.infoTextView.text forKey:@"content"];
    if (self.model)
    {
        //修改
        [parametersDic setObject:[self.model objectForKey:@"id"] forKey:@"id"];
    }
    
    
    [PPNetworkHelper POST:@"addOrUpdateWorkHis.app" parameters:parametersDic hudString:@"提交中..." success:^(id responseObject)
     {
         [self.navigationController popViewControllerAnimated:YES];
         //发送消息
         [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"MyResumeRefshData" object:nil userInfo:nil]];
     } failure:^(NSString *error)
     {
         [MBProgressHUD showInfoMessage:error];
     }];
}

- (void)dateChanged:(UIDatePicker *)datePicker
{
    NSDate* date = datePicker.date;
    //添加你自己响应代码
    NSLog(@"dateChanged响应事件：%@",date);
    
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    
    //打印显示日期时间
    if (_isBegin)
    {
        self.beginTimeLB.text = dateString;
    }
    else
    {
        self.endTimeLB.text = dateString;
    }
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)rightBarButtonClicked
{
    //删除
    
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[self.model objectForKey:@"id"] forKey:@"id"];
    
    [PPNetworkHelper POST:@"deleteWorkHisByKey.app" parameters:parametersDic hudString:@"删除中..." success:^(id responseObject)
     {
         [self.navigationController popViewControllerAnimated:YES];
         //发送消息
         [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"MyResumeRefshData" object:nil userInfo:nil]];
     } failure:^(NSString *error) {
         
         [MBProgressHUD showErrorMessage:error];
     }];
}

- (void)showView
{
    [self.masView addToWindow];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.masView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)closeView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.masView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        [self.masView removeFromSuperview];
        
    }];
}

#pragma mark - Deletate/DataSource (相关代理)

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = [UIColor backgroudColor];
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
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
        return 44;
    }
    else
    {
        return 190;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSArray * titleArray = @[@"公司名",@"开始时间",@"结束时间"];
        if (indexPath.row == 0)
        {
            MyResumeAddTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeAddTFCellident"];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeAddTFCell" owner:nil options:nil];
                cell = array[0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.titleLB.text = titleArray[indexPath.row];
            if (self.model)
            {
                cell.textField.text = [self.model objectForKey:@"companyName"];
            }
            self.nameTF = cell.textField;
            return cell;
        }
        else
        {
            
            MyResumeAddNormlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeAddNormlCellident"];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeAddNormlCell" owner:nil options:nil];
                cell = array[0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.titleLB.text = titleArray[indexPath.row];
            if (indexPath.row == 1)
            {
                if (self.model)
                {
                    cell.infoLB.text = [self.model objectForKey:@"startDate"];
                }
                self.beginTimeLB = cell.infoLB;
            }
            else
            {
                if (self.model)
                {
                    cell.infoLB.text = [self.model objectForKey:@"endDate"];
                }
                self.endTimeLB = cell.infoLB;
            }
            return cell;
        }
        
    }
    else
    {
        MyResumeAddInfoTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeAddInfoTFCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeAddInfoTFCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLB.text = @"具体内容";
        if (self.model)
        {
            cell.infoTextView.text = [self.model objectForKey:@"content"];
        }
        self.infoTextView = cell.infoTextView;
        return cell;
    }
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        //入学时间
        _isBegin = YES;
        [self showView];
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        //毕业时间
        _isBegin = NO;
        [self showView];
    }
}

#pragma mark - Setter/Getter

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setTitle:@"删除" forState: UIControlStateNormal];
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

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15, 3, SCREEN_WIDTH - 30, 44);
        [button setTitle:@"确 认" forState: UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor mainColor];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(sureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
        
    }
    return _footerView;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - JSH_SafeBottomMargin, SCREEN_WIDTH, 216)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];//重点：UIControlEventValueChanged
        
        //设置显示格式
        //默认根据手机本地设置显示为中文还是其他语言
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
        _datePicker.locale = locale;
        
    }
    return _datePicker;
}

- (UIView *)masView
{
    if (!_masView)
    {
        _masView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _masView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_masView addGestureRecognizer:singleRecognizer];
        [_masView addSubview:self.datePicker];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - JSH_SafeBottomMargin - 40, SCREEN_WIDTH, 40)];
        titleLabel.text = @"选择时间";
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor mainColor];
        titleLabel.font = [UIFont systemFontOfSize:17];
        [_masView addSubview:titleLabel];
        
        UILabel * sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 216 - JSH_SafeBottomMargin - 40, 40, 40)];
        sureLabel.text = @"确定";
        sureLabel.textAlignment = NSTextAlignmentCenter;
        sureLabel.textColor = [UIColor colorWithHexString:@"333333"];
        sureLabel.font = [UIFont systemFontOfSize:15];
        [_masView addSubview:sureLabel];
    }
    return _masView;
}

@end
