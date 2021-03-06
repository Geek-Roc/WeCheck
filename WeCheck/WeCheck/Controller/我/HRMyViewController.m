//
//  HRMeViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/21.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyViewController.h"
#import "HRMyCheckInfoEditViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
#import "HRFMDB.h"
@interface HRMyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewMeSetting;

//签到信息
@property (nonatomic, strong) NSDictionary *dicCheckInfo;
@property (nonatomic, strong) NSMutableArray *mutArrCheckInfo;
//进度条
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation HRMyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _dicCheckInfo = [[HRFMDB shareFMDBManager] queryInKeyValueTable:@"HRCheckInfo"];
    _mutArrCheckInfo = [NSMutableArray arrayWithArray:[[HRFMDB shareFMDBManager] queryInKeyValueTable:@"HRCheckInfoList"]];
    [_tableViewMeSetting reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HRMyCheckInfoEditViewController class]]) {
        HRMyCheckInfoEditViewController *hrmcievc = segue.destinationViewController;
        hrmcievc.dic = sender;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
#pragma mark - function
- (IBAction)btnSyncAction:(UIBarButtonItem *)sender {
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        [_HUD show:YES];
        //服务器上检索文件
        AVQuery *query1 = [AVQuery queryWithClassName:@"WeCheckDBFile"];
        [query1 whereKey:@"applicantName" equalTo:currentUser.username];
        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // 检索成功
                if (objects.count != 0) {
                    NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
                    AVObject *WeCheckDBFile = [AVObject objectWithClassName:@"WeCheckDBFile"];
                    [WeCheckDBFile setObject:currentUser.username forKey:@"applicantName"];
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentDirectory = [paths objectAtIndex:0];
                    //dbPath： 数据库路径，在Document中。
                    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"wecheck.db"];
                    AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"wecheck-%@.db", currentUser.username] contentsAtPath:dbPath];
                    //旧文件
                    AVFile *oldFile = [objects[0] objectForKey:@"applicantResumeFile"];
                    [objects[0] setObject:file forKey:@"applicantResumeFile"];
                    [objects[0] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        NSLog(@"1");
                        //删除云端旧文件
                        [oldFile deleteInBackground];
                        [_HUD removeFromSuperview];
                    }];
                }
            } else {
                // 输出错误信息
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        NSLog(@"同步");
    } else {
        //未登录跳转登录页面
        [self performSegueWithIdentifier:@"MyCheckInfoSyncLoginSegue" sender:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return _mutArrCheckInfo.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
        return YES;
    else
        return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[HRFMDB shareFMDBManager] setInToKeyValueTable:_mutArrCheckInfo forKey:@"HRCheckInfoList"];
    [_mutArrCheckInfo removeObjectAtIndex:indexPath.row];
    [_tableViewMeSetting deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyHeadSettingCell" forIndexPath:indexPath];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyNameSettingCell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:2001]).text = _dicCheckInfo[@"HRCheckInfoName"];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyNumberSettingCell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:3001]).text = _dicCheckInfo[@"HRCheckInfoNumber"];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MySceneSettingCell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:4001]).text = _dicCheckInfo[@"HRCheckInfoScene"];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MySceneSettingCell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:4001]).text = _mutArrCheckInfo[indexPath.row][@"HRCheckInfoScene"];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 68;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([AVUser currentUser])
                [self performSegueWithIdentifier:@"MyCheckInfoSettingSegue" sender:nil];
            else
                [self performSegueWithIdentifier:@"MyCheckInfoSyncLoginSegue" sender:nil];
        }else if (indexPath.row == 1) {
            if (_dicCheckInfo) {
                NSDictionary *dic = @{@"didSelectCell":@"名字",
                                      @"checkInfo":_dicCheckInfo};
                [self performSegueWithIdentifier:@"MyCheckInfoEditSegue" sender:dic];
            }
        }else if (indexPath.row == 2) {
            if (_dicCheckInfo) {
                NSDictionary *dic = @{@"didSelectCell":@"代号",
                                      @"checkInfo":_dicCheckInfo};
                [self performSegueWithIdentifier:@"MyCheckInfoEditSegue" sender:dic];
            }
        }
    }else if (indexPath.section == 1) {
        [[HRFMDB shareFMDBManager] setInToKeyValueTable:_mutArrCheckInfo[indexPath.row] forKey:@"HRCheckInfo"];
        _dicCheckInfo = _mutArrCheckInfo[indexPath.row];
        [_tableViewMeSetting reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
