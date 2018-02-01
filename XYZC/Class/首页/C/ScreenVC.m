//
//  ScreenVC.m
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ScreenVC.h"
#import "ScreenCovHeaderView.h"
#import "ScreenCCell.h"

@interface ScreenVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * canelButton;
@property (nonatomic, strong) UIButton * sureButton;

@end

@implementation ScreenVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"筛选";
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.canelButton];
    [self.view addSubview:self.sureButton];
    
}

#pragma mark - Custom Accessors (控件响应方法)


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
    return 3 ;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size={SCREEN_WIDTH,45};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSArray * titleArray = @[@"性别要求",@"上班时间(可多选)",@"福利待遇(可多选)"];
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        ScreenCovHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScreenCovHeaderViewident" forIndexPath:indexPath];
        headerView.titleLB.text = titleArray[indexPath.section];
        reusableview = headerView;
    }
    
//    if (kind == UICollectionElementKindSectionFooter)
//    {
//        UICollectionReusableView *footerview = [collectionView dequeueResuableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        reusableview = footerview;
//    }
    return reusableview;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScreenCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScreenCCellident" forIndexPath:indexPath];
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
    
    return CGSizeMake (SCREEN_WIDTH / 4, 55);
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
        layout.minimumLineSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JSH_NavbarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 45) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"ScreenCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ScreenCCellident"];
        [_collectionView registerNib:[UINib nibWithNibName:@"ScreenCovHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScreenCovHeaderViewident"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
    }
    return _collectionView;
}

- (UIButton *)canelButton
{
    if (!_canelButton)
    {
        _canelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _canelButton.frame = CGRectMake(10, SCREEN_HEIGHT - JSH_SafeBottomMargin - 45, (SCREEN_WIDTH - 30) / 3, 45);
        _canelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_canelButton setTitle:@"重 置" forState: UIControlStateNormal];
        [_canelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _canelButton.backgroundColor = [UIColor clearColor];
        _canelButton.layer.cornerRadius = 5;
        _canelButton.layer.borderWidth = 1;
        _canelButton.layer.borderColor = [UIColor mainColor].CGColor;
        [_canelButton addTarget:self action:@selector(canelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _canelButton;
}

- (UIButton *)sureButton
{
    if (!_sureButton)
    {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(20 + (SCREEN_WIDTH - 30) / 3, SCREEN_HEIGHT - JSH_SafeBottomMargin - 45, (SCREEN_WIDTH - 30) / 3 * 2, 45);
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton setTitle:@"确 定" forState: UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sureButton.backgroundColor = [UIColor mainColor];
        _sureButton.layer.cornerRadius = 5;
        [_sureButton addTarget:self action:@selector(sureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
