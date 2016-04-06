//
//  SMRootViewController.m
//  StockManager
//
//  Created by Ben on 16/3/28.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "SMRootViewController.h"

@interface SMRootViewController ()

@end

@implementation SMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置返回键不显示内容
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    [barItem setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.backBarButtonItem = barItem;
    
    //设置背景颜色 272636
//    self.view.backgroundColor = [UIColor colorWithRed:27/255.0 green:26/255.0 blue:36/255.0 alpha:1];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
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
