//
//  HRSceneStatisticsViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/23.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRSceneStatisticViewController.h"
#import "HRScenePeopleStatisticViewController.h"
#import "UILabel+FlickerNumber.h"
#import "HRFMDB.h"
@interface HRSceneStatisticViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewSenceStatistics;
@property (weak, nonatomic) IBOutlet UILabel *labSignRate;
@property (nonatomic, strong) UIButton *btnSignRate;
@property (weak, nonatomic) IBOutlet UILabel *labLateRate;
@property (nonatomic, strong) UIButton *btnLateRate;
@property (weak, nonatomic) IBOutlet UILabel *labAbsentRate;
@property (nonatomic, strong) UIButton *btnAbsentRate;

//签到状态数组
@property (nonatomic, strong) NSMutableArray *mutArrPeoples;
@end

@implementation HRSceneStatisticViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _dicScene[@"checkScene"];
    
    NSString *stringNumber0 = [NSString stringWithFormat:@"%0.2f", 100*[_dicScene[@"0"] floatValue]/([_dicScene[@"0"] floatValue]+[_dicScene[@"1"] floatValue]+[_dicScene[@"2"] floatValue])];
    NSString *stringNumber1 = [NSString stringWithFormat:@"%0.2f", 100*[_dicScene[@"1"] floatValue]/([_dicScene[@"0"] floatValue]+[_dicScene[@"1"] floatValue]+[_dicScene[@"2"] floatValue])];
    NSString *stringNumber2 = [NSString stringWithFormat:@"%0.2f", 100*[_dicScene[@"2"] floatValue]/([_dicScene[@"0"] floatValue]+[_dicScene[@"1"] floatValue]+[_dicScene[@"2"] floatValue])];
    
    _btnSignRate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSignRate.backgroundColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
    _btnSignRate.frame = CGRectMake(162, 71, ([UIScreen mainScreen].bounds.size.width - 178)*[stringNumber0 floatValue]/100, 24);
    
    _btnLateRate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLateRate.frame = CGRectMake(162, 100, ([UIScreen mainScreen].bounds.size.width - 178)*[stringNumber1 floatValue]/100, 24);
    _btnLateRate.backgroundColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
    
    _btnAbsentRate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAbsentRate.frame = CGRectMake(162, 129, ([UIScreen mainScreen].bounds.size.width - 178)*[stringNumber2 floatValue]/100, 24);
    _btnAbsentRate.backgroundColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
    
    [self.view addSubview:_btnSignRate];
    [self.view addSubview:_btnLateRate];
    [self.view addSubview:_btnAbsentRate];
    
    [_labSignRate dd_setNumber:@([stringNumber0 floatValue]) format:@"%@%%" formatter:nil];
    _labSignRate.textColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
    [_labLateRate dd_setNumber:@([stringNumber1 floatValue]) format:@"%@%%" formatter:nil];
    _labLateRate.textColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
    [_labAbsentRate dd_setNumber:@([stringNumber2 floatValue]) format:@"%@%%" formatter:nil];
    _labAbsentRate.textColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
    
    _mutArrPeoples = [[HRFMDB shareFMDBManager] queryInCheckSceneTable:_dicScene[@"checkScene"]];
    _mutArrPeoples = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForEachPeople:_mutArrPeoples];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HRScenePeopleStatisticViewController class]]) {
        HRScenePeopleStatisticViewController *hrspsvc = segue.destinationViewController;
        hrspsvc.mutDicPeople= sender;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mutArrPeoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScenePeopleCell" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1000]).text = _mutArrPeoples[indexPath.row][@"peopleName"];
    if (_mutArrPeoples[indexPath.row][@"0"])
        ((UILabel *)[cell viewWithTag:1001]).text = [NSString stringWithFormat:@"%@次",_mutArrPeoples[indexPath.row][@"0"]];
    else
        ((UILabel *)[cell viewWithTag:1001]).text = @"0次";
    if (_mutArrPeoples[indexPath.row][@"1"])
        ((UILabel *)[cell viewWithTag:1002]).text = [NSString stringWithFormat:@"%@次",_mutArrPeoples[indexPath.row][@"1"]];
    else
        ((UILabel *)[cell viewWithTag:1002]).text = @"0次";
    if (_mutArrPeoples[indexPath.row][@"2"])
        ((UILabel *)[cell viewWithTag:1003]).text = [NSString stringWithFormat:@"%@次",_mutArrPeoples[indexPath.row][@"2"]];
    else
        ((UILabel *)[cell viewWithTag:1003]).text = @"0次";
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ScenePeopleStatisticSegue" sender:_mutArrPeoples[indexPath.row]];
}
@end
