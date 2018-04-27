//
//  MyArticleVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/3.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "MyArticleVC.h"
#import "ArticleListCell.h"
#import "MyArtileNewModel.h"

@interface MyArticleVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation MyArticleVC

#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self creatMyArticleView];
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc] init];
    [parametersDic setObject:@([UserSignData share].user.userId) forKey:@"userId"];
    
    [PPNetworkHelper POST:@"queryArticleListByUserId.app" parameters:parametersDic hudString:@"加载中..." success:^(id responseObject)
     {
         if ([responseObject objectForKey:@"articleList"])
         {
             [self.dataSource removeAllObjects];
             
             for (NSDictionary * dic in [responseObject objectForKey:@"articleList"])
             {
                 MyArtileNewModel * model = [[MyArtileNewModel alloc] initWithDictionary:dic];
                 [self.dataSource addObject:model];
             }
             [self.coustromTableView reloadData];
         }
    } failure:^(NSString *error)
     {
         [MBProgressHUD showErrorMessage:error];
    }];
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

- (void)creatMyArticleView
{
    self.customNavBar.title = @"我的文章";
    
    self.coustromTableView.frame = CGRectMake(0, JSH_NavbarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight);
    [self.view addSubview:self.coustromTableView];
}


#pragma mark - Deletate/DataSource (相关代理)

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 275 / 375;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleListCellident"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ArticleListCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyArtileNewModel * model = self.dataSource[indexPath.row];
    cell.ArtileNewModel = model;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Setter/Getter

@end
