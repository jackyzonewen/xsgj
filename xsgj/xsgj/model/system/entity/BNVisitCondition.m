//
//  BNVisitCondition.m
//  fxtx
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNVisitCondition.h"

@implementation BNVisitCondition

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNVisitCondition",[ShareValue shareInstance].userInfo.USER_ID];
}

@end
