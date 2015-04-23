//
//  HRScenePeopleStatisticViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/23.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRScenePeopleStatisticViewController.h"
#import "BTSpiderPlotterView.h"
@interface HRScenePeopleStatisticViewController ()
@property (nonatomic, strong) BTSpiderPlotterView *spiderView;
@end

@implementation HRScenePeopleStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //create a random value dictionary
    //data represent a review rating for a device by The Verge
    NSDictionary *valueDictionary = @{@"迟到":@"0",
                                      @"未到":@"2",
                                      @"签到":@"6"};
    //initiate a view with the value
    _spiderView = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 300) valueDictionary:valueDictionary];
    [_spiderView setMaxValue:10];
    //spiderView.plotColor = [UIColor colorWithRed:.8 green:.4 blue:.3 alpha:.7];
    [self.view addSubview:_spiderView];
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
@end
