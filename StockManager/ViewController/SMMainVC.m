//
//  SMMainVC.m
//  StockManager
//
//  Created by Ben on 16/4/8.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "SMMainVC.h"

@interface SMMainVC ()

@end

@implementation SMMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)stock:(id)sender {
    [self pushWithString:@"SMStockManagerVC"];
}
- (IBAction)account:(id)sender {
    [self pushWithString:@"SMAcountsVC"];
}
- (IBAction)logout:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushWithString:(NSString *)VCIdf{
    UIViewController *targetVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:VCIdf];
    [self.navigationController pushViewController:targetVC animated:YES];
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
