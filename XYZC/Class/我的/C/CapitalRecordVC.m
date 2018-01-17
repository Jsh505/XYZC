//
//  CapitalRecordVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/4.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "CapitalRecordVC.h"
#import "CapitalRecordCell.h"
#import "FL_Button.h"

@interface CapitalRecordVC ()

@property (nonatomic, strong) FL_Button * rightBarButton;

@end

@implementation CapitalRecordVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"资金记录";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    
    [self.customNavBar sd_addSubviews:@[self.rightBarButton]];
    
    self.rightBarButton.sd_layout
    .rightSpaceToView(self.customNavBar, 5)
    .heightIs(44)
    .widthRatioToView(self.view, 0.2)
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight);
    
    [self.view addSubview:self.coustromTableView];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)rightBarButtonClicked
{
    //全部
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.estimatedRowHeight = 175;
    tableView.rowHeight = UITableViewAutomaticDimension;
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CapitalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CapitalRecordCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"CapitalRecordCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.markLB.text = @"这是被猪信息，这是被猪信息，这是被猪信息，这是被猪信息，这是被猪信息";
    return cell;
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Setter/Getter

- (FL_Button *)rightBarButton
{
    if (!_rightBarButton)
    {
        _rightBarButton = [[FL_Button alloc] initWithAlignmentStatus:FLAlignmentStatusCenter];
        _rightBarButton.fl_padding = 3;
        [_rightBarButton setTitle:@"全部" forState: UIControlStateNormal];
        _rightBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBarButton setImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
        _rightBarButton.backgroundColor = [UIColor clearColor];
        [_rightBarButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

@end
