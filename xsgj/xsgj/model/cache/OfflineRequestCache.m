//
//  OfflineRequestCache.m
//  xsgj
//
//  Created by ilikeido on 14-7-25.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OfflineRequestCache.h"
#import <NSDate+Helper.h>
#import "LK_NSDictionary2Object.h"
#import "SystemHttpRequest.h"

@implementation OfflineRequestCache

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_OfflineRequestCache",[ShareValue shareInstance].userInfo.USER_ID];
}

-(id)init{
    self = [super init];
    if (self) {
        _time = [[NSDate date]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

-(void)fail:(int)netstate{
    self.sigleUpdateCount ++;
    self.updateCount ++;
    self.netstate = netstate;
    if (self.sigleUpdateCount > 5) {
        if (self.updateCount > 50) {
            [self deleteToDB];
            return;
        }
    }
    self.datetime = [[NSDate date] stringWithFormat:@"yyyyMMddHHmmss"];
    [[LKDBHelper getUsingLKDBHelper]updateToDB:self where:[NSString stringWithFormat:@"rowid=%d",self.rowid]];
}


-(id)initWith:(LK_HttpBaseRequest *)request name:(NSString *)name{
    self = [super init];
    if (self) {
        self.time = [[NSDate date]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-60*10];
        self.datetime = [date stringWithFormat:@"yyyyMMddHHmmss"];
        self.requestJsonStr = request.requestPath;
        self.name = name;
        if ([request isKindOfClass:[UploadPhotoHttpRequest class]]) {
            self.isUpload = 1;
        }
    }
    return self;
}

@end
