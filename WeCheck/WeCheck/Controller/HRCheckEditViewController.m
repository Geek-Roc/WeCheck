//
//  HRCheckEditViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/24.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRCheckEditViewController.h"

@interface HRCheckEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewCheckEdit;
@property (nonatomic, strong) NSMutableArray *mutArrCheckState;
@end

@implementation HRCheckEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mutArrCheckState = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [_mutArrCheckState addObject:@"签到"];
    }
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
- (void)btnCheckAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"签到"]) {
        [sender setTitle:@"迟到" forState:UIControlStateNormal];
        NSIndexPath *indexPath = [_tableViewCheckEdit indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        [_mutArrCheckState replaceObjectAtIndex:indexPath.row withObject:@"迟到"];
        sender.backgroundColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
    }else if ([sender.titleLabel.text isEqualToString:@"迟到"]) {
        [sender setTitle:@"缺席" forState:UIControlStateNormal];
        NSIndexPath *indexPath = [_tableViewCheckEdit indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        [_mutArrCheckState replaceObjectAtIndex:indexPath.row withObject:@"缺席"];
        sender.backgroundColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
    }else {
        [sender setTitle:@"签到" forState:UIControlStateNormal];
        NSIndexPath *indexPath = [_tableViewCheckEdit indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        [_mutArrCheckState replaceObjectAtIndex:indexPath.row withObject:@"签到"];
        sender.backgroundColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mutArrCheckState.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckEditCell" forIndexPath:indexPath];
    [((UIButton *)[cell viewWithTag:1002]) addTarget:self action:@selector(btnCheckAction:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton *)[cell viewWithTag:1002]) setTitle:_mutArrCheckState[indexPath.row] forState:UIControlStateNormal];
    if ([_mutArrCheckState[indexPath.row] isEqualToString:@"签到"]) {
        ((UIButton *)[cell viewWithTag:1002]).backgroundColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
    }else if ([_mutArrCheckState[indexPath.row] isEqualToString:@"迟到"]) {
        ((UIButton *)[cell viewWithTag:1002]).backgroundColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
    }else {
        ((UIButton *)[cell viewWithTag:1002]).backgroundColor = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
    }
    ((UILabel *)[cell viewWithTag:1000]).text = [NSString stringWithFormat:@"张思那%ld", (long)indexPath.row];
    ((UILabel *)[cell viewWithTag:1001]).text = [NSString stringWithFormat:@"20000000%ld", (long)indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    label.text = @"单击按钮改变签到状态";
    return label;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
