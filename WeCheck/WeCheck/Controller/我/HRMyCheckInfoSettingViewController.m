//
//  HRMyCheckInfoSettingViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/5/2.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyCheckInfoSettingViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface HRMyCheckInfoSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewCheckInfoSetting;

@property (nonatomic, strong) AVUser *currentUser;
@end

@implementation HRMyCheckInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentUser = [AVUser currentUser];
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
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyCheckInfoNameCell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:1000]).text = _currentUser.username;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyCheckInfoEmailCell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:2000]).text = _currentUser.email;
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyCheckInfoChangePasswordCell" forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyCheckInfoLogoutCell" forIndexPath:indexPath];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
            [self performSegueWithIdentifier:@"MyCheckInfoChangePasswordSegue" sender:nil];
    }else if (indexPath.section == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出后无法同步，确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [AVUser logOut];  //清除缓存用户对象
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
