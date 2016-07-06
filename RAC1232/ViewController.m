//
//  ViewController.m
//  RAC1232
//
//  Created by XRG on 16/4/14.
//  Copyright © 2016年 XRG. All rights reserved.
//

#import "ViewController.h"
#import "RWDummySignInService.h"
#import "SignInSuccessViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>





@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;


@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    [self updateUIState];

    self.signInService = [RWDummySignInService new];
    // handle text changes for both text fields
//    [self.userTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
//    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];

    // initially hide the failure message
    self.signInLabel.hidden = YES;
    
    
    // 第一步 - 试水
    
//    [self.userTextField.rac_textSignal subscribeNext:^(id x) {
//       
//        NSLog(@"%@",x);
//        
//    }];
    
    
    // subscriber .总共有三个类型 [next , error , completed]
    
//    RACSignal *userSignal = self.userTextField.rac_textSignal;
//    [userSignal subscribeNext:^(id x) {
//        
//    }];

    
    // 第二步 小练 [filter] 添加条件 : 当输入字符数量大于3的时候,在打印
    
//    [[self.userTextField.rac_textSignal filter:^BOOL(id value) {
//       
//        NSString *str = value;
//        return str.length > 3;
//        
//    }] subscribeNext:^(id x) {
//      
//        NSLog(@"%@", x);
//    }];
    
//    RACSignal *userTextSignal = self.userTextField.rac_textSignal;
//    [[userTextSignal filter:^BOOL(id value) {
//       
//        NSString *str = value;
//        return str.length > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
    
    // 第三步 - 升级 :map[改变数据]
    
//    [[[self.userTextField.rac_textSignal map:^id(NSString *value) {
//        return @(value.length);
//    }] filter:^BOOL(NSNumber *value) {
//        
//        return [value integerValue] > 3;
//    }] subscribeNext:^(id x) {
//        
//        NSLog(@"%@", x);
//    }];
    
//    [[[self.userTextField.rac_textSignal filter:^BOOL(NSString *value) {
//        return value.length > 3;
//    }] map:^id(NSString *value) {
//        return @(value.length);
//    }] subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//
//    }];
    
    // 第四步: 出山
    RACSignal *vaildUser = [self.userTextField.rac_textSignal map:^id(NSString  *value) {
        return @([self isValidUsername:value]);
    }];
    
    RACSignal *vaildPassWord = [self.passwordTextField.rac_textSignal map:^id(NSString *value) {
        return @([self isValidPassword:value]);
    }];
    
    // 背景颜色改变
    
//    [[vaildUser map:^id(NSNumber *value) {
//       
//        return [value boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
//    }] subscribeNext:^(UIColor *x) {
//        self.userTextField.backgroundColor = x;
//    }];
//    
//    
//    [[vaildPassWord map:^id(NSNumber *value) {
//        
//        return [value boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
//    }] subscribeNext:^(UIColor *x) {
//        self.userTextField.backgroundColor = x;
//    }];
    
    
    RAC(self.userTextField, backgroundColor) = [vaildUser map:^id(NSNumber *value) {
       
        return [value boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    }];
    
    
    RAC(self.passwordTextField, backgroundColor) = [vaildPassWord map:^id(NSNumber *value) {
        
        return [value boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    }];
    
    // 聚合信号
    
    RACSignal *signUpSignal = [RACSignal combineLatest:@[vaildUser, vaildPassWord] reduce:^id (NSNumber *user, NSNumber *pass){
        return @(user.boolValue && pass.boolValue);
    }];
    
    [signUpSignal subscribeNext:^(NSNumber *x) {
        self.signButton.enabled = x;
    }];
    
    
    // 初级
    
//    [[self.signButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//       
//        NSLog(@"点击登录");
//    }];
 
    // 中级
//    
//    [[[self.signButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
//        return [self creatSignInSignal];
//    }] subscribeNext:^(NSNumber *x) {
//        BOOL success = x.boolValue;
//        self.signInLabel.hidden = success;
//        if (success) {
//            SignInSuccessViewController *vc = [[SignInSuccessViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
    
    
    // 完整版的Button

    
    [[[[self.signButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        self.signButton.enabled = NO;
        self.signInLabel.hidden = YES;
    }] flattenMap:^RACStream *(id value) {
        return [self creatSignInSignal];
    }] subscribeNext:^(NSNumber *x) {
        BOOL success = x.boolValue;
        self.signInLabel.hidden = success;
        if (success) {
            SignInSuccessViewController *vc = [[SignInSuccessViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }];
    
    
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

//- (void)updateUIState {
//    self.userTextField.backgroundColor = self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
//    self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
//    self.signButton.enabled = self.usernameIsValid && self.passwordIsValid;
//}
//
//- (void)usernameTextFieldChanged {
//    self.usernameIsValid = [self isValidUsername:self.userTextField.text];
//    [self updateUIState];
//}
//
//- (void)passwordTextFieldChanged {
//    self.passwordIsValid = [self isValidPassword:self.passwordTextField.text];
//    [self updateUIState];
//}

//
//- (IBAction)signInAction:(id)sender {
////    NSLog(@"点击登录");
//    // disable all UI controls
//    self.signButton.enabled = NO;
//    self.signInLabel.hidden = YES;
//
//    // sign in
//    [self.signInService signInWithUsername:self.userTextField.text
//                                  password:self.passwordTextField.text
//                                  complete:^(BOOL success) {
//                                      self.signButton.enabled = YES;
//                                      self.signInLabel.hidden = success;
//                                      if (success) {
//                                          SignInSuccessViewController *vc = [[SignInSuccessViewController alloc] init];
//                                          [self.navigationController pushViewController:vc animated:YES];
//                                          
//                                      }
//                                  }];
//}

- (RACSignal *)creatSignInSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       [self.signInService signInWithUsername:self.userTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
          
           [subscriber sendNext:@(success)];
           [subscriber sendCompleted];
           
       }];
        return nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
