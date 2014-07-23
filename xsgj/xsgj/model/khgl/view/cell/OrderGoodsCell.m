//
//  OrderGoodsCell.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OrderGoodsCell.h"
#import "OrderInfoBean.h"

@interface OrderGoodsCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;

- (void)_initialize;

@end

@implementation OrderGoodsCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([OrderGoodsCell class]) bundle:nil];
}

+ (CGFloat)cellHeight
{
    return 56.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _initialize];
    
    [super awakeFromNib];
}

- (void)_initialize
{
    //TODO: 设置所有控件默认风格
    
}

@end

@implementation OrderGoodsCell (BindData)

- (void)configureForData:(id)data;
{
    // TODO: 设置数据
    OrderInfoBean *bean = (OrderInfoBean *)data;
    self.lblTitle.text = bean.CUST_NAME;
    self.lblTime.text = bean.CUST_NAME;
    self.lblMoney.text = bean.CUST_NAME;
}

@end
