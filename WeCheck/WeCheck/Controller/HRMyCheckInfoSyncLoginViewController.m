//
//  MyCheckInfoSyncLoginViewController.m
//  WeCheck
//
//  Created by HaiRui on 15/5/2.
//  Copyright (c) 2015年 Geek-Roc. All rights reserved.
//

#import "HRMyCheckInfoSyncLoginViewController.h"
@interface HRMyCheckInfoSyncLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfLoginName;
@property (weak, nonatomic) IBOutlet UITextField *tfLoginPassword;

@end

@implementation HRMyCheckInfoSyncLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)btnLoginAction:(UIButton *)sender {
}

@end
