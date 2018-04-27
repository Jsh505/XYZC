//
//  GiftLabelVC.m
//  XYZC
//
//  Created by 贾仕海 on 2018/1/29.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "GiftLabelVC.h"
#import "YUSegment.h"
#import "GiftCCell.h"
#import "GiftLabelModel.h"
#import "CoustomeLabelHeaderView.h"
#import "GiftCoustomeCCell.h"
#import "LabelModel.h"
#import "WXApi.h"

@interface GiftLabelVC () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    int _type;
    int _price;
    BOOL _isHaveCace;
}

@property (nonatomic, strong) UISegmentedControl   *headerSegment;
@property (nonatomic, strong) UIScrollView         *contentScrollview;

//普通页面
@property (nonatomic, strong) UIView * generalView; //普通标签
@property (nonatomic, strong) YUSegmentedControl *segmentedControl;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UICollectionView * seletedCollectionView;
@property (nonatomic, strong) NSMutableArray * seletedDataSource;

@property (nonatomic, strong) NSMutableArray * fashion; //时尚
@property (nonatomic, strong) NSMutableArray * cartoon; //卡通
@property (nonatomic, strong) NSMutableArray * alternative;//非主流
@property (nonatomic, strong) NSMutableArray * firl; //少女

@property (nonatomic, strong) UIView * commitView;
@property (nonatomic, strong) UILabel * priceLB;
@property (nonatomic, strong) UIButton * commitButton;

//自定义页面
@property (nonatomic, strong) UIView * coustomeView; //自定义标签
@property (nonatomic, strong) CoustomeLabelHeaderView * coustomeHeaderView;
@property (nonatomic, strong) UICollectionView * coustomeCollectionView;

@property (nonatomic, strong) UILabel * coustomePriceLB;
@property (nonatomic, strong) UIButton * coustomeCommitButton;

@property (nonatomic, strong) NSArray * coustomeLabelImageArray;
@property (nonatomic, strong) NSMutableArray * coustomeLabelIsSeletedArray;
@property (nonatomic, copy) NSString * coustomeLabelSeletedId;

//支付订单
@property (nonatomic, copy) NSString * prepay_id;
@property (nonatomic, copy) NSString * nonce_str;

@end

@implementation GiftLabelVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.customNavBar sd_addSubviews:@[self.headerSegment]];
    
    self.headerSegment.sd_layout
    .topSpaceToView(self.customNavBar, JSH_StatusBarHeight + 6)
    .centerXIs(SCREEN_WIDTH / 2)
    .widthIs(150)
    .heightIs(30);
    
    [self.headerSegment setSelectedSegmentIndex:0];
    
    [self.view addSubview:self.contentScrollview];
    
    self.contentScrollview.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .leftSpaceToView(self.view, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin);
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.seletedDataSource = [[NSMutableArray alloc] init];
    self.fashion = [[NSMutableArray alloc] init];
    self.cartoon = [[NSMutableArray alloc] init];
    self.alternative = [[NSMutableArray alloc] init];
    self.firl = [[NSMutableArray alloc] init];
    _type = 0;
    
    self.coustomeLabelImageArray = @[@"0标签",@"1标签",@"2标签",@"3标签",@"4标签",@"5标签",@"6标签",@"7标签",@"8标签",@"9标签",@"10标签",@"11标签",@"12标签",@"13标签",@"14标签",@"15标签",@"16标签",@"17标签",@"18标签",@"19标签"];
    self.coustomeLabelIsSeletedArray = [[NSMutableArray alloc] init];
    for (id i in self.coustomeLabelImageArray)
    {
        [self.coustomeLabelIsSeletedArray addObject:@"0"];
    }
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"ORDER_PAY_NOTIFICATION" object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    [self.webView reload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"ORDER_PAY_NOTIFICATION" object:nil];
}


- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    
    [PPNetworkHelper POST:@"queryLabelList.app" parameters:parametersDic hudString:nil responseCache:^(id responseCache)
    {
        if (responseCache)
        {
            _isHaveCace = YES;
            
            for (NSDictionary * dic in [[responseCache objectForKey:@"labelList"] objectForKey:@"fashion"])
            {
                GiftLabelModel * model = [[GiftLabelModel alloc] initWithDictionary:dic];
                [self.fashion addObject:model];
            }
            for (NSDictionary * dic in [[responseCache objectForKey:@"labelList"] objectForKey:@"cartoon"])
            {
                GiftLabelModel * model = [[GiftLabelModel alloc] initWithDictionary:dic];
                [self.cartoon addObject:model];
            }
            for (NSDictionary * dic in [[responseCache objectForKey:@"labelList"] objectForKey:@"alternative"])
            {
                GiftLabelModel * model = [[GiftLabelModel alloc] initWithDictionary:dic];
                [self.alternative addObject:model];
            }
            for (NSDictionary * dic in [[responseCache objectForKey:@"labelList"] objectForKey:@"firl"])
            {
                GiftLabelModel * model = [[GiftLabelModel alloc] initWithDictionary:dic];
                [self.firl addObject:model];
            }
            self.dataSource = self.fashion;
            [self.collectionView reloadData];
        }
    }  success:^(id responseObject)
    {
        if (!_isHaveCace)
        {
            for (NSDictionary * dic in [[responseObject objectForKey:@"labelList"] objectForKey:@"fashion"])
            {
                GiftLabelModel * model = [[GiftLabelModel alloc] initWithDictionary:dic];
                [self.fashion addObject:model];
            }
            for (NSDictionary * dic in [[responseObject objectForKey:@"labelList"] objectForKey:@"cartoon"])
            {
                GiftLabelModel * model = [[GiftLabelModel alloc] initWithDictionary:dic];
                [self.cartoon addObject:model];
            }
            for (NSDictionary * dic in [[responseObject objectForKey:@"labelList"] objectForKey:@"alternative"])
            {
                GiftLabelModel * model = [[GiftLabelModel alloc] initWithDictionary:dic];
                [self.alternative addObject:model];
            }
            for (NSDictionary * dic in [[responseObject objectForKey:@"labelList"] objectForKey:@"firl"])
            {
                GiftLabelModel * model = [[GiftLabelModel alloc] initWithDictionary:dic];
                [self.firl addObject:model];
            }
            self.dataSource = self.fashion;
            [self.collectionView reloadData];
        }
    } failure:^(NSString *error)
    {
        [MBProgressHUD showErrorMessage:error];
    }];
}

#pragma mark - Custom Accessors (控件响应方法)

-(void)segCChanged:(UISegmentedControl*)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    CGRect frame = self.contentScrollview.frame;
    frame.origin.x = index * CGRectGetWidth(self.contentScrollview.frame);
    frame.origin.y = 0;
    [self.contentScrollview scrollRectToVisible:frame animated:YES];
}

- (void)segmentedControlTapped:(YUSegmentedControl *)sender
{
    //类型选择
    NSInteger index = sender.selectedSegmentIndex;
    _type = (int)index;
    switch (_type) {
        case 0:
        {
            self.dataSource = self.fashion;
            [self.collectionView reloadData];
            break;
        }
        case 1:
        {
            self.dataSource = self.cartoon;
            [self.collectionView reloadData];
            break;
        }
        case 2:
        {
            self.dataSource = self.alternative;
            [self.collectionView reloadData];
            break;
        }
        case 3:
        {
            self.dataSource = self.firl;
            [self.collectionView reloadData];
            break;
        }
        default:
            break;
    }
}

- (void)commitButtonClicked
{
    if (self.seletedDataSource.count == 0)
    {
        [MBProgressHUD showInfoMessage:@"还未选择一款标签"];
        return;
    }
    
    NSString * idString = @"";
    for (GiftLabelModel * model in self.seletedDataSource)
    {
        idString = [idString stringByAppendingString:[NSString stringWithFormat:@",%d",model.id]];
    }
    
    //普通购买  赠送普通标签：labelMainType 标签大类  1   userId 被赠送标签用户id   labelId 标签Id  都不能为空
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(1) forKey:@"labelMainType"];
    [parametersDic setObject:@(self.userId) forKey:@"userId"];
    [parametersDic setObject:[idString substringWithRange:NSMakeRange(1, [idString length] - 1)] forKey:@"labelId"];
    
    [PPNetworkHelper POST:@"buyLabel.app" parameters:parametersDic hudString:@"购买中..." success:^(id responseObject)
     {
         //调用微信支付
         self.prepay_id = [[responseObject objectForKey:@"wxPayResult"] objectForKey:@"prepayId"];
         self.nonce_str = [[responseObject objectForKey:@"wxPayResult"] objectForKey:@"nonceStr"];
         [self weixinPay];
    } failure:^(NSString *error)
    {
        [MBProgressHUD showErrorMessage:error];
    }];
}

