//
//  AboutVC.m
//  笑园之窗
//
//  Created by 贾仕海 on 2018/1/2.
//  Copyright © 2018年 xyzc. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *leavelLB;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.title = @"关于笑园之星";
    
    self.headerImage.layer.cornerRadius = 5;
    self.headerImage.layer.masksToBounds = YES;
    self.leavelLB.layer.cornerRadius = 5;
    self.leavelLB.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"F4F5F6"];
}
- (IBAction)phoneButton:(id)sender
{
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", @"400-166-3466"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}
- (IBAction)emailButton:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
