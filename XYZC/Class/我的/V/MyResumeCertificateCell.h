//
//  MyResumeCertificateCell.h
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/12.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyResumeCertificateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;

@property (nonatomic, strong) NSDictionary * model;

@end
