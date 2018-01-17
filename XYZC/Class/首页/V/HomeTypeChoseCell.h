//
//  HomeTypeChoseCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2017/12/28.
//  Copyright © 2017年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HomeTypeChoseCellButtonType)
{
    testButton,
    findJobButton,
    findPeiXunButton,
    tishengButton,
};

@protocol HomeTypeChoseCellDelegate <NSObject>

- (void)choseButtonCilickWithType:(HomeTypeChoseCellButtonType)type;

@end

@interface HomeTypeChoseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *findJobButton;
@property (weak, nonatomic) IBOutlet UIButton *findPeiXunButton;
@property (weak, nonatomic) IBOutlet UIButton *tishengButton;

@property (nonatomic, strong) id<HomeTypeChoseCellDelegate> delegate;

@end
