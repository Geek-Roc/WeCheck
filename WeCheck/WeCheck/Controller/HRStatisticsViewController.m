//
//  HRStatisticsViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/16.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRStatisticsViewController.h"
#import "XYPieChart.h"
#import "UILabel+FlickerNumber.h"
#import "UUChart.h"
#import "HRFMDB.h"
@interface HRStatisticsViewController ()<XYPieChartDelegate, XYPieChartDataSource, UUChartDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewStatistics;
@property (nonatomic, strong) NSMutableArray *slices;
@property (nonatomic, strong) NSArray *sliceColors;

//情景数组
@property (nonatomic, strong) NSMutableArray *mutArrEachScenes;
@property (nonatomic, strong) NSDictionary *dicScenes;
@property (nonatomic, strong) NSString *stringNumber0;
@property (nonatomic, strong) NSString *stringNumber1;
@property (nonatomic, strong) NSString *stringNumber2;
@end

@implementation HRStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sliceColors =[NSArray arrayWithObjects:
                   [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],/*绿色*/
                   [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],/*蓝色*/
                   [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],/*橙色*/
                   [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],/*红色*/
                   [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1]/*灰色*/,nil];
    _slices = [NSMutableArray array];
    _dicScenes = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForAllScene];
    [_slices addObject:@([_dicScenes[@"0"] integerValue])];
    [_slices addObject:@([_dicScenes[@"1"] integerValue])];
    [_slices addObject:@([_dicScenes[@"2"] integerValue])];
    _stringNumber0 = [NSString stringWithFormat:@"%0.2f", 100*[_dicScenes[@"0"] floatValue]/([_dicScenes[@"0"] floatValue]+[_dicScenes[@"1"] floatValue]+[_dicScenes[@"2"] floatValue])];
    _stringNumber1 = [NSString stringWithFormat:@"%0.2f", 100*[_dicScenes[@"1"] floatValue]/([_dicScenes[@"0"] floatValue]+[_dicScenes[@"1"] floatValue]+[_dicScenes[@"2"] floatValue])];
    _stringNumber2 = [NSString stringWithFormat:@"%0.2f", 100*[_dicScenes[@"2"] floatValue]/([_dicScenes[@"0"] floatValue]+[_dicScenes[@"1"] floatValue]+[_dicScenes[@"2"] floatValue])];
    _mutArrEachScenes = [[HRFMDB shareFMDBManager] queryInCheckRecordTableForEachScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [(XYPieChart *)[_tableViewStatistics viewWithTag:1000] reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return _slices.count;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return [_slices[index] intValue];
}
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return _sliceColors[index%self.sliceColors.count];
}
- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    return @"123";
}
#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index {
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    if (index == 0) {
        [(UILabel *)[_tableViewStatistics viewWithTag:1001] dd_setNumber:@([_stringNumber0 floatValue]) format:@"%@%%" formatter:nil];
    }
    if (index == 1) {
        [(UILabel *)[_tableViewStatistics viewWithTag:1002] dd_setNumber:@([_stringNumber1 floatValue]) format:@"%@%%" formatter:nil];
    }
    if (index == 2) {
        [(UILabel *)[_tableViewStatistics viewWithTag:1003] dd_setNumber:@([_stringNumber2 floatValue]) format:@"%@%%" formatter:nil];
    }
}
#pragma mark - UUChartDataSource
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < _mutArrEachScenes.count/3+1; i++) {
        [arr addObject:_mutArrEachScenes[i*3][@"checkScene"]];
    }
    return arr;
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart {
    NSMutableArray *arr = [NSMutableArray array];
    if (chart.tag == 0) {
        for (int i = 0; i < _mutArrEachScenes.count/3+1; i++) {
            [arr addObject:_mutArrEachScenes[i][@"0"]];
        }
    }else if (chart.tag == 1) {
        for (int i = 0; i < _mutArrEachScenes.count/3+1; i++) {
            [arr addObject:_mutArrEachScenes[i*2][@"1"]];
        }
    }else if (chart.tag == 2) {
        for (int i = 0; i < _mutArrEachScenes.count/3+1; i++) {
            [arr addObject:_mutArrEachScenes[i*3][@"2"]];
        }
    }
    return @[arr];
}
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    if (chart.tag == 0) {
        return @[[UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1]];
    }else if (chart.tag == 1) {
        return @[[UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1]];
    }else if (chart.tag == 2) {
        return @[[UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1]];
    }
    return @[UURed,UUGreen,UUBrown];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else if (section == 1)
        return 3;
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticsTotalityCell" forIndexPath:indexPath];
        [(UILabel *)[cell viewWithTag:1001] dd_setNumber:@([_stringNumber0 floatValue]) format:@"%@%%" formatter:nil];
        [(UILabel *)[cell viewWithTag:1002] dd_setNumber:@([_stringNumber1 floatValue]) format:@"%@%%" formatter:nil];
        [(UILabel *)[cell viewWithTag:1003] dd_setNumber:@([_stringNumber2 floatValue]) format:@"%@%%" formatter:nil];
        ((UILabel *)[cell viewWithTag:1001]).textColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
        ((UILabel *)[cell viewWithTag:1002]).textColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
        ((UILabel *)[cell viewWithTag:1003]).textColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
        
        ((XYPieChart *)[cell viewWithTag:1000]).delegate = self;
        ((XYPieChart *)[cell viewWithTag:1000]).labelFont =  [UIFont systemFontOfSize:28];
        ((XYPieChart *)[cell viewWithTag:1000]).dataSource = self;
        ((XYPieChart *)[cell viewWithTag:1000]).animationSpeed = 1.0;
        ((XYPieChart *)[cell viewWithTag:1000]).startPieAngle = M_PI_2;
        ((XYPieChart *)[cell viewWithTag:1000]).showPercentage = YES;
        ((XYPieChart *)[cell viewWithTag:1000]).labelShadowColor = [UIColor blackColor];
        [(XYPieChart *)[cell viewWithTag:1000] reloadData];
    }
    else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticsEachCell" forIndexPath:indexPath];
        UUChart *chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 150)
                                                           withSource:self
                                                            withStyle:UUChartBarStyle];
        chartView.tag = indexPath.row;
        [chartView showInView:cell];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 201;
    else
        return 164;
}
@end
