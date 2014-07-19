//
//  OrderItemBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-11.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItemBean : NSObject

@property(nonatomic,assign) int	ITEM_ID	;//	项目标识
@property(nonatomic,assign) int	ORDER_ID	;//	订单标识
@property(nonatomic,assign) int	PROD_ID	;//	产品标识
@property(nonatomic,assign) int	POLICY_ID	;//	优惠ID
@property(nonatomic,assign) int	PRODUCT_UNIT_ID	;//	产品单位表ID
@property(nonatomic,assign) double ITEM_PRICE	;//	产品单价
@property(nonatomic,strong) NSNumber *	ITEM_RATE	;//	优惠单价
@property(nonatomic,strong) NSNumber *	ITEM_NUM	;//	订货数量
@property(nonatomic,strong) NSNumber *	TOTAL_PRICE	;//	订货总价
@property(nonatomic,strong) NSNumber *	TOTAL_RATE	;//	优惠总价
@property(nonatomic,strong) NSString *	STATE	;//	状态
@property(nonatomic,strong) NSNumber *	APPROVE_USER	;//	审核人
@property(nonatomic,strong) NSString *	APPROVE_TIME	;//	审核时间

@end