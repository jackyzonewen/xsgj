//
//  HdReportViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "HdReportViewController.h"

@interface HdReportViewController ()

@end

@implementation HdReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"活动上报";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    
    self.txHdDescription.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txHdDescription.layer.borderWidth = 1;
    self.txHdDescription.layer.cornerRadius = 5;
    
    [super.svContain setContentSize:CGSizeMake(0, super.svImgContain.frame.origin.y + super.svImgContain.frame.size.height + 200)];
    [super.svImgContain setContentSize:CGSizeMake(super.ivPhoto5.frame.origin.x + super.ivPhoto5.frame.size.width, 0)];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    if(_tfHdName.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写活动名称" toView:self.view];
        return;
    }
    
//    if(_txHdDescription.text.length < 1)
//    {
//        [MBProgressHUD showError:@"请填写描述" toView:self.view];
//        return;
//    }
    
    if(_aryfileDatas.count < 1)
    {
        [MBProgressHUD showError:@"至少需要一张照片" toView:self.view];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _iSendImgCount = 0;
    [_aryFileId removeAllObjects];
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [self commitData];
}

- (void)commitData
{
//    if(_aryfileDatas.count > 0)
//    {
//        ImageFileInfo *fileInfo = [_aryfileDatas objectAtIndex:_iSendImgCount];
//        [SystemAPI uploadPhotoByFileName:self.title data:fileInfo.fileData success:^(NSString *fileId) {
//            [_aryFileId addObject:fileId];
//            _iSendImgCount ++;
//            if(_iSendImgCount < _aryfileDatas.count)
//            {
//                [self commitData];
//            }
//            else
//            {
//                [self sendStoreCameraRequest];
//            }
//            
//        } fail:^(BOOL notReachable, NSString *desciption) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [MBProgressHUD showError:desciption toView:self.view];
//            return;
//        }];
//    }
//    else
//    {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:@"至少需要一张照片" toView:self.view];
//        return;
//    }
    
    if(_aryfileDatas.count > 0)
    {
        ImageFileInfo *fileInfo = [_aryfileDatas objectAtIndex:_iSendImgCount];
        [SystemAPI uploadPhotoByFileName:self.title data:fileInfo.fileData success:^(NSString *fileId) {
            [_aryFileId addObject:fileId];
            _iSendImgCount ++;
            if(_iSendImgCount < _aryfileDatas.count)
            {
                [self commitData];
            }
            else
            {
                [self sendStoreCameraRequest];
            }
            
        } fail:^(BOOL notReachable, NSString *desciption,NSString *fileId) {
            if(notReachable)
            {
                [_aryFileId addObject:fileId];
                _iSendImgCount ++;
                if(_iSendImgCount < _aryfileDatas.count)
                {
                    [self commitData];
                }
                else
                {
                    [self sendStoreCameraRequest];
                }
            }
            else
            {
                [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
                [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                return;
            }
        }];
    }
    else
    {
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:@"至少需要一张照片" toView:ShareAppDelegate.window];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
}

- (void)sendStoreCameraRequest
{
//    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='38'",self.vistRecord.VISIT_NO] orderBy:nil];
//    step.SYNC_STATE = 1;
//    if (!step) {
//        step = [[BNVisitStepRecord alloc]init];
//        step.VISIT_NO = self.vistRecord.VISIT_NO;
//        step.OPER_NUM =  step.OPER_NUM + 1;
//        step.OPER_MENU = 38;
//    }
    
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='%@'",self.vistRecord.VISIT_NO,self.strMenuId] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = self.strMenuId.intValue;
    }
    
    ActivityCommitHttpRequest *request = [[ActivityCommitHttpRequest alloc]init];
    // 基础用户信息
    request.SESSION_ID  = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID     = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID     = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH   = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID     = [ShareValue shareInstance].userInfo.USER_ID;
    // 附加信息
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.VISIT_NO   = self.vistRecord.VISIT_NO;
    request.REMARK     = _txHdDescription.text;
    request.TOPIC      = _tfHdName.text;
    request.CUST_ID    = self.customerInfo.CUST_ID;
    request.OPER_MENU  = self.strMenuId;
    
    if(_aryFileId.count >= 1)
    {
        request.PHOTO1 = [_aryFileId objectAtIndex:0];
    }
    
    if(_aryFileId.count >= 2)
    {
        request.PHOTO2 = [_aryFileId objectAtIndex:1];
    }
    
    if(_aryFileId.count >= 3)
    {
        request.PHOTO3 = [_aryFileId objectAtIndex:2];
    }
    
    if(_aryFileId.count >= 4)
    {
        request.PHOTO4 = [_aryFileId objectAtIndex:3];
    }
    
    if(_aryFileId.count >= 5)
    {
        request.PHOTO5 = [_aryFileId objectAtIndex:4];
    }
    
    [KHGLAPI commitActivityByRequest:request success:^(ActivityCommitHttpResponse *response){
        step.SYNC_STATE = 2;
        [step save];
        [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showSuccess:@"提交成功" toView:ShareAppDelegate.window];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
        
     }fail:^(BOOL notReachable, NSString *desciption){
         self.navigationItem.rightBarButtonItem.enabled = YES;

         [MBProgressHUD hideHUDForView:ShareAppDelegate.window animated:YES];
         if(notReachable)
         {
             step.SYNC_STATE = 1;
             [step save];
             
             OfflineRequestCache *cache = [[OfflineRequestCache alloc]initWith:request name:self.title];
             cache.VISIT_NO = self.vistRecord.VISIT_NO;
             [cache saveToDB];
             [MBProgressHUD showSuccess:DEFAULT_OFFLINE_MESSAGE_REPORT toView:ShareAppDelegate.window];
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                 sleep(1);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMMITDATA_FIN object:nil];
                     [self.navigationController popViewControllerAnimated:YES];
                 });
             });
         }
         else
         {
             [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
         }
         
     }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.tfHdName)
    {
//        NSCharacterSet *cs;
//        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        BOOL bNumber = [string isEqualToString:filtered];
//        if(!bNumber)
//        {
//            return NO;
//        }
        
        if(textField.text.length < 15 || [string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length==0){
        if ([text isEqualToString:@""]) {
            self.lbPlaceholder.hidden=NO;
        }else{
            self.lbPlaceholder.hidden=YES;
        }
    }else{
        if (textView.text.length==1){
            if ([text isEqualToString:@""]) {
                self.lbPlaceholder.hidden=NO;
            }else{
                self.lbPlaceholder.hidden=YES;
            }
        }else{
            self.lbPlaceholder.hidden=YES;
        }
    }
    
    if(textView == self.txHdDescription)
    {
        if(textView.text.length < 200 || [text isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }

    return YES;
}

@end
