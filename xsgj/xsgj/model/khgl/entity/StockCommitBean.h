//
//  StockCommitBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockCommitBean : NSObject

@property(nonatomic,assign) int PROD_ID	;//	产品标识
@property(nonatomic,assign) int	STOCK_NUM	;//	库存数量
@property(nonatomic,strong) NSString *	STOCK_NO	;//	批次
@property(nonatomic,assign) int	PRODUCT_UNIT_ID	;//	产品单位表ID
@property(nonatomic,strong) NSString *SPEC;//
@property(nonatomic,strong) NSString *PROD_NAME;//产品名
@property(nonatomic,strong) NSString *PRODUCT_UNIT_NAME;//产品单位名
@property(nonatomic,strong) NSString *PHOTO1;//图片

@end
