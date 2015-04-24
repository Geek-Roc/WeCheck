//
//  HRScenePeopleStatisticViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/23.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRScenePeopleStatisticViewController.h"
#import "BTSpiderPlotterView.h"
#import "UILabel+FlickerNumber.h"
@interface HRScenePeopleStatisticViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BTSpiderPlotterView *spiderView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewScenePeople;

@end

@implementation HRScenePeopleStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    if (section == 0)
        return 1;
    else
        return 12;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalAbilityCell" forIndexPath:indexPath];
        
        NSDictionary *valueDictionary = @{@"迟到":@"1",
                                          @"签到":@"12",
                                          @"缺席":@"0"};
        _spiderView = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(116, 0, [UIScreen mainScreen].bounds.size.width-116, 200) valueDictionary:valueDictionary];
        [_spiderView setMaxValue:7];
        _spiderView.plotColor = [UIColor blackColor];
        [cell.contentView addSubview:_spiderView];
        
        [(UILabel *)[cell viewWithTag:1001] dd_setNumber:@12 format:@"%@次" formatter:nil];
        [(UILabel *)[cell viewWithTag:1002] dd_setNumber:@1 format:@"%@次" formatter:nil];
        [(UILabel *)[cell viewWithTag:1003] dd_setNumber:@0 format:@"%@次" formatter:nil];
        ((UILabel *)[cell viewWithTag:1001]).textColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
        ((UILabel *)[cell viewWithTag:1002]).textColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
        ((UILabel *)[cell viewWithTag:1003]).textColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ScenePeopleDetailCell" forIndexPath:indexPath];
        if ([((UILabel *)[cell viewWithTag:2001]).text isEqualToString:@"签到"]) {
            ((UILabel *)[cell viewWithTag:2001]).textColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
        }else if ([((UILabel *)[cell viewWithTag:2001]).text isEqualToString:@"迟到"]) {
            ((UILabel *)[cell viewWithTag:2001]).textColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
        }else {
            ((UILabel *)[cell viewWithTag:2001]).textColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
        }
        
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 201;
    else
        return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:17];
    label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    label.text = section ? @"个人签到记录：":@"个人签到综合能力：";
    return label;
}

@end
