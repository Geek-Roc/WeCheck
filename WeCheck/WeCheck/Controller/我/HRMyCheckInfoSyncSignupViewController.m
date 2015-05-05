//
//  MyCheckInfoSyncSignupViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/5/2.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyCheckInfoSyncSignupViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
@interface HRMyCheckInfoSyncSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfRegisteName;
@property (weak, nonatomic) IBOutlet UITextField *tfRegistePassword;

@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation HRMyCheckInfoSyncSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)btnRegisteAction:(UIButton *)sender {
    if ([_tfRegisteName.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写邮箱" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (![self isMatchesEmail:_tfRegisteName.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邮箱格式不正确" message:@"请检查！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if ([_tfRegistePassword.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写密码" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    AVUser *user = [AVUser user];
    user.username = _tfRegisteName.text;
    user.password = _tfRegistePassword.text;
    user.email = _tfRegisteName.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [_HUD removeFromSuperview];
        if (succeeded) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败" message:error.userInfo[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (BOOL)isMatchesEmail:(NSString *)string {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}
@end
