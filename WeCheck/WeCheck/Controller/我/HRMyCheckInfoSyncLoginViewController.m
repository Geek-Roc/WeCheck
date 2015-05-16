//
//  MyCheckInfoSyncLoginViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/5/2.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyCheckInfoSyncLoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
@interface HRMyCheckInfoSyncLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfLoginName;
@property (weak, nonatomic) IBOutlet UITextField *tfLoginPassword;

@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation HRMyCheckInfoSyncLoginViewController

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
- (IBAction)btnLoginAction:(UIButton *)sender {
    if ([_tfLoginName.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写邮箱" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (![self isMatchesEmail:_tfLoginName.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邮箱格式不正确" message:@"请检查！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if ([_tfLoginPassword.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写密码" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    [AVUser logInWithUsernameInBackground:_tfLoginName.text password:_tfLoginPassword.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            AVQuery *query1 = [AVQuery queryWithClassName:@"WeCheckDBFile"];
            [query1 whereKey:@"applicantName" equalTo:_tfLoginName.text];
            [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [_HUD removeFromSuperview];
                if (!error) {
                    // 检索成功
                    if (objects.count != 0) {
                        NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
                        AVObject *WeCheckDBFile = [AVObject objectWithClassName:@"WeCheckDBFile"];
                        [WeCheckDBFile setObject:_tfLoginName.text forKey:@"applicantName"];
                        
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentDirectory = [paths objectAtIndex:0];
                        //dbPath： 数据库路径，在Document中。
                        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"wecheck.db"];
                        
                        AVFile *applicantResume1 = [objects[0] objectForKey:@"applicantResumeFile"];
                        NSData *data = [applicantResume1 getData];
                        [data writeToFile:dbPath atomically:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    }                    
                } else {
                    // 输出错误信息
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:error.userInfo[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
@end
