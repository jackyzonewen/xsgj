//
//  KHGLHttpRequest.m
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KHGLHttpRequest.h"
#import "OrderItemBean.h"
#import "OrderBackDetailBean.h"
#import "StockCommitBean.h"
#import "VisitPlan.h"
#import <OpenUDID.h>

@implementation TempVisitHttpRequest


-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation AllTypeHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation AddCustomerCommitHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation CustomerQueryHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}


@end


@implementation CustomerDetailHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation RecordVisitHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}


@end

@implementation QueryVistitRecordHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
        if ([[ShareValue shareInstance].userInfo.USER_AUTH isEqual:@"1"]) {
            _QUERY_DEPTID = [NSNumber numberWithInt:[ShareValue shareInstance].userInfo.DEPT_ID];
            self.QUERY_USERID = [NSNumber numberWithInt:-1];
        }else{
            _QUERY_DEPTID = [NSNumber numberWithInt:-1];;
            self.QUERY_USERID = [NSNumber numberWithInt:[ShareValue shareInstance].userInfo.USER_ID];
        }
    }
    return self;
}

@end

@implementation QueryPlanVisitConfigsHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}


@end

@implementation UpdateVisitPlansHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

+(Class)__VISIT_PLANSClass{
    return [VisitPlan class];
}

@end


@implementation ActivityCommitHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation InsertCompeteHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation OrderCommitHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

+(Class)__DATAClass{
    return [OrderItemBean class];
}

@end

@implementation OrderQueryHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation OrderDetailHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

+(Class)__DATAClass{
    return [OrderBackDetailBean class];
}

@end

@implementation InsertOrderBackHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation QueryOrderBackHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation QueryOrderBackDetailHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}


@end

@implementation StockCommitHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

+(Class)__DATAClass{
    return [StockCommitBean class];
}

@end

@implementation StoreCameraCommitHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation DisplayCameraCommitHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation InsertDisplayVividHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end

@implementation InsertDisplayCostHttpRequest

-(id)init{
    self = [super init];
    if (self) {
        _SESSION_ID = [ShareValue shareInstance].userInfo.SESSION_ID;
        _CORP_ID = [ShareValue shareInstance].userInfo.CORP_ID;
        _DEPT_ID = [ShareValue shareInstance].userInfo.DEPT_ID;
        _USER_AUTH = [ShareValue shareInstance].userInfo.USER_AUTH;
        _USER_ID = [ShareValue shareInstance].userInfo.USER_ID;
    }
    return self;
}

@end


