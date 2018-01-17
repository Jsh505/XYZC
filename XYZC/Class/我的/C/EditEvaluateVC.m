//
//  EditEvaluateVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/15.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "EditEvaluateVC.h"

@interface EditEvaluateVC ()

@property (nonatomic, strong) UIButton * rightBarButton;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end

@implementation EditEvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"自我评价";
    
    
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
    self.infoTextView.limitLength = @(800);
}

- (void)rightBarButtonClicked
{
    //保存
    
}

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


@end
