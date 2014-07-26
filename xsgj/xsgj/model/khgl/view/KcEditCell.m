//
//  KcEditCell.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcEditCell.h"

@implementation KcEditCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithValue:(StockCommitBean *)commitBean
{
    self.commitData = commitBean;
    self.lbName.text = [NSString stringWithFormat:@"%@(%@)",commitBean.PROD_NAME,commitBean.SPEC];
    self.lbNumber.text = [NSString stringWithFormat:@"%d",commitBean.STOCK_NUM];
    self.tfNumber.text = [NSString stringWithFormat:@"%d",commitBean.STOCK_NUM];
    self.tfUnit.text = commitBean.PRODUCT_UNIT_NAME;
    self.tfDate.text = commitBean.STOCK_NO;
}

- (IBAction)handleBtnAddClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnAddClicked:)])
    {
        [self.delegate onBtnAddClicked:self];
    }
}

- (IBAction)handleBtnReduceClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnDelClicked:)])
    {
        [self.delegate onBtnDelClicked:self];
    }
}

- (IBAction)handleBtnPhotoClicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBtnPhotoClicked:)])
    {
        [self.delegate onBtnPhotoClicked:self];
    }
}

- (IBAction)handleBtnUnitClicked:(id)sender {
    NSMutableArray *unitNames = [[NSMutableArray alloc] init];
    NSArray *aryUnitBean = [BNUnitBean searchWithWhere:[NSString stringWithFormat:@"PROD_ID=%D",self.commitData.PROD_ID] orderBy:@"UNIT_ORDER" offset:0 count:100];
    for(BNUnitBean *bean in aryUnitBean)
    {
        [unitNames addObject:bean.UNITNAME];
    }
    
    LeveyPopListView *popView = [[LeveyPopListView alloc] initWithTitle:@"选择单位" options:unitNames handler:^(NSInteger anIndex) {
        self.tfUnit.text = [unitNames objectAtIndex:anIndex];
        self.commitData.PRODUCT_UNIT_NAME = [unitNames objectAtIndex:anIndex];
    }];
    
    [popView showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:NO];
}

//#pragma mark - UITextFieldDelegate
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if(textField == _tfNumber)
//    {
//        NSLog(@"_tfNumber:%@",textField.text);
//    }
//}

@end
