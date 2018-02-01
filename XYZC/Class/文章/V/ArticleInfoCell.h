//
//  ArticleInfoCell.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCommentModel.h"
#import "CampusInfoCommentModel.h"

@protocol ArticleInfoCellDelegate <NSObject>

- (void)commentButtonCilickWithModel:(BaseModel *)model;
- (void)headerImageViewCilickWithModel:(BaseModel *)model;

@end

@interface ArticleInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;

@property (nonatomic, strong) id <ArticleInfoCellDelegate> delegate;
@property (nonatomic, strong) ArticleCommentModel * model;
@property (nonatomic, strong) CampusInfoCommentModel * campusInfoModel;
@end
