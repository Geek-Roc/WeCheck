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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mutArrPeoples = [NSMutableArray arrayWithArray:[[HRFMDB shareFMDBManager] queryInCheckSceneTable:_dicScene[@"sceneName"]]];
    [_tableViewCheckScenePeoplesEdit reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    if ([((UITextField *)[_tableViewCheckScenePeoplesEdit viewWithTag:1000]).text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填名字" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if ([((UITextField *)[_tableViewCheckScenePeoplesEdit viewWithTag:2000]).text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填代号" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSDictionary *dicPeople = @{@"peopleName":((UITextField *)[_tableViewCheckScenePeoplesEdit viewWithTag:1000]).text,
                               @"peopleNumber":((UITextField *)[_tableViewCheckScenePeoplesEdit viewWithTag:2000]).text};
    if (![_mutArrPeoples containsObject:dicPeople]) {
        [_mutArrPeoples insertObject:dicPeople atIndex:0];
        [_tableViewCheckScenePeoplesEdit insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        [[HRFMDB shareFMDBManager] insertInToCheckSceneTable:dicPeople objectForKey:_dicScene[@"sceneName"]];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已经存在的小伙伴" message:@"请更换！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = @{@"sceneName":_dicScene[@"sceneName"],
                          @"peopleName":_mutArrPeoples[indexPath.row][@"peopleName"],
                          @"peopleNumber":_mutArrPeoples[indexPath.row][@"peopleNumber"]};
    [[HRFMDB shareFMDBManager] deleteCheckSceneTable:dic];
    [_mutArrPeoples removeObjectAtIndex:indexPath.row];
    [_tableViewCheckScenePeoplesEdit deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        ((UILabel *)[cell viewWithTag:4000]).text = _mutArrPeoples[indexPath.row][@"peopleName"];
        ((UILabel *)[cell viewWithTag:4001]).text = _mutArrPeoples[indexPath.row][@"peopleNumber"];
    }
    return cell;}
#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = @{@"sceneName":_dicScene[@"sceneName"],
                          @"peopleName":_mutArrPeoples[indexPath.row][@"peopleName"],
                          @"peopleNumber":_mutArrPeoples[indexPath.row][@"peopleNumber"]};
    [self performSegueWithIdentifier:@"CheckScenePeopleEditSegue" sender:dic];
}
@end