- (void)weixinPay
{
    //    //立即支付
    if (![WXApi isWXAppInstalled])
    {
        //检查用户是否安装微信
        [MBProgressHUD showTipMessageInView:@"检查是否安装微信"];
        return;
    }
    
    //当前时间戳
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
//    NSString *timeString = [NSString stringWithFormat:@"%f", a];//转为字符型
    
    PayReq *request = [[PayReq alloc] init];
    request.openID = WX_APPID;
    request.partnerId = @"1499260112";    //商户号
    request.prepayId= self.prepay_id;   //订单号
    request.package = @"Sign=WXPay";
    request.nonceStr= self.nonce_str;  //随机字符串
//    request.timeStamp = (uint32_t)timeString;
    // 将当前时间转化成时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    request.timeStamp= timeStamp;
    // 签名加密
    request.sign = [NSString createMD5SingForPay:request.openID
                                   partnerid:request.partnerId
                                    prepayid:request.prepayId
                                     package:request.package
                                    noncestr:request.nonceStr
                                   timestamp:request.timeStamp];
    // 调用微信
    [WXApi sendReq:request];
}


- (void)notice:(NSNotification *)notice
{
    switch ([notice.object intValue])
    {
        case WXSuccess:
        {
            [MBProgressHUD showInfoMessage:@"购买成功"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case WXErrCodeUserCancel:
        {
            [MBProgressHUD showTipMessageInView:@"已取消支付"];
            break;
        }
        default:
            [MBProgressHUD showTipMessageInView:@"购买失败"];
            break;
    }
}

- (void)coustomeHeaderViewSureButtonCilick
{
    //自定义标签文字确定
    if (self.coustomeHeaderView.labelTextTF.text.length > 0 && self.coustomeHeaderView.labelTextTF.text.length <= 5)
    {
        GiftCoustomeCCell * cell = (GiftCoustomeCCell *)[self.coustomeCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.labelLB.text = self.coustomeHeaderView.labelTextTF.text;
        [self.coustomeCollectionView reloadData];
    }
    else
    {
        [MBProgressHUD showInfoMessage:@"请输入1~5个文字"];
    }
   
}

- (void)coustomeCommitButtonClicked
{
    if (self.coustomeHeaderView.labelTextTF.text.length == 0 || self.coustomeHeaderView.labelTextTF.text.length > 5 || [NSString is_NulllWithObject:self.coustomeLabelSeletedId])
    {
        [MBProgressHUD showInfoMessage:@"请确认购买标签是否正确"];
        return;
    }
    // 赠送自定义标签 ：  labelMainType 标签大类 2  labelName标签名称 pictureName 标签图片名称 userId 被赠送标签用户id  都不能为空
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@(2) forKey:@"labelMainType"];
    [parametersDic setObject:@(self.userId) forKey:@"userId"];
    [parametersDic setObject:self.coustomeHeaderView.labelTextTF.text forKey:@"labelName"];
    [parametersDic setObject:self.coustomeLabelSeletedId forKey:@"pictureName"];
    
    [PPNetworkHelper POST:@"buyLabel.app" parameters:parametersDic hudString:@"购买中..." success:^(id responseObject)
     {
         //调用微信支付
         self.prepay_id = [[responseObject objectForKey:@"wxPayResult"] objectForKey:@"prepayId"];
         self.nonce_str = [[responseObject objectForKey:@"wxPayResult"] objectForKey:@"nonceStr"];
         [self weixinPay];
     } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
     }];
}

#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)


#pragma mark - Deletate/DataSource (相关代理)

#pragma mark - Scrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollview)
    {
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger ratio = round(offSetX / SCREEN_WIDTH);
        self.headerSegment.selectedSegmentIndex = ratio;
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView)
    {
        return self.dataSource.count;
    }
    else if (collectionView == self.seletedCollectionView)
    {
        return self.seletedDataSource.count;
    }
    else
    {
        return 20;
    }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.coustomeCollectionView)
    {
        GiftCoustomeCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiftCoustomeCCellident" forIndexPath:indexPath];
        cell.labelImageView.image = [UIImage imageNamed:self.coustomeLabelImageArray[indexPath.row]];
        cell.isSeleted = self.coustomeLabelIsSeletedArray[indexPath.row];
        return cell;
    }
    else
    {
        GiftCCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiftCCellident" forIndexPath:indexPath];
        
        if (collectionView == self.collectionView)
        {
            cell.model = self.dataSource[indexPath.row];
        }
        else
        {
            cell.model = self.seletedDataSource[indexPath.row];
        }
        return cell;
    }
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-( void )collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.coustomeCollectionView)
    {
        //选择自定义标签
        self.coustomeLabelSeletedId = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.coustomeLabelIsSeletedArray removeAllObjects];
        for (id i in self.coustomeLabelImageArray)
        {
            [self.coustomeLabelIsSeletedArray addObject:@"0"];
        }
        [self.coustomeLabelIsSeletedArray setObject:@"1" atIndexedSubscript:indexPath.row];
        [self.coustomeCollectionView reloadData];
    }
    else
    {
        if (collectionView == self.collectionView)
        {
            GiftLabelModel * model = [[GiftLabelModel alloc] init];
            switch (_type) {
                case 0:
                {
                    model = self.fashion[indexPath.row];
                    model.isSeleted = !model.isSeleted;
                    [self.fashion replaceObjectAtIndex:indexPath.row withObject:model];
                    self.dataSource = self.fashion;
                    [self.collectionView reloadData];
                    break;
                }
                case 1:
                {
                    model = self.cartoon[indexPath.row];
                    model.isSeleted = !model.isSeleted;
                    [self.cartoon replaceObjectAtIndex:indexPath.row withObject:model];
                    self.dataSource = self.cartoon;
                    [self.collectionView reloadData];
                    break;
                }
                case 2:
                {
                    model = self.alternative[indexPath.row];
                    model.isSeleted = !model.isSeleted;
                    [self.alternative replaceObjectAtIndex:indexPath.row withObject:model];
                    self.dataSource = self.alternative;
                    [self.collectionView reloadData];
                    break;
                }
                case 3:
                {
                    model = self.firl[indexPath.row];
                    model.isSeleted = !model.isSeleted;
                    [self.firl replaceObjectAtIndex:indexPath.row withObject:model];
                    self.dataSource = self.firl;
                    [self.collectionView reloadData];
                    break;
                }
                default:
                    break;
            }
            
            if (model.isSeleted)
            {
                [self.seletedDataSource addObject:model];
            }
            else
            {
                [self.seletedDataSource removeObject:model];
            }
            [self.seletedCollectionView reloadData];
        }
        else if (collectionView == self.seletedCollectionView)
        {
            GiftLabelModel * model = self.seletedDataSource[indexPath.row];
            [self.seletedDataSource removeObject:model];
            [self.seletedCollectionView reloadData];
            
            switch (model.labelLittleType)
            {
                case 1:
                {
                    NSInteger index = [self.fashion indexOfObject:model];
                    model.isSeleted = NO;
                    [self.fashion replaceObjectAtIndex:index withObject:model];
                    break;
                }
                case 2:
                {
                    NSInteger index = [self.cartoon indexOfObject:model];
                    model.isSeleted = NO;
                    [self.cartoon replaceObjectAtIndex:index withObject:model];
                    break;
                }
                case 3:
                {
                    NSInteger index = [self.alternative indexOfObject:model];
                    model.isSeleted = NO;
                    [self.alternative replaceObjectAtIndex:index withObject:model];
                    break;
                }
                case 4:
                {
                    NSInteger index = [self.firl indexOfObject:model];
                    model.isSeleted = NO;
                    [self.firl replaceObjectAtIndex:index withObject:model];
                    break;
                }
                default:
                    break;
            }
            switch (_type) {
                case 0:
                {
                    self.dataSource = self.fashion;
                    [self.collectionView reloadData];
                    break;
                }
                case 1:
                {
                    self.dataSource = self.cartoon;
                    [self.collectionView reloadData];
                    break;
                }
                case 2:
                {
                    self.dataSource = self.alternative;
                    [self.collectionView reloadData];
                    break;
                }
                case 3:
                {
                    self.dataSource = self.firl;
                    [self.collectionView reloadData];
                    break;
                }
                default:
                    break;
            }
        }
        
        //计算价格
        _price = 0;
        for (id model in self.seletedDataSource)
        {
            _price ++;
        }
        self.priceLB.text = [NSString stringWithFormat:@"¥ %d",_price];
    }
   
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES ;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {

    if (collectionView == self.coustomeCollectionView)
    {
        return CGSizeMake (SCREEN_WIDTH / 2 , SCREEN_WIDTH / 2 * 333 / 1250 + 15);
    }
    else
    {
        return CGSizeMake (SCREEN_WIDTH / 4 , 40);
    }
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

- (UISegmentedControl *)headerSegment
{
    if (!_headerSegment)
    {
        _headerSegment = [[UISegmentedControl alloc]init];
        //        _headerSegment.frame = CGRectMake(50 , JSH_StatusBarHeight + 6, SCREEN_WIDTH - 100, 30);
        //添加小按钮
        [_headerSegment insertSegmentWithTitle:@"普通标签" atIndex:0 animated:YES];
        [_headerSegment insertSegmentWithTitle:@"自定义" atIndex:1 animated:YES];
        //设置样式
        [_headerSegment setTintColor:[UIColor colorWithHexString:@"484848"]];
        //设置字体样式
        [_headerSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"484848"]} forState:UIControlStateNormal];
        [_headerSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor mainColor]} forState:UIControlStateSelected];
        //添加事件
        [_headerSegment addTarget:self action:@selector(segCChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _headerSegment;
}

- (UIScrollView *)contentScrollview
{
    if (!_contentScrollview)
    {
        _contentScrollview = [[UIScrollView alloc] init];
        //        [_contentScrollview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin)];
        _contentScrollview.pagingEnabled = YES;
        _contentScrollview.delegate = self;
        _contentScrollview.showsHorizontalScrollIndicator = NO;
        _contentScrollview.bounces = false;
        //方向锁
        _contentScrollview.directionalLockEnabled = YES;
        //取消自动布局
        self.automaticallyAdjustsScrollViewInsets = NO;
        //为scrollview设置大小  需要计算调整
        _contentScrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin);
        
        [_contentScrollview addSubview:self.generalView];
        [_contentScrollview addSubview:self.coustomeView];
    }
    return _contentScrollview;
}

