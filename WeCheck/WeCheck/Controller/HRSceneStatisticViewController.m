//
//  HRSceneStatisticsViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/23.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRSceneStatisticViewController.h"
#import "UILabel+FlickerNumber.h"
@interface HRSceneStatisticViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewSenceStatistics;
@property (weak, nonatomic) IBOutlet UILabel *labSignRate;
@property (nonatomic, strong) UIButton *btnSignRate;
@property (weak, nonatomic) IBOutlet UILabel *labLateRate;
@property (nonatomic, strong) UIButton *btnLateRate;
@property (weak, nonatomic) IBOutlet UILabel *labAbsentRate;
@property (nonatomic, strong) UIButton *btnAbsentRate;

@end

@implementation HRSceneStatisticViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnSignRate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSignRate.backgroundColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
    _btnSignRate.frame = CGRectMake(162, 71, [UIScreen mainScreen].bounds.size.width - 178, 24);
    
    _btnLateRate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLateRate.frame = CGRectMake(162, 100, [UIScreen mainScreen].bounds.size.width - 178, 24);
    _btnLateRate.backgroundColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
    
    _btnAbsentRate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAbsentRate.frame = CGRectMake(162, 129, [UIScreen mainScreen].bounds.size.width - 178, 24);
    _btnAbsentRate.backgroundColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
    
    [self.view addSubview:_btnSignRate];
    [self.view addSubview:_btnLateRate];
    [self.view addSubview:_btnAbsentRate];
    
    [_labSignRate dd_setNumber:@98.07 format:@"%@%%" formatter:nil];
    _labSignRate.textColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
    [_labLateRate dd_setNumber:@98.03 format:@"%@%%" formatter:nil];
    _labLateRate.textColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
    [_labAbsentRate dd_setNumber:@98.01 format:@"%@%%" formatter:nil];
    _labAbsentRate.textColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
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
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScenePeopleCell" forIndexPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ScenePeopleStatisticSegue" sender:nil];
}
@end
