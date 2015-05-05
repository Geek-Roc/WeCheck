//
//  MyCheckInfoResetPasswordViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/5/2.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyCheckInfoResetPasswordViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
@interface HRMyCheckInfoResetPasswordViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfRegisteEmail;

@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation HRMyCheckInfoResetPasswordViewController

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
- (IBAction)btnResetPasswordAction:(UIButton *)sender {
    if ([_tfRegisteEmail.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写邮箱" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (![self isMatchesEmail:_tfRegisteEmail.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邮箱格式不正确" message:@"请检查！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    [AVUser requestPasswordResetForEmailInBackground:_tfRegisteEmail.text block:^(BOOL succeeded, NSError *error) {
        [_HUD removeFromSuperview];
        if (succeeded) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重设成功" message:@"请查收邮件设置密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.delegate = self;
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重设失败" message:error.userInfo[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}
#pragma mark - function
- (BOOL)isMatchesEmail:(NSString *)string {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
