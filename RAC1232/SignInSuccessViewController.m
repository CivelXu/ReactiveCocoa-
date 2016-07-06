//
//  SignInSuccessViewController.m
//  RAC1232
//
//  Created by XRG on 16/4/14.
//  Copyright © 2016年 XRG. All rights reserved.
//

#import "SignInSuccessViewController.h"

@interface SignInSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iamge;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SignInSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.iamge addGestureRecognizer:tap];
}

- (void)tap{

    self.iamge.image = [UIImage imageNamed:@"200"];
    
    self.label.text = @"你说什么?! 大点声!";


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
