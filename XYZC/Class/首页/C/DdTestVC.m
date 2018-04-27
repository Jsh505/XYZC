//
//  DdTestVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/4.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "DdTestVC.h"
#import "FL_Button.h"
#import "DoTestCCell.h"
#import "TestListVC.h"

@interface DdTestVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation DdTestVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavBar.title = @"做测试";
    self.view.backgroundColor = [UIColor backgroudColor];
    
    [self creatDdTestView];
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)buttonClicked:(UIButton *)send
{
    TestListVC * vc = [[TestListVC alloc] init];
    vc.customNavBar.title = send.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)creatDdTestView
{
    NSArray * titleArray = @[@"性格测试",@"性格测试",@"性格测试",@"性格测试"];
    NSArray * imageArray = @[@"测试_01",@"测试_02",@"测试_03",@"测试_04"];
    for (int i = 0; i < titleArray.count; i ++)
    {
        FL_Button * button = [[FL_Button alloc] initWithAlignmentStatus:FLAlignmentStatusTop];
        button.fl_padding = 3;
        button.frame = CGRectMake(0 + i * SCREEN_WIDTH / 4, JSH_NavbarAndStatusBarHeight, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
        [button setTitle:titleArray[i] forState: UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, JSH_NavbarAndStatusBarHeight + SCREEN_WIDTH / 4 + 10, SCREEN_WIDTH, 40)];
    lineView.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    label.text = @"推荐测试";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [lineView addSubview:label];
    
    UIButton * addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    addbutton.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 80, 40);
    [addbutton setTitle:@"显示更多" forState: UIControlStateNormal];
    addbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    addbutton.backgroundColor = [UIColor clearColor];
    [addbutton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [lineView addSubview:addbutton];
    
    [self.view addSubview:lineView];
    
    [self.view addSubview:self.collectionView];
}


#pragma mark - Deletate/DataSource (相关代理)
#pragma mark -- 协议实现

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DoTestCCellident" forIndexPath:indexPath];
    //
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-( void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES ;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
    
    return CGSizeMake (SCREEN_WIDTH / 2 , (SCREEN_WIDTH / 2 ) * 1 / 2);
}

//定义每个UICollectionView 的边距
-(UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger )section {
    
    return UIEdgeInsetsMake (0, 0, 0, 0);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - Setter/Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JSH_NavbarAndStatusBarHeight + SCREEN_WIDTH / 4 + 50 , SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - SCREEN_WIDTH / 4 - 50 ) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"DoTestCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"DoTestCCellident"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
    }
    return _collectionView;
}

@end
