//
//  ChoseLabelView.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/9.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseLabelView : UIView

@property (weak, nonatomic) IBOutlet UIView *collectionBackView;
@property (weak, nonatomic) IBOutlet UIView *masView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (void)showWithView:(UIView *)view;
- (void)canel;

@end