- (UIView *)generalView
{
    if (!_generalView)
    {
        _generalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin)];
        _generalView.backgroundColor = [UIColor whiteColor];
        
        [_generalView addSubview:self.segmentedControl];
        [_generalView addSubview:self.collectionView];
        [_generalView addSubview:self.lineView];
        [_generalView addSubview:self.seletedCollectionView];
        [_generalView addSubview:self.commitView];
    }
    return _generalView;
}

- (YUSegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        _segmentedControl = [[YUSegmentedControl alloc] initWithTitles:@[@"时尚", @"卡通", @"非主流", @"少女系"]];
        _segmentedControl.indicator.locate = YUSegmentedControlIndicatorLocateBottom;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.frame = CGRectMake(0, -1, SCREEN_WIDTH, 40);
        _segmentedControl.indicator.backgroundColor = [UIColor mainColor];
        [_segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 74 - 100 - 40 - 40) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"GiftCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GiftCCellident"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
    }
    return _collectionView;
}

- (UICollectionView *)seletedCollectionView
{
    if (!_seletedCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _seletedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 74 - 100, SCREEN_WIDTH, 90) collectionViewLayout:layout];
        [_seletedCollectionView registerNib:[UINib nibWithNibName:@"GiftCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GiftCCellident"];
        _seletedCollectionView.showsVerticalScrollIndicator = NO;
        _seletedCollectionView.showsHorizontalScrollIndicator = NO;
        _seletedCollectionView.backgroundColor = [UIColor whiteColor];
        _seletedCollectionView.delegate = self ;
        _seletedCollectionView.dataSource = self ;
    }
    return _seletedCollectionView;
}

- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 74 - 100 - 40, SCREEN_WIDTH, 40)];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        line.backgroundColor = [UIColor backgroudColor];
        [_lineView addSubview:line];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
        label.text = @"选择标签";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        [_lineView addSubview:label];
    }
    return _lineView;
}

- (UIView *)commitView
{
    if (!_commitView)
    {
        _commitView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 74, SCREEN_WIDTH - 20, 64)];
        _commitView.layer.cornerRadius = 5;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 20)];
        label.text = @"普通标签每个一元，购买后可在文章页面展示标签";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:11];
        [_commitView addSubview:label];
        
        [_commitView addSubview:self.priceLB];
        [_commitView addSubview:self.commitButton];
    }
    return _commitView;
}

- (UILabel *)priceLB
{
    if (!_priceLB)
    {
        _priceLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.commitView.width / 3, 44)];
        _priceLB.text = @"¥ 0";
        _priceLB.textAlignment = NSTextAlignmentCenter;
        _priceLB.textColor = [UIColor mainColor];
        _priceLB.font = [UIFont systemFontOfSize:18];
        _priceLB.layer.cornerRadius = 5;
        _priceLB.layer.masksToBounds = YES;
        _priceLB.backgroundColor = [UIColor colorWithHexString:@"484848"];
    }
    return _priceLB;
}

