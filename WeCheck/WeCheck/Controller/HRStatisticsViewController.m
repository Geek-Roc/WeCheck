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
@interface HRStatisticsViewController ()<XYPieChartDelegate, XYPieChartDataSource>
@property (weak, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentage1;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentage2;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentage3;
@property (nonatomic, strong) NSMutableArray *slices;
@property (nonatomic, strong) NSArray *sliceColors;
@end

@implementation HRStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    _slices = [NSMutableArray array];
    for(int i = 0; i < 3; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [_slices addObject:one];
    }
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:28]];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setShowPercentage:YES];
    [self.pieChartRight setLabelShadowColor:[UIColor blackColor]];
    [self.view addSubview:_pieChartRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChartRight reloadData];
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

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return _slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [_slices[index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return _sliceColors[index%self.sliceColors.count];
}
#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    if (index == 0) {
        [_lbPercentage1 dd_setNumber:_slices[index] duration:0.5 format:@"%@%%" formatter:nil];
    }
    if (index == 1) {
        [_lbPercentage2 dd_setNumber:_slices[index] format:@"%@%%" formatter:nil];
    }
    if (index == 2) {
        [_lbPercentage3 dd_setNumber:_slices[index] format:@"%@%%" formatter:nil];
    }
}
@end
