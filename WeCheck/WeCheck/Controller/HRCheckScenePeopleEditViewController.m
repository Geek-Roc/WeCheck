//
//  HRCheckScenePeopleEditViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/29.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRCheckScenePeopleEditViewController.h"

@interface HRCheckScenePeopleEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewCheckScenePeopleEdit;

@end

@implementation HRCheckScenePeopleEditViewController

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
- (IBAction)btnSaveCheckScenePeopleAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCancleAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleNameSettingCell" forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleNumberSettingCell" forIndexPath:indexPath];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
@end