- (UIButton *)commitButton
{
    if (!_commitButton)
    {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.frame = CGRectMake(self.commitView.width / 3, 20, self.commitView.width / 3 * 2, 44);
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commitButton setTitle:@"确认购买" forState: UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _commitButton.backgroundColor = [UIColor mainColor];
        _commitButton.layer.cornerRadius = 5;
        [_commitButton addTarget:self action:@selector(commitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (UIView *)coustomeView
{
    if (!_coustomeView)
    {
        _coustomeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin)];
        _coustomeView.backgroundColor = [UIColor whiteColor];
        
        [_coustomeView addSubview:self.coustomeHeaderView];
        [_coustomeView addSubview:self.coustomeCollectionView];
        [_coustomeView addSubview:self.coustomePriceLB];
        [_coustomeView addSubview:self.coustomeCommitButton];
    }
    return _coustomeView;
}

- (CoustomeLabelHeaderView *)coustomeHeaderView
{
    if (!_coustomeHeaderView)
    {
        _coustomeHeaderView = [CoustomeLabelHeaderView loadViewFromXIB];
        _coustomeHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 185);
        [_coustomeHeaderView.sureButton addTarget:self action:@selector(coustomeHeaderViewSureButtonCilick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coustomeHeaderView;
}

- (UICollectionView *)coustomeCollectionView
{
    if (!_coustomeCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _coustomeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 185, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 54 - 185) collectionViewLayout:layout];
        [_coustomeCollectionView registerNib:[UINib nibWithNibName:@"GiftCoustomeCCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GiftCoustomeCCellident"];
        _coustomeCollectionView.showsVerticalScrollIndicator = NO;
        _coustomeCollectionView.showsHorizontalScrollIndicator = NO;
        _coustomeCollectionView.backgroundColor = [UIColor whiteColor];
        _coustomeCollectionView.delegate = self ;
        _coustomeCollectionView.dataSource = self ;
    }
    return _coustomeCollectionView;
}

- (UILabel *)coustomePriceLB
{
    if (!_coustomePriceLB)
    {
        _coustomePriceLB = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 54, (SCREEN_WIDTH - 20) / 3, 44)];
        _coustomePriceLB.text = @"¥ 9.9";
        _coustomePriceLB.textAlignment = NSTextAlignmentCenter;
        _coustomePriceLB.textColor = [UIColor mainColor];
        _coustomePriceLB.font = [UIFont systemFontOfSize:18];
        _coustomePriceLB.layer.cornerRadius = 5;
        _coustomePriceLB.layer.masksToBounds = YES;
        _coustomePriceLB.backgroundColor = [UIColor colorWithHexString:@"484848"];
    }
    return _coustomePriceLB;
}

- (UIButton *)coustomeCommitButton
{
    if (!_coustomeCommitButton)
    {
        _coustomeCommitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coustomeCommitButton.frame = CGRectMake(10 + (SCREEN_WIDTH - 20) / 3, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_SafeBottomMargin - 54, (SCREEN_WIDTH - 20) / 3 * 2, 44);
        _coustomeCommitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_coustomeCommitButton setTitle:@"确认购买" forState: UIControlStateNormal];
        [_coustomeCommitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _coustomeCommitButton.backgroundColor = [UIColor mainColor];
        _coustomeCommitButton.layer.cornerRadius = 5;
        [_coustomeCommitButton addTarget:self action:@selector(coustomeCommitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coustomeCommitButton;
}

@end
