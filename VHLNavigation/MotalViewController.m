//
//  MotalViewController.m
//  VHLNavigation
//
//  Created by Vincent on 2018/4/3.
//  Copyright © 2018年 Darnel Studio. All rights reserved.
//

#import "MotalViewController.h"

@interface MotalViewController ()

@end

@implementation MotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 60 + 64, 150, 30)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
