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
#import "HRFMDB.h"
@interface HRScenePeopleStatisticViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BTSpiderPlotterView *spiderView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewScenePeople;

@end

@implementation HRScenePeopleStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _mutDicPeople[@"peopleName"];
    _mutDicPeople = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForEachPeopleDetail:_mutDicPeople];
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
        return [_mutDicPeople[@"checkDetail"] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalAbilityCell" forIndexPath:indexPath];
        
        NSString *stringState = @"0";
        NSString *stringState1 = @"0";
        NSString *stringState2 = @"0";
        if (_mutDicPeople[@"0"])
            stringState = _mutDicPeople[@"0"];
        if (_mutDicPeople[@"1"])
            stringState1 = _mutDicPeople[@"1"];
        if (_mutDicPeople[@"2"])
            stringState2 = _mutDicPeople[@"2"];
        
        NSDictionary *valueDictionary = @{@"迟到":stringState,
                                          @"签到":stringState1,
                                          @"缺席":stringState2};
        _spiderView = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(116, 0, [UIScreen mainScreen].bounds.size.width-116, 200) valueDictionary:valueDictionary];
        [_spiderView setMaxValue:7];
        _spiderView.plotColor = [UIColor blackColor];
        [cell.contentView addSubview:_spiderView];
        
        [(UILabel *)[cell viewWithTag:1001] dd_setNumber:@([stringState integerValue]) format:@"%@次" formatter:nil];
        [(UILabel *)[cell viewWithTag:1002] dd_setNumber:@([stringState1 integerValue]) format:@"%@次" formatter:nil];
        [(UILabel *)[cell viewWithTag:1003] dd_setNumber:@([stringState2 integerValue]) format:@"%@次" formatter:nil];
        ((UILabel *)[cell viewWithTag:1001]).textColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
        ((UILabel *)[cell viewWithTag:1002]).textColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
        ((UILabel *)[cell viewWithTag:1003]).textColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ScenePeopleDetailCell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:2000]).text = _mutDicPeople[@"checkDetail"][indexPath.row][@"checkTime"];
        ((UILabel *)[cell viewWithTag:2001]).text = _mutDicPeople[@"checkDetail"][indexPath.row][@"peopleState"];
        if ([((UILabel *)[cell viewWithTag:2001]).text isEqualToString:@"0"]) {
            ((UILabel *)[cell viewWithTag:2001]).text = @"签到";
            ((UILabel *)[cell viewWithTag:2001]).textColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
        }else if ([((UILabel *)[cell viewWithTag:2001]).text isEqualToString:@"1"]) {
            ((UILabel *)[cell viewWithTag:2001]).text = @"迟到";
            ((UILabel *)[cell viewWithTag:2001]).textColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
        }else {
            ((UILabel *)[cell viewWithTag:2001]).text = @"缺席";
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
        return 44;
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
