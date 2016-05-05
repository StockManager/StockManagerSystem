//
//  SMLoginViewController.m
//  StockManager
//
//  Created by Ben on 16/4/5.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "SMLoginViewController.h"
#import <AFNetworking.h>
#import "SMGlobalUnit.h"

@interface SMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@end

@implementation SMLoginViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [_userTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:UserName];
    if ([userName isKindOfClass:[NSString class]]) {
        _userTF.text = userName;
    }
    
    // 设置NavigationBar的字体色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)scan:(id)sender {
    
    UIButton *buttoon = (UIButton *)sender;
    buttoon.selected = !buttoon.selected;
    if (buttoon.selected) {
        _passwordTF.secureTextEntry = NO;
    }else{
        _passwordTF.secureTextEntry = YES;
    }
}


- (IBAction)login:(id)sender {
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    
    NSString *userName = _userTF.text;
    NSString *password = _passwordTF.text;
    
    if ([userName isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return;
    }
    if ([password isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:userName forKey:UserName];
    
    //创建http连接，登录 http://121.40.240.1:8080/storage/ios/login?username=”参数”&password=”参数”


    NSString *httpString = [NSString stringWithFormat:@"http://121.40.240.1:8080/storage/ios/login?username=%@&password=%@",userName,password];
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    [manager POST:httpString parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if(error){
            [SVProgressHUD showErrorWithStatus:@"JSON数据解析出错"];
        }else{
            if ([object isKindOfClass:[NSDictionary class]]) {
                BOOL sucess = [object[@"success"]boolValue];
                if (sucess) {
                    [SVProgressHUD dismiss];
                    [self pushToMainVC];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
                }
            }
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:@"登录失败"];
            // 请求失败
            NSLog(@"请求失败:%@", [error localizedDescription]);
            NSDictionary *userInfoDic = [error userInfo];
            NSLog(@"%@",userInfoDic);
        });
    }];
}

- (void)pushToMainVC{
//    UITabBarController *tabBarVC = [[UITabBarController alloc]init];
//    
//    UIViewController *accountVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SMAcountsVC"];
//    accountVC.tabBarItem.title = @"账目";
//    accountVC.tabBarItem.image = [UIImage imageNamed:@"sm_main_account"];
//    
//    UIViewController *stockVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SMStockManagerVC"];
//    stockVC.tabBarItem.title = @"库存";
//    stockVC.tabBarItem.image = [UIImage imageNamed:@"sm_main_stock"];
//    
//    tabBarVC.viewControllers = @[accountVC,stockVC];
//    [self.navigationController pushViewController:tabBarVC animated:YES];
    
    UIViewController *targetVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SMMainVC"];
    [self.navigationController pushViewController:targetVC animated:YES];
    
}

@end
