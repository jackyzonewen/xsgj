//
//  ClCostViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-18.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "ClCostViewController.h"

@interface ClCostViewController ()

@end

@implementation ClCostViewController

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
    
    _beginTime = nil;
    _endTime = nil;
    [self initView];
    [self loadTypeData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"陈列费用";
    [self showRightBarButtonItemWithTitle:@"提交" target:self action:@selector(handleNavBarRight)];
    
    _tfTimeBegin.text = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    _tfTimeEnd.text = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    _beginTime = [NSDate date];
    _endTime = [NSDate date];
}

#pragma mark - functions

- (void)handleNavBarRight
{
    if(_tfTimeBegin.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写开始时间" toView:self.view];
        return;
    }
    if(_tfTimeEnd.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写结束时间" toView:self.view];
        return;
    }
    
    if(_tfClType.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写陈列形式" toView:self.view];
        return;
    }
    
    if(_tfClCost.text.length < 1)
    {
        [MBProgressHUD showError:@"请填写陈列费用" toView:self.view];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [self sendRequest];
}

- (IBAction)handleBtnTimeBeginClicked:(id)sender {
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker showTitle:@"请选择" inView:self.view];
    _bSetEndTime = NO;
}

- (IBAction)handleBtnTimeEndClicked:(id)sender {
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker showTitle:@"请选择" inView:self.view];
    _bSetEndTime = YES;
}

ON_LKSIGNAL3(UIDatePicker, COMFIRM, signal){
    UIDatePicker *picker =  (UIDatePicker *)signal.sender;
    NSDate *selectDate = picker.date;

    NSString *strTime = [selectDate stringWithFormat:@"yyyy-MM-dd"];
    if(!_bSetEndTime)
    {
        if(_endTime)
        {
            NSTimeInterval timeInterval = [selectDate timeIntervalSinceDate:_endTime];
            if(timeInterval > 0)
            {
                [MBProgressHUD showError:@"开始时间晚于结束时间" toView:self.view];
                return;
            }
        }
        _beginTime = selectDate;
        _tfTimeBegin.text = strTime;
    }
    else
    {
        if(_beginTime)
        {
            NSTimeInterval timeInterval = [selectDate timeIntervalSinceDate:_beginTime];
            if(timeInterval < 0)
            {
                [MBProgressHUD showError:@"结束时间早于开始时间" toView:self.view];
                return;
            }
        }
        _endTime = selectDate;
        _tfTimeEnd.text = strTime;
    }
}

- (IBAction)handleBtnClTypeClicked:(id)sender{
    NSMutableArray *aryItems = [[NSMutableArray alloc] init];
    for(BNDisplayShape *displayShape in _aryClShapreData)
    {
        [aryItems addObject:displayShape.SHAPE_NAME];
    }
    
    LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"选择陈列形式" options:aryItems handler:^(NSInteger anIndex) {
        NSString *strSelect = [aryItems objectAtIndex:anIndex];
        _tfClType.text = strSelect;
        
        for(BNDisplayShape *displayShape in _aryClShapreData)
        {
            if([displayShape.SHAPE_NAME isEqualToString:strSelect])
            {
                self.clShapeSelect = displayShape;
                break;
            }
        }
        
    }];
    [popListView showInView:[UIApplication sharedApplication].delegate.window animated:NO];
}

- (void)loadTypeData
{
    _aryClShapreData = [BNDisplayShape searchWithWhere:nil orderBy:nil offset:0 count:100];
}
- (void)sendRequest
{
//    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='34'",self.vistRecord.VISIT_NO] orderBy:nil];
//    step.SYNC_STATE = 1;
//    if (!step) {
//        step = [[BNVisitStepRecord alloc]init];
//        step.VISIT_NO = self.vistRecord.VISIT_NO;
//        step.OPER_NUM =  step.OPER_NUM + 1;
//        step.OPER_MENU = 34;
//    }
    
    BNVisitStepRecord *step = [BNVisitStepRecord searchSingleWithWhere:[NSString stringWithFormat:@"VISIT_NO='%@' and OPER_MENU='%@'",self.vistRecord.VISIT_NO,self.strMenuId] orderBy:nil];
    step.SYNC_STATE = 1;
    if (!step) {
        step = [[BNVisitStepRecord alloc]init];
        step.VISIT_NO = self.vistRecord.VISIT_NO;
        step.OPER_NUM =  step.OPER_NUM + 1;
        step.OPER_MENU = self.strMenuId.intValue;
    }
    
    InsertDisplayCostHttpRequest *request = [[InsertDisplayCostHttpRequest alloc]init];
    // 基础用户信息
    request.SESSION_ID  = [ShareValue shareInstance].userInfo.SESSION_ID;
    request.CORP_ID     = [ShareValue shareInstance].userInfo.CORP_ID;
    request.DEPT_ID     = [ShareValue shareInstance].userInfo.DEPT_ID;
    request.USER_AUTH   = [ShareValue shareInstance].userInfo.USER_AUTH;
    request.USER_ID     = [ShareValue shareInstance].userInfo.USER_ID;
    // 附加信息
    request.COMMITTIME = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.COST       = _tfClCost.text;
    request.CUST_ID    = self.customerInfo.CUST_ID;
    request.OPER_MENU  = self.strMenuId;
    request.SHAPE_ID   = [NSString stringWithFormat:@"%d",self.clShapeSelect.SHAPE_ID];
    request.VISIT_NO   = self.vistRecord.VISIT_NO;
    request.BEGIN_TIME = _tfTimeBegin.text;
    request.END_TIME   = _tfTimeEnd.text;
    
    [KHGLAPI insertDisplayCostByRequest:request success:^(InsertDisplayCostHttpResponse *response){
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

#pragma mark - IBActionSheetDelegate

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10)
    {
        NSString *strSelect = [_actionSheet buttonTitleAtIndex:buttonIndex];
        if(![strSelect isEqualToString:@"取消"])
        {
            _tfClType.text = strSelect;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    if(textField == _tfClCost)
    {
        NSString *strRule = @"0123456789.\n";
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:strRule] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL bNumber = [string isEqualToString:filtered];
        if(!bNumber)
        {
            return NO;
        }
        
        const NSInteger limited = 2;
        for (int i = futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                
                if (flag > limited) {
                    return NO;
                }
                
                break;
            }
            flag++;
        }
        
        if(textField.text.length < 12 || [string isEqualToString:@""])
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
