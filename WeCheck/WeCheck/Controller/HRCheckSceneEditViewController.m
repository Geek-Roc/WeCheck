//
//  HRCheckSceneEditViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/29.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRCheckSceneEditViewController.h"
#import "HRFMDB.h"
#import "HRCheckScenePeoplesEditViewController.h"
@interface HRCheckSceneEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewCheckSceneEdit;
@property (weak, nonatomic) IBOutlet UITextField *tfSceneName;

//情景数组 存放情景字典 情景名字和人数
@property (nonatomic, strong) NSMutableArray *mutArrScenes;
@end

@implementation HRCheckSceneEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mutArrScenes = [[HRFMDB shareFMDBManager] queryInKeyValueTable:@"HRCheckSceneList"];
    [_tableViewCheckSceneEdit reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[HRFMDB shareFMDBManager] createKeyValueTable];
    _mutArrScenes = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HRCheckScenePeoplesEditViewController class]]) {
        HRCheckScenePeoplesEditViewController *hrcspevc = segue.destinationViewController;
        hrcspevc.dicScene = sender;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - function
- (IBAction)btnAddSceneAction:(UIButton *)sender {
    NSDictionary *dicScene = @{@"sceneName":_tfSceneName.text,
                               @"sceneNumber":@"0"};
    [_mutArrScenes insertObject:dicScene atIndex:0];
    [_tableViewCheckSceneEdit insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    [[NSUserDefaults standardUserDefaults] setObject:_mutArrScenes forKey:@"HRCheckSceneList"];
    [[HRFMDB shareFMDBManager] insertInToKeyValueTable:@"HRCheckSceneList" withValue:_mutArrScenes];
    _tfSceneName.text = @"";
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mutArrScenes.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_mutArrScenes removeObjectAtIndex:indexPath.row];
    [_tableViewCheckSceneEdit deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[NSUserDefaults standardUserDefaults] setObject:_mutArrScenes forKey:@"HRCheckSceneList"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckSceneEditCell" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1000]).text = _mutArrScenes[indexPath.row][@"sceneName"];
    ((UILabel *)[cell viewWithTag:1001]).text = [NSString stringWithFormat:@"总人数：%@人", _mutArrScenes[indexPath.row][@"sceneNumber"]];
    return cell;
}
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
    [self performSegueWithIdentifier:@"CheckScenePeoplesEditSegue" sender:_mutArrScenes[indexPath.row]];
}
@end
