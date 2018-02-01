//
//  AllCommentCell.h
//  XYZC
//
//  Created by 贾仕海 on 2018/2/1.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampusInfoCommentModel.h"

@interface AllCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;

@property (nonatomic, strong) CampusInfoCommentModel * model;

@end
