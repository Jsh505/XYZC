//
//  ArticleInfoCommentCell.h
//  XYZC
//
//  Created by 贾仕海 on 2018/1/31.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampusInfoCommentModel.h"

@protocol ArticleInfoCommentCellDelegate <NSObject>

- (void)commentNameLBCilickWithModel:(BaseModel *)model;

@end


@interface ArticleInfoCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLB;

@property (nonatomic, strong) CampusInfoCommentModel * model;
@property (nonatomic, strong) id <ArticleInfoCommentCellDelegate> delegate;

@end
