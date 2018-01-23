//
//  FollowCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/3.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansModel.h"

@protocol FollowCellDelegate <NSObject>

- (void)moreButton:(UIButton *)button Model:(FansModel *)model;

@end

@interface FollowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *cilickButton;

@property (nonatomic, strong) FansModel * model;
@property (nonatomic, strong) id <FollowCellDelegate> delegate;

@end
