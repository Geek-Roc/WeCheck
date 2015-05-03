//
//  HRCheckScenePeopleEditViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/29.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRCheckScenePeoplesEditViewController.h"
#import "HRCheckScenePeopleEditViewController.h"
#import "HRFMDB.h"
@interface HRCheckScenePeoplesEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewCheckScenePeoplesEdit;

//小伙伴数组 存放小伙伴字典 名字和代号
@property (nonatomic, strong) NSMutableArray *mutArrPeoples;
@end

@implementation HRCheckScenePeoplesEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mutArrPeoples = [NSMutableArray array];
    self.navigationItem.title = _dicScene[@"sceneName"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HRCheckScenePeopleEditViewController class]]) {
        HRCheckScenePeopleEditViewController *hrcspevc = segue.destinationViewController;
        hrcspevc.dicPeople = sender;
    }
}

#pragma mark - function
- (void)addPeopleAction:(UIButton *)sender {
    NSDictionary *dicPeople = @{@"peopleName":((UITextField *)[_tableViewCheckScenePeoplesEdit viewWithTag:1000]).text,
                               @"peopleNumber":((UITextField *)[_tableViewCheckScenePeoplesEdit viewWithTag:2000]).text};
    [_mutArrPeoples insertObject:dicPeople atIndex:0];
    [_tableViewCheckScenePeoplesEdit insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    [[HRFMDB shareFMDBManager] insertInToCheckSceneTable:dicPeople objectForKey:_dicScene[@"sceneName"]];
    ((UITextField *)[_tableViewCheckScenePeoplesEdit viewWithTag:1000]).text = @"";
    ((UITextField *)[_tableViewCheckScenePeoplesEdit viewWithTag:2000]).text = @"";
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 3;
    else
        return _mutArrPeoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddPeopleNameCell" forIndexPath:indexPath];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddPeopleNumberCell" forIndexPath:indexPath];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddPeopleButtonCell" forIndexPath:indexPath];
        [((UIButton *)[cell viewWithTag:3000]) addTarget:self action:@selector(addPeopleAction:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleInfoEditCell" forIndexPath:indexPath];
    }
    return cell;}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"CheckScenePeopleEditSegue" sender:nil];
}
@end
