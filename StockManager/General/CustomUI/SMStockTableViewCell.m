//
//  SMStockTableViewCell.m
//  StockManager
//
//  Created by Ben on 16/4/6.
//  Copyright © 2016年 Ben. All rights reserved.
//  name-specifications-amount-number-units-recut

#import "SMStockTableViewCell.h"

@interface SMStockTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specificationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *recutLabel;

@end

@implementation SMStockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configCellWithObject:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        
        //名称
         _nameLabel.text = dic[@"name"];
        
        //规格
        NSString *specification = dic[@"specifications"];
        _specificationsLabel.text = specification;
        
        //数量
        NSNumber *amount = dic[@"amount"];
        _amountLabel.text = [amount stringValue];
        
        //件数
       NSNumber *number = dic[@"number"];
        _numberLabel.text = [number stringValue];
        
        //单位
        NSString *units = dic[@"units"];
        _unitsLabel.text = units;
        
        //类型
        BOOL recut = [dic[@"recut"]boolValue];
        if (recut) {
            _recutLabel.text = @"膜";
        }else{
            _recutLabel.text = @"其他";
        }
        
        
        
        
        
        NSLog(@"dic的结构：%@",dic);
    }
}
@end
