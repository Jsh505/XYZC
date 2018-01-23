//
//  PersonalInformationTVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/2.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "PersonalInformationTVC.h"
#import "WRCustomNavigationBar.h"
#import "LDImagePicker.h"
#import "BindingPhoneVC.h"
#import "OnlyTestFileVC.h"
#import "LZCityPickerController.h"

@interface PersonalInformationTVC () <LDImagePickerDelegate>
{
    NSString * _headeImage;
}

@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *girlButton;
@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (weak, nonatomic) IBOutlet UILabel *cityLB;
@property (weak, nonatomic) IBOutlet UILabel *birthLB;
@property (weak, nonatomic) IBOutlet UITextField *heightTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (nonatomic, strong) UIButton * rightBarButton;

@property (nonatomic, strong) UIView * masView;
@property (nonatomic, strong) UIDatePicker * datePicker;

@end

@implementation PersonalInformationTVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.customNavBar.title = @"个人信息";
    [self setupNavBar];
    
    if (@available(iOS 11.0, *))
    {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.customNavBar sd_addSubviews:@[self.rightBarButton]];
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 0)
    .heightIs(44)
    .widthRatioToView(self.view, 0.2)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
    self.girlButton.selected = NO;
    self.boyButton.selected = YES;
    
    [self upView];
    
    //初始化值
    _headeImage = [UserSignData share].user.userInfo.pictureName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.textView.placeholder = @"请输入";
    self.textView.limitLength = @(140);
}


#pragma mark - Custom Accessors (控件响应方法)

- (void)rightBarButtonClicked
{
    if (_headeImage.length == 0 || self.nickName.text.length == 0 || self.birthLB.text.length == 0)
    {
        [MBProgressHUD showInfoMessage:@"请确认必填信息是否完善"];
        return;
    }
    //保存
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    [parametersDic setObject:self.nickName.text forKey:@"name"];
    [parametersDic setObject:self.birthLB.text forKey:@"birth"];
    [parametersDic setObject:_headeImage forKey:@"headPicture"];
    [parametersDic setObject:self.girlButton.selected ? @"女" : @"男" forKey:@"gender"];
    [parametersDic setObject:self.textView.text forKey:@"perSignature"];
    [parametersDic setObject:self.cityLB.text forKey:@"city"];
    [parametersDic setObject:self.phoneLB.text forKey:@"phone"];
    [parametersDic setObject:self.emailTF.text forKey:@"email"];
    [parametersDic setObject:self.textView.text forKey:@"evaluate"];
    
    [PPNetworkHelper POST:@"addOrUpdateResume.app" parameters:parametersDic hudString:@"修改中..." success:^(id responseObject)
     {
         [UserSignData share].user.userInfo = [[UserInfoModel alloc] initWithDictionary:[responseObject objectForKey:@"userInfo"]];
         [[UserSignData share] storageData:[UserSignData share].user];
         
         [self.navigationController popViewControllerAnimated:YES];
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
    self.birthLB.text = dateString;
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)

- (IBAction)boyButtonCilick:(id)sender
{
    self.boyButton.selected = YES;
    self.girlButton.selected = NO;
}

- (IBAction)girlButtonCilick:(id)sender
{
    self.boyButton.selected = NO;
    self.girlButton.selected = YES;
}


#pragma mark - Private (.m 私有方法)

- (void)setupNavBar
{
    self.tableView.tableHeaderView = self.customNavBar;
    //    [self.t addSubview:self.customNavBar];
    
    // 设置自定义导航栏背景图片
    [self.customNavBar setBarBackgroundColor:[UIColor mainColor]];
    
    // 设置自定义导航栏标题颜色
    self.customNavBar.titleLabelColor = [UIColor blackColor];
    
    if (self.navigationController.childViewControllers.count != 1) {
        
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"返回"]];
    }
}

- (void)upView
{
    [self.headerImage jsh_sdsetImageWithHeaderimg:[UserSignData share].user.userInfo.pictureName];
    self.nickName.text = [NSString is_NulllWithObject:[UserSignData share].user.userInfo.name] ? [UserSignData share].user.username : [UserSignData share].user.userInfo.name;
    self.girlButton.selected = [[UserSignData share].user.userInfo.gender isEqualToString:@"女"];
    self.boyButton.selected = ![[UserSignData share].user.userInfo.gender isEqualToString:@"女"];
    self.cityLB.text = [NSString is_NulllWithObject:[UserSignData share].user.userInfo.city] ? @"" : [UserSignData share].user.userInfo.city;
    self.birthLB.text = [NSString is_NulllWithObject:[UserSignData share].user.userInfo.birth] ? @"" : [UserSignData share].user.userInfo.birth;
    self.textView.text = [NSString is_NulllWithObject:[UserSignData share].user.userInfo.perSignature] ? @"" : [UserSignData share].user.userInfo.perSignature;
    self.phoneLB.text = [NSString is_NulllWithObject:[UserSignData share].user.userInfo.phone] ? @"" : [UserSignData share].user.userInfo.phone;
    self.emailTF.text = [NSString is_NulllWithObject:[UserSignData share].user.userInfo.email] ? @"" : [UserSignData share].user.userInfo.email;
    //    self.infoLB.text = [NSString stringWithFormat:@"%@ 无参数 %@",[NSString is_NulllWithObject:[UserSignData share].user.userInfo.colleges] ? @"未设置" : [UserSignData share].user.userInfo.colleges,
    //                        [NSString is_NulllWithObject:[UserSignData share].user.userInfo.grade] ? @"未设置" : [UserSignData share].user.userInfo.grade];
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

- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker{
    
}

- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage
{
    //上传图片
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    [PPNetworkHelper uploadWithURL:@"uploadPicture.app" parameters:nil images:@[editedImage] name:@"pictureName" fileName:timeString mimeType:@"png" hudString:@"上传中..." progress:^(NSProgress *progress) {
        
    } success:^(id responseObject)
     {
         self.headerImage.image = editedImage;
         _headeImage = [responseObject objectForKey:@"pictureName"][0];
         
     } failure:^(NSString *error)
     {
         [MBProgressHUD showInfoMessage:error];
     }];
    
}

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
        //头像
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *openCameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
            imagePicker.delegate = self;
            [imagePicker showImagePickerWithType:0 InViewController:self Scale:1];
        }];
        
        UIAlertAction *openAlbumAction = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
            imagePicker.delegate = self;
            [imagePicker showImagePickerWithType:1 InViewController:self Scale:1];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:openCameraAction];
        [alertController addAction:openAlbumAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (sec == 0 && row == 1)
    {
        //姓名
        OnlyTestFileVC * vc = [[OnlyTestFileVC alloc] initWithSureButton:^(NSString *name) {
            self.nickName.text = name;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 0 && row == 3)
    {
        //城市选择
        [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
            
            // 选择结果回调
            self.cityLB.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
            NSLog(@"%@--%@--%@--%@",address,province,city,area);
            
        }];
    }
    else if (sec == 0 && row == 4)
    {
        //生日
        [self showView];
    }
    else if (sec == 2 && row == 0)
    {
        //绑定手机号
        BindingPhoneVC * vc = [[BindingPhoneVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - Setter/Getter

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setTitle:@"保存" forState: UIControlStateNormal];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
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

