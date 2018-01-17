//
//  AddCertificateVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/12.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "AddCertificateVC.h"
#import "MyResumeAddTFCell.h"
#import "UITextView+YLTextView.h"
#import "LDImagePicker.h"
#import "MyResumeAddInfoAndPhotoCell.h"

@interface AddCertificateVC () <UITableViewDelegate, UITableViewDataSource, LDImagePickerDelegate>

@property (nonatomic, strong) UIButton * rightBarButton;
@property (nonatomic, strong) UITableView * coustromTableView;
@property (nonatomic, strong) UIView * footerView;

@property (nonatomic, strong) UITextField * nameTF;
@property (nonatomic, strong) UITextView * infoTextView;
@property (nonatomic, strong) UIImageView * photoImageView;
@property (nonatomic, copy) NSString * pictureName;

@end

@implementation AddCertificateVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"技能/证书";
    
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
    if (self.nameTF.text.length == 0)
    {
        [MBProgressHUD showInfoMessage:@"请确认必填信息是否完善"];
        return;
    }
//    修改时：resumeId  简历id 不能为空                    新增证书需要字段：resumeId 简历Id; certificateName 证书名称;  content 证书内容; pictureName 图片名称;
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.resumeId) forKey:@"resumeId"];
    [parametersDic setObject:self.nameTF.text forKey:@"certificateName"];
    [parametersDic setObject:self.infoTextView.text forKey:@"content"];
    [parametersDic setObject:self.pictureName forKey:@"pictureName"];
    if (self.model)
    {
        //修改
        [parametersDic setObject:[self.model objectForKey:@"id"] forKey:@"id"];
    }
    
    [PPNetworkHelper POST:@"addOrUpdateCert.app" parameters:parametersDic hudString:@"提交中..." success:^(id responseObject)
     {
         [self.navigationController popViewControllerAnimated:YES];
         //发送消息
         [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"MyResumeRefshData" object:nil userInfo:nil]];
     } failure:^(NSString *error)
     {
         [MBProgressHUD showInfoMessage:error];
     }];
}

- (void)rightBarButtonClicked
{
    //删除
    
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:[self.model objectForKey:@"id"] forKey:@"id"];
    
    [PPNetworkHelper POST:@"deleteCertByKey.app" parameters:parametersDic hudString:@"删除中..." success:^(id responseObject)
     {
         [self.navigationController popViewControllerAnimated:YES];
         //发送消息
         [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"MyResumeRefshData" object:nil userInfo:nil]];
     } failure:^(NSString *error) {
         
         [MBProgressHUD showErrorMessage:error];
     }];
}

- (void)phtotImageViewSingleTap
{
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

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)

- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker{
    
}

- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage{
    
    //上传图片
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    [PPNetworkHelper uploadWithURL:@"uploadPicture.app" parameters:nil images:@[editedImage] name:@"pictureName" fileName:timeString mimeType:@"png" hudString:@"上传中..." progress:^(NSProgress *progress) {
        
    } success:^(id responseObject)
     {
         self.photoImageView.image = editedImage;
         self.pictureName = [responseObject objectForKey:@"pictureName"][0];
         
     } failure:^(NSString *error)
     {
         [MBProgressHUD showInfoMessage:error];
     }];
    
}


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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 44;
    }
    else
    {
        return 330;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MyResumeAddTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeAddTFCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeAddTFCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLB.text = @"技能名/奖状名";
        if (self.model)
        {
            cell.textField.text = [self.model objectForKey:@"certificateName"];
        }
        self.nameTF = cell.textField;
        return cell;
        
    }
    else
    {
        MyResumeAddInfoAndPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyResumeAddInfoAndPhotoCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MyResumeAddInfoAndPhotoCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLB.text = @"具体内容";
        cell.phtotImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phtotImageViewSingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [cell.phtotImageView addGestureRecognizer:singleRecognizer];
        if (self.model)
        {
            cell.infoTextView.text = [self.model objectForKey:@"content"];
            [cell.phtotImageView jsh_sdsetImageWithURL:[self.model objectForKey:@"pictureName"] placeholderImage:Default_General_Image];
            self.pictureName = [self.model objectForKey:@"pictureName"];
        }
        self.infoTextView = cell.infoTextView;
        self.photoImageView = cell.phtotImageView;
        
        return cell;
    }
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

@end
