//
//  ChoseLabelView.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseLabelViewDelegate <NSObject>

- (void)giftButtonCilick;

@end

@interface ChoseLabelView : UIView

@property (weak, nonatomic) IBOutlet UIView *collectionBackView;
@property (weak, nonatomic) IBOutlet UIView *masView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIButton *giftButton;

@property (nonatomic, strong) id <ChoseLabelViewDelegate> delegate;
@property (nonatomic, assign) int userId;

- (void)showWithView:(UIView *)view;
- (void)canel;

@end
