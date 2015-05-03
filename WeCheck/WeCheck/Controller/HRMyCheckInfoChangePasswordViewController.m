//
//  MyCheckInfoChangePasswordViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/5/2.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyCheckInfoChangePasswordViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
@interface HRMyCheckInfoChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfChangePasswordOld;
@property (weak, nonatomic) IBOutlet UITextField *tfChangePasswordNew;

@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation HRMyCheckInfoChangePasswordViewController

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
- (IBAction)btnChangePasswordAction:(UIButton *)sender {
    if ([_tfChangePasswordOld.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写旧密码" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if ([_tfChangePasswordNew.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写新密码" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    AVUser *currentUser = [AVUser currentUser];
    //请确保用户当前的有效登录状态
    [AVUser logInWithUsernameInBackground:currentUser.username password:_tfChangePasswordOld.text block:^(AVUser *user, NSError *error) {
        [[AVUser currentUser] updatePassword:_tfChangePasswordOld.text newPassword:_tfChangePasswordNew.text block:^(id object, NSError *error) {
            [_HUD removeFromSuperview];
            if (!error) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改失败" message:error.userInfo[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }];
}

@end