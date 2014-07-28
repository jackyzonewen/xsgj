//
//  UserManager.m
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SystemAPI.h"
#import "LK_API.h"
#import "SystemHttpRequest.h"
#import "SystemHttpResponse.h"
#import "CRSA.h"
#import "ServerConfig.h"
#import "NSObject+EasyCopy.h"
#import "NSData+Base64.h"
#import "OfflineRequestCache.h"
#import <LKDBHelper.h>


@implementation SystemAPI

+(void)loginByCorpcode:(NSString *)corpcode username:(NSString *)username password:(NSString *)password  success:(void(^)(BNUserInfo *userinfo))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;{
    NSString *rsapassword = [[CRSA shareInstance]encryptByRsa:password withKeyType:KeyTypePublic];
    UserLoginHttpRequest *request = [[UserLoginHttpRequest alloc]init];
    request.CORP_CODE = corpcode;
    request.USER_NAME = username;
    request.USER_PASS = rsapassword;
    [LK_APIUtil getHttpRequest:request apiPath:URL_LOGIN Success:^(LK_HttpBaseResponse *response) {
        if ([DEFINE_SUCCESSCODE isEqual:response.MESSAGE.MESSAGECODE]) {
            UserLoginHttpResponse *tResponse = (UserLoginHttpResponse *)response;
            [ShareValue shareInstance].userId = [NSNumber numberWithInt:tResponse.USERINFO.USER_ID];
            [ShareValue shareInstance].userInfo = tResponse.USERINFO;
            [tResponse saveCacheDB];
            success(tResponse.USERINFO);
        }else{
            fail(NO,response.MESSAGE.MESSAGECONTENT);
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        fail(NotReachable,descript);
    } class:[UserLoginHttpResponse class]];
}

+(void)updateConfigSuccess:(void(^)())Success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    UpdateConfigHttpRequest *request = [[UpdateConfigHttpRequest alloc]init];
    BNUserInfo *userInfo = [[BNUserInfo alloc]init];
    [[ShareValue shareInstance].userInfo easyDeepCopy:userInfo];
    request.USER_INFO_BEAN = userInfo;
    NSNumber *lastupdatetime = [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"LASTUPDATE_%D",[ShareValue shareInstance].userInfo.USER_ID]];
//    if (!lastupdatetime) {
        lastupdatetime = @0;
//    }
    request.USER_INFO_BEAN.LAST_UPDATE_TIME = [lastupdatetime unsignedLongLongValue];
    [LK_APIUtil getHttpRequest:request apiPath:URL_UPDATE_CONFIG Success:^(LK_HttpBaseResponse *response) {
        if ([DEFINE_SUCCESSCODE isEqual:response.MESSAGE.MESSAGECODE]) {
            UpdateConfigHttpResponse *tResponse = (UpdateConfigHttpResponse *)response;
            if (tResponse.CORP_NOTICE_UPDATE_STATE) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"企业公告有新的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            [tResponse saveCacheDB];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithUnsignedLongLong:[ShareValue shareInstance].userInfo.LAST_UPDATE_TIME] forKey:[NSString stringWithFormat:@"LASTUPDATE_%D",[ShareValue shareInstance].userInfo.USER_ID]];
            Success();
        }else{
            fail(NO,response.MESSAGE.MESSAGECONTENT);
        }
    } fail:^(BOOL NotReachable, NSString *descript) {
        fail(NotReachable,descript);
    } class:[UpdateConfigHttpResponse class]];
}

//定时定位上报
+(void)commitLocateSuccess:(void(^)())success LOC_TYPE:(NSString *)type LNG:(double)lng LAT:(double)lat fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
{
    LocateCommitHttpRequest *request = [[LocateCommitHttpRequest alloc]init];
    request.LAT = [NSNumber numberWithDouble:lat];
    request.LNG = [NSNumber numberWithDouble:lng];
    request.LOC_TYPE = type;
    [LK_APIUtil getHttpRequest:request apiPath:URL_locateCommit Success:^(LK_HttpBaseResponse *response) {
        success();
    } fail:^(BOOL NotReachable, NSString *descript) {
        OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"实时定位上报"];
        [cache saveToDB];
        fail(NotReachable,descript);
    } class:[LocateCommitHttpResponse class]];

}

//手机状态上报
+(void)insertMobileSuccess:(void(^)())success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    InsertMobileStateHttpRequest *request = [[InsertMobileStateHttpRequest alloc]init];
    [LK_APIUtil getHttpRequest:request apiPath:URL_insertMobileState Success:^(LK_HttpBaseResponse *response) {
        success();
    } fail:^(BOOL NotReachable, NSString *descript) {
        //存储离线数据，等待下次上传
        request.STATE = 0;
        OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:@"手机状态上报"];
        [cache saveToDB];
        fail(NotReachable,descript);
    } class:[InsertMobileStateHttpResponse class]];
}

/**
 *  照片上传接口
 *
 *  @param request 请求参数
 *  @param success 成功block
 *  @param fail    失败返回结果
 */
+(void)uploadPhotoByFileName:(NSString *)fileName data:(NSData *)data success:(void(^)(NSString *fileId))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    UploadPhotoHttpRequest *request = [[UploadPhotoHttpRequest alloc]init];
    request.FILE_NAME = fileName;
    request.DATA = [data base64EncodedString];
    [LK_APIUtil getHttpRequest:request basePath:UPLOAD_PIC_URL apiPath:URL_uploadPhoto Success:^(LK_HttpBaseResponse *response) {
        UploadPhotoHttpResponse *tResponse = (UploadPhotoHttpResponse *)response;
        if (!tResponse.FILE_ID) {
            tResponse.FILE_ID = request.FILE_ID;
        }
        success(tResponse.FILE_ID);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[UploadPhotoHttpResponse class]];
}

@end
