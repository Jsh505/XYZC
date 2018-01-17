//
//  MyResumeHeaderCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/12.
//  Copyright © 2018年 xyzc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol MyResumeHeaderCellDelegate <NSObject>

- (void)editButton;

@end

@interface MyResumeHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UILabel *emailLB;

@property (nonatomic, strong) id <MyResumeHeaderCellDelegate> delegate;

@property (nonatomic, strong) UserModel * model;

@end
