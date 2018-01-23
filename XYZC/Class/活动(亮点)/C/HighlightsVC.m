//
//  HighlightsVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/29.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import "HighlightsVC.h"
#import "HighlightsTitleCell.h"
#import "HighlightsListCell.h"
#import "CampusDisplayVC.h"

@interface HighlightsVC ()

@end

@implementation HighlightsVC



#pragma mark - Lifecycle(生命周期)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatHighlightsView];
    
}

#pragma mark - Custom Accessors (控件响应方法)


#pragma mark - IBActions(xib响应方法)


#pragma mark - Public (.h 公共调用方法)


#pragma mark - Private (.m 私有方法)

-(void)creatHighlightsView
{
    self.customNavBar.title = @"亮点";
    
    [self.view addSubview:self.coustromTableView];
    
    self.coustromTableView.sd_layout
    .topSpaceToView(self.customNavBar, 0)
    .heightIs(SCREEN_HEIGHT - JSH_NavbarAndStatusBarHeight - JSH_TabBarHeight)
    .widthIs(SCREEN_WIDTH)
    .leftSpaceToView(self.view, 0);
}


#pragma mark - Deletate/DataSource (相关代理)

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return SCREEN_WIDTH * 120 / 600;
    }
    else
    {
        return SCREEN_WIDTH * 350 / 600;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        HighlightsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HighlightsTitleCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"HighlightsTitleCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        HighlightsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HighlightsListCellident"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"HighlightsListCell" owner:nil options:nil];
            cell = array[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 1)
        {
            cell.headerView.image = [UIImage imageNamed:@"亮点_2"];
        }
        else
        {
            cell.headerView.image = [UIImage imageNamed:@"亮点_3"];
        }
        return cell;
    }
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CampusDisplayVC * vc = [[CampusDisplayVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Setter/Getter


@end
