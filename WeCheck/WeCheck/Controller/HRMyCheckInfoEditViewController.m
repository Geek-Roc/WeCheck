//
//  HRMyCheckInfoEditViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/4/28.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyCheckInfoEditViewController.h"

@interface HRMyCheckInfoEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewCheckInfoEdit;

@end

@implementation HRMyCheckInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _dic[@"didSelectCell"];
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
- (IBAction)btnSaveCheckInfoAction:(UIBarButtonItem *)sender {
    NSDictionary *dicCheckInfo;
    if ([_dic[@"didSelectCell"] isEqualToString:@"名字"]) {
        if ([((UITextField *)[_tableViewCheckInfoEdit viewWithTag:1000]).text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写名字" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        dicCheckInfo = @{@"HRCheckInfoName":((UITextField *)[_tableViewCheckInfoEdit viewWithTag:1000]).text,
                                       @"HRCheckInfoNumber":_dic[@"checkInfo"][@"HRCheckInfoNumber"],
                                       @"HRCheckInfoScene":_dic[@"checkInfo"][@"HRCheckInfoScene"]};
    }else {
        if ([((UITextField *)[_tableViewCheckInfoEdit viewWithTag:1000]).text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未填写代号" message:@"请填写！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        dicCheckInfo = @{@"HRCheckInfoName":_dic[@"checkInfo"][@"HRCheckInfoName"],
                         @"HRCheckInfoNumber":((UITextField *)[_tableViewCheckInfoEdit viewWithTag:1000]).text,
                         @"HRCheckInfoScene":_dic[@"checkInfo"][@"HRCheckInfoScene"]};
    }
    //替换本地CheckInfo
    [[NSUserDefaults standardUserDefaults] setObject:dicCheckInfo forKey:@"HRCheckInfo"];
    //替换本地CheckInfoList
    NSMutableArray *mutArrCheckInfo = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"HRCheckInfoList"]];
    [mutArrCheckInfo replaceObjectAtIndex:[mutArrCheckInfo indexOfObject:_dic[@"checkInfo"]] withObject:dicCheckInfo];
    [[NSUserDefaults standardUserDefaults] setObject:mutArrCheckInfo forKey:@"HRCheckInfoList"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCancleAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCheckInfoEditCell" forIndexPath:indexPath];
    if ([_dic[@"didSelectCell"] isEqualToString:@"名字"])
        ((UITextField *)[_tableViewCheckInfoEdit viewWithTag:1000]).text = _dic[@"checkInfo"][@"HRCheckInfoName"];
    else
        ((UITextField *)[_tableViewCheckInfoEdit viewWithTag:1000]).text = _dic[@"checkInfo"][@"HRCheckInfoNumber"];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
@end
