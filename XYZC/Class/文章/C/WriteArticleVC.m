//
//  WriteArticleVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/8.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "WriteArticleVC.h"
#import "LDImagePicker.h"

@interface WriteArticleVC () <LDImagePickerDelegate>

@property (nonatomic, strong) UIButton * rightBarButton;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (nonatomic, copy) NSString * imageUrl;

@end

@implementation WriteArticleVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"新动态";
    
    [self.customNavBar sd_addSubviews:@[self.rightBarButton]];
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 0)
    .heightIs(44)
    .widthRatioToView(self.view, 0.2)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.infoTextView.placeholder = @"请输入";
    self.infoTextView.limitLength = @(200);
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)

- (IBAction)photoButtonClicked:(id)sender
{
    //上传图片
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

- (void)rightBarButtonClicked
{
    if (self.titleTF.text.length == 0)
    {
        [MBProgressHUD showErrorMessage:@"标题不能为空"];
        return;
    }
    if (self.infoTextView.text.length == 0)
    {
        [MBProgressHUD showErrorMessage:@"内容不能为空"];
        return;
    }
    if (self.imageUrl.length == 0)
    {
        [MBProgressHUD showErrorMessage:@"图片不能为空"];
        return;
    }
    
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:self.titleTF.text forKey:@"title"];
    [parametersDic setObject:self.imageUrl forKey:@"pictureName"];
    [parametersDic setObject:self.infoTextView.text forKey:@"content"];
     [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    
    [PPNetworkHelper POST:@"addOrUpdateArticle.app" parameters:parametersDic hudString:@"发布中..." success:^(id responseObject)
    {
        [MBProgressHUD showInfoMessage:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"articleHomeRefush" object:nil userInfo:nil]];
    } failure:^(NSString *error)
    {
        [MBProgressHUD showErrorMessage:error];
    }];
}

#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)
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
         [self.photoButton setImage:editedImage forState:UIControlStateNormal];
         self.imageUrl = [responseObject objectForKey:@"pictureName"][0];
         
     } failure:^(NSString *error)
     {
         [MBProgressHUD showInfoMessage:error];
     }];
}

#pragma mark - Deletate/DataSource (相关代理)


#pragma mark - Setter/Getter

- (UIButton *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBarButton setTitle:@"发布" forState: UIControlStateNormal];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}
@end
