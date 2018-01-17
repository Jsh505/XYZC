//
//  MyPointsVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/3.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyPointsVC.h"
#import "MyPointsHeaderView.h"
#import "MyPointCCell.h"
#import "signVC.h"

@interface MyPointsVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) MyPointsHeaderView * headerView;
@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSArray * siginDatesList;
@end

@implementation MyPointsVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"我的积分";
    [self.view addSubview:self.headerView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH * 175 / 375 + JSH_NavbarAndStatusBarHeight, SCREEN_WIDTH, 20)];
    label.text = @"  礼品兑换";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    [self.view addSubview:self.collectionView];
    
    [self loadSiginDates];
}
- (void)loadSiginDates
{
    //获取签到历史
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    
    [PPNetworkHelper POST:@"querySigninListByUserId.app" parameters:parametersDic hudString:nil success:^(id responseObject) {
        self.siginDatesList = [NSArray arrayWithArray:[responseObject objectForKey:@"signinList"]];
    } failure:^(NSString *error) {
    }];
}

#pragma mark - Custom Accessors (控件响应方法)

- (void)signButtonCilick
{
    //签到
    signVC * vc = [[signVC alloc] init];
    vc.siginDatesList = self.siginDatesList;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)exchangeButtonCilick
{
    //兑换
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)

#pragma mark -- 协议实现

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPointCCellident" forIndexPath:indexPath];
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
    
    return CGSizeMake (SCREEN_WIDTH / 2 , (SCREEN_WIDTH / 2 )* 200 / 180);
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH * 175 / 375 + JSH_NavbarAndStatusBarHeight + 20 , SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_WIDTH * 175 / 375 - JSH_NavbarAndStatusBarHeight - 20 ) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"MyPointCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyPointCCellident"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
    }
    return _collectionView;
}

- (MyPointsHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [MyPointsHeaderView loadViewFromXIB];
        _headerView.frame = CGRectMake(0, JSH_NavbarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_WIDTH * 175 / 375);
        _headerView.headerView.backgroundColor = [UIColor mainColor];
        [_headerView.signButton addTarget:self action:@selector(signButtonCilick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.exchangeButton addTarget:self action:@selector(exchangeButtonCilick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

@end
