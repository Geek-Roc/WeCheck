//
//  HRMySettingAddViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/28.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyCheckInfoAddViewController.h"

@interface HRMyCheckInfoAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewAddCheckInfo;

@end

@implementation HRMyCheckInfoAddViewController

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
#pragma mark - function
- (IBAction)btnSaveCheckInfoAction:(UIBarButtonItem *)sender {
    if ([((UITextField *)[_tableViewAddCheckInfo viewWithTag:1000]).text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写名字" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if ([((UITextField *)[_tableViewAddCheckInfo viewWithTag:2000]).text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写代号" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if ([((UITextField *)[_tableViewAddCheckInfo viewWithTag:3000]).text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写签到情景" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSDictionary *dicCheckInfo = @{@"HRCheckInfoName":((UITextField *)[_tableViewAddCheckInfo viewWithTag:1000]).text,
                                   @"HRCheckInfoNumber":((UITextField *)[_tableViewAddCheckInfo viewWithTag:2000]).text,
                                   @"HRCheckInfoScene":((UITextField *)[_tableViewAddCheckInfo viewWithTag:3000]).text};
    [[NSUserDefaults standardUserDefaults] setObject:dicCheckInfo forKey:@"HRCheckInfo"];
    NSMutableArray *mutArrCheckInfo = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"HRCheckInfoList"]];
    if (![mutArrCheckInfo containsObject:dicCheckInfo]) {
        [mutArrCheckInfo addObject:dicCheckInfo];
        [[NSUserDefaults standardUserDefaults] setObject:mutArrCheckInfo forKey:@"HRCheckInfoList"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyNameSettingCell" forIndexPath:indexPath];
    }else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyNumberSettingCell" forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MySceneSettingCell" forIndexPath:indexPath];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
@end
