//
//  ChoseLabelView.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "ChoseLabelView.h"
#import "LabelModel.h"
#import "ChoseLabelCCell.h"

@interface ChoseLabelView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation ChoseLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [ChoseLabelView loadViewFromXIB];
        self.frame = frame;
        UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewSingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self.masView addGestureRecognizer:singleRecognizer];
        
        [self.collectionBackView addSubview:self.collectionView];
        self.dataSource = [[NSMutableArray alloc] init];
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(self.userId)  forKey:@"userId"];
    
    [PPNetworkHelper POST:@"getLabelListByUserId.app" parameters:parametersDic hudString:@"获取中..." success:^(id responseObject)
    {
        [self.dataSource removeAllObjects];
        for (NSDictionary * dic in [responseObject objectForKey:@"labelList"])
        {
            LabelModel * model = [[LabelModel alloc] initWithDictionary:dic];
            [self.dataSource addObject:model];
        }
        [self.collectionView reloadData];
        
    } failure:^(NSString *error)
    {
        
    }];
}

- (void)showWithView:(UIView *)view
{
    if (view)
    {
        [view addSubview:self];
    }
    else
    {
        [self addToWindow];
    }
    
    [self.contentView springingAnimation];
}

- (void)maskViewSingleTap
{
    [self canel];
}

- (void)canel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.masView.alpha = 0;
        self.contentView.alpha = 0;
    } completion:^(BOOL finished)
    {
        [self removeFromSuperview];
        self.masView.alpha = 0.2;
        self.contentView.alpha = 1;
    }];
}

- (IBAction)sendLabelButtonCilick:(id)sender
{
    //赠送标签
    [self canel];
    if ([self.delegate respondsToSelector:@selector(giftButtonCilick)])
    {
        [self.delegate giftButtonCilick];
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChoseLabelCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChoseLabelCCellident" forIndexPath:indexPath];
    //
    cell.model = self.dataSource[indexPath.row];
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
    
    CGFloat weight = CGRectGetWidth(self.collectionBackView.bounds);
//    CGFloat hight = CGRectGetHeight(self.collectionBackView.bounds);
    return CGSizeMake (weight / 2 , weight / 2 * 333 / 1250);
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.collectionBackView.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"ChoseLabelCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ChoseLabelCCellident"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
    }
    return _collectionView;
}

@end
