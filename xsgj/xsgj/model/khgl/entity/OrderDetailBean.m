//
//  OrderDetailBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OrderDetailBean.h"
#import <LKDBHelper.h>
#import <NSDate+Helper.h>

@implementation OrderDetailBean

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_OrderDetailBean",[ShareValue shareInstance].userInfo.USER_ID];
}

-(void)save
{
    [OrderDetailBean deleteWithWhere:[NSString stringWithFormat:@"ITEM_ID=%d",[_ITEM_ID intValue]]];
    [self saveToDB];
}

@end
