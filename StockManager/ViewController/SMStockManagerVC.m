//
//  SMStockManagerVC.m
//  StockManager
//
//  Created by Ben on 16/4/6.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "SMStockManagerVC.h"
#import <AFNetworking.h>
#import "SMGlobalUnit.h"
#import "SMStockTableViewCell.h"

static NSString * const CellIdentifier = @"StockCellIndetifier";

@interface SMStockManagerVC ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *originDics;  //全部的账目的数据
@property (strong, nonatomic) NSArray *showDics;    //显示的账目数据

@property (strong, nonatomic) UIRefreshControl *refC;

@end

@implementation SMStockManagerVC

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"SMStockTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    //查询全部账目数据
    NSString *url = [NSString stringWithFormat:@"http://121.40.240.1:8080/storage/ios/stock/stockQuery/show?name=%@",@""];
    [self creatHttpSeverWithUrl:url];
    
    //下拉刷新
    _refC = [[UIRefreshControl alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_refC addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refC];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.title = @"库存查询";
    
    //右边搜索按钮
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *stockButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchStock)];
    self.tabBarController.navigationItem.rightBarButtonItem = stockButtonItem;
}

- (void)searchStock{
    NSLog(@"搜索stock");
    [self creatAlertViewWtihString:@""];
}

- (void)creatAlertViewWtihString:(NSString *)string{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入产品名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].placeholder = @"产品名称";
    [alertView textFieldAtIndex:0].text = string;
    [alertView show];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"%@",[alertView textFieldAtIndex:0].text);
        
        if([[alertView textFieldAtIndex:0].text isEqualToString:@""]){
            _showDics = _originDics;
            [_tableView reloadData];
        }else{
            _showDics = [self searchWithString:[alertView textFieldAtIndex:0].text andOriginData:_originDics];
            [_tableView reloadData];
        }
        
        
    }
}


- (void)creatHttpSeverWithUrl:(NSString *)url{
    [SVProgressHUD showWithStatus:@"查询中"];
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // post请求
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [_refC endRefreshing];
        // 请求成功，解析数据
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        if([object isKindOfClass:[NSDictionary class]]){
            NSArray *objectArray = object[@"object"];
            _originDics = objectArray;
            _showDics = objectArray;
            [_tableView reloadData];
        }
        NSLog(@"%@", object);
        NSDictionary *errDic = [error userInfo];
        NSLog(@"%@", errDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [_refC endRefreshing];
        // 请求失败
        NSLog(@"请求失败:%@", [error localizedDescription]);
        NSDictionary *userInfoDic = [error userInfo];
        NSLog(@"%@",userInfoDic);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showDics.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SMStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSLog(@"自定义cell获取失败");
    }
    
    //定制cell
    //数据
    if (indexPath.row < _showDics.count) {
        NSDictionary *dic = _showDics[indexPath.row];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [cell configCellWithObject:dic];
        }
    }
    return cell;
    
}


#pragma mark - 搜索
- (NSArray *)searchWithString:(NSString *)searchString andOriginData:(NSArray *)originDics{
    
    if (![originDics isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    //得到名称数组
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in originDics) {
        NSString *name = dic[@"name"];
        [nameArray addObject:name];
    }
    
    //筛选出符合规则的名称数组
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchString];
    NSArray *resultNameArray = [nameArray filteredArrayUsingPredicate:predicate];
    
    //在数据源中查找名称一样的 - 得到结果数组
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (NSString *name in resultNameArray) {
        
        for (NSDictionary *dic in originDics) {
            NSString *oName = dic[@"name"];
            if ([oName isEqualToString:name]) {
                [resultArray addObject:dic];
                break;
            }
        }
    }
    
    return (NSArray *)resultArray;
}



#pragma mark - 下拉刷新

- (void)refresh{
    NSString *url = [NSString stringWithFormat:@"http://121.40.240.1:8080/storage/ios/stock/stockQuery/show?name=%@",@""];
    [self creatHttpSeverWithUrl:url];
}

@end
