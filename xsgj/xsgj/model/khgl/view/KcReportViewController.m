//
//  KcReportViewController.m
//  xsgj
//
//  Created by chenzf on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "KcReportViewController.h"
#import "KcSelectTreeViewController.h"
#import "KcEditViewController.h"

@interface KcReportViewController ()

@end

@implementation KcReportViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifySelectProductFin:) name:NOTIFICATION_SELECTPRODUCT_FIN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifyTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    
    _aryProDataTemp = [[NSMutableArray alloc] init];
    _aryTraversalRet = [[NSMutableArray alloc] init];
    _aryProductSelect = [[NSMutableArray alloc] init];
    _aryFilter = [[NSMutableArray alloc] init];
    _bSearch = NO;
    [self initView];
    [self loadTypeData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _btnSeleltAll.selected = NO;
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_SELECTPRODUCT_FIN object:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"库存上报";
    [self showRightBarButtonItemWithTitle:@"添加" target:self action:@selector(handleNavBarRight)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - functions

- (void)handleNavBarRight
{
    KcEditViewController *viewController = [[KcEditViewController alloc] initWithNibName:@"KcEditViewController" bundle:nil];
    viewController.strMenuId = _strMenuId;
    viewController.aryData = _aryProductSelect;
    viewController.customerInfo = self.customerInfo;
    viewController.vistRecord = self.vistRecord;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)handleBtnTypeClicked:(id)sender {
    KcSelectTreeViewController *selectTreeViewController = [[KcSelectTreeViewController alloc] initWithNibName:@"SelectTreeViewController" bundle:nil];
    selectTreeViewController.data = _aryProTypeTreeData;
    [self.navigationController pushViewController:selectTreeViewController animated:YES];
}

- (IBAction)handleBtnSelectAll:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if(_bSearch)
    {
        for(BNProduct *product in _aryFilter)
        {
            [self handleSelectData:product ISAdd:button.selected];
        }
    }
    else
    {
        for(BNProduct *product in _aryProductData)
        {
            [self handleSelectData:product ISAdd:button.selected];
        }
    }
    
    [_tvProduct reloadData];
    [self reloadSelectView];
}

- (void)loadTypeData
{
    _aryProductTypeData = [BNProductType searchWithWhere:nil orderBy:@"ORDER_NO" offset:0 count:1000];
    _aryProductData = [BNProduct searchWithWhere:nil orderBy:@"PROD_NAME_PINYIN" offset:0 count:1000];
    _aryProTypeTreeData = [self makeProTypeTreeData];
}

- (NSArray *)makeProTypeTreeData
{
    NSMutableArray *parentTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:_aryProductTypeData];
    for(BNProductType *productType in _aryProductTypeData)
    {
        if(productType.CLASS_PID == 0)
        {
            TreeData *aryData = [[TreeData alloc] init];
            aryData.name = productType.CLASS_NAME;
            aryData.dataInfo = productType;
            [parentTree addObject:aryData];
            
            [arySourceData removeObject:productType];
        }
    }
    
    [self makeSubCusTypeTreeData:arySourceData ParentTreeData:parentTree];
    return parentTree;
}

- (void)makeSubCusTypeTreeData:(NSArray *)sourceData ParentTreeData:(NSMutableArray *)parentTree
{
    NSMutableArray *aryChildTree = [[NSMutableArray alloc] init];
    NSMutableArray *arySourceData = [[NSMutableArray alloc] initWithArray:sourceData];
    for(BNProductType *productType in sourceData)
    {
        for(TreeData *parentData in parentTree)
        {
            BNProductType *parentProType = (BNProductType *)parentData.dataInfo;
            if(productType.CLASS_PID == parentProType.CLASS_ID)
            {
                TreeData *aryData = [[TreeData alloc] init];
                aryData.name = productType.CLASS_NAME;
                aryData.dataInfo = productType;
                [parentData.children addObject:aryData];
                
                [aryChildTree addObject:aryData];
                [arySourceData removeObject:productType];
            }
        }
    }
    
    if(arySourceData.count > 0)
    {
        [self makeSubCusTypeTreeData:arySourceData ParentTreeData:aryChildTree];
    }
}

- (void)handleSelectData:(BNProduct *)product ISAdd:(BOOL)bAdd
{
    BOOL bIsExist = NO;
    for(BNProduct *tempPro in _aryProductSelect)
    {
        if(tempPro.PROD_ID == product.PROD_ID)
        {
            bIsExist = YES;
            break;
        }
    }
    
    if(bAdd)
    {
        if(!bIsExist)
        {
            [_aryProductSelect addObject:product];
        }
    }
    else
    {
        if(bIsExist)
        {
            [_aryProductSelect removeObject:product];
        }
    }
    
    if(_aryProductSelect.count > 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)reloadSelectView
{
    for(UIView *view in _svSelect.subviews)
    {
        [view removeFromSuperview];
    }
    
    ProductDelView *lastView = nil;
    for(BNProduct *tempPro in _aryProductSelect)
    {
        ProductDelView *view = [[[NSBundle mainBundle]loadNibNamed:@"ProductDelView" owner:nil options:nil]lastObject];
        view.delegate = self;
        view.productData = tempPro;
        view.lbName.text = tempPro.PROD_NAME;
        
        if(lastView)
        {
            view.frame = CGRectMake(lastView.frame.origin.x + 85, 4, 80, 30);
        }
        else
        {
            view.frame = CGRectMake(5, 4, 80, 30);
        }
        
        lastView = view;
        [_svSelect addSubview:view];
        [_svSelect setContentSize:CGSizeMake(lastView.frame.origin.x + 90, 0)];
    }
}

#pragma mark - ProductDelViewDelegate

- (void)onBtnDelClicked:(ProductDelView *)view
{
    [self handleSelectData:view.productData ISAdd:NO];
    [self reloadSelectView];
    [_tvProduct reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_bSearch)
    {
        return _aryFilter.count;
    }
    else
    {
        return _aryProductData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KcProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KCPRODUCTCELL"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KcProductCell" bundle:nil] forCellReuseIdentifier:@"KCPRODUCTCELL"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"KCPRODUCTCELL"];
    }
    
    BNProduct *product = nil;
    if(_bSearch)
    {
        if(_aryFilter.count > 0)
        {
            product = [_aryFilter objectAtIndex:indexPath.row];
        }
    }
    else
    {
        if(_aryProductData.count > 0)
        {
            product = [_aryProductData objectAtIndex:indexPath.row];
        }
    }
    
    if(product)
    {
        cell.productData = product;
        cell.lbName.text = product.PROD_NAME;
        BOOL bIsExist = NO;
        for(BNProduct *tempPro in _aryProductSelect)
        {
            if(tempPro.PROD_ID == product.PROD_ID)
            {
                bIsExist = YES;
                break;
            }
        }
        cell.btnSelect.selected = bIsExist;
    }

    cell.delegate = self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _bSearch = NO;
    [_tvProduct reloadData];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
//    [futureString  insertString:string atIndex:range.location];
//    
//    
//    if(futureString.length > 0)
//    {
//        _bSearch = YES;
//        [_aryFilter removeAllObjects];
//        for(BNProduct *product in _aryProductData)
//        {
//            NSRange range = [product.PROD_NAME rangeOfString:futureString];
//            if(range.length > 0)
//            {
//                [_aryFilter addObject:product];
//            }
//        }
//    }
//    else
//    {
//        _bSearch = NO;
//    }
//    
//    [_tvProduct reloadData];
//    
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfSearch resignFirstResponder];
//    if(_tfSearch.text.length > 0)
//    {
//        _bSearch = YES;
//        [_aryFilter removeAllObjects];
//        for(BNProduct *product in _aryProductData)
//        {
//            NSRange range = [product.PROD_NAME rangeOfString:textField.text];
//            if(range.length > 0)
//            {
//                [_aryFilter addObject:product];
//            }
//        }
//    }
//    else
//    {
//        _bSearch = NO;
//    }
//    
//    [_tvProduct reloadData];
    return NO;
}

#pragma mark - KcProductCellDelegate

- (void)onBtnSelectClicked:(KcProductCell *)cell
{
    if(cell.btnSelect.selected)
    {
        [self handleSelectData:cell.productData ISAdd:YES];
    }
    else
    {
        [self handleSelectData:cell.productData ISAdd:NO];
    }
    
    [self reloadSelectView];
}

- (void)handleNotifySelectProductFin:(NSNotification *)note
{
    [_aryProductSelect removeAllObjects];
    
    BNProductType *productType = [note object];
    _proTypeShow = productType;
    _tfType.text = productType.CLASS_NAME;
    
    NSString *types = [BNProductType getOwnerAndChildTypeIds:productType.CLASS_ID];
    _aryProductData = [BNProduct searchWithWhere:[NSString stringWithFormat:@"CLASS_ID in (%@)",types] orderBy:@"PROD_NAME_PINYIN" offset:0 count:100];
    
    [_tvProduct reloadData];
}

- (void)handleNotifyTextChanged:(NSNotification *)note
{
    if(_tfSearch.text.length > 0)
    {
        _bSearch = YES;
        [_aryFilter removeAllObjects];
        for(BNProduct *product in _aryProductData)
        {
            NSRange range = [product.PROD_NAME rangeOfString:_tfSearch.text];
            if(range.length > 0)
            {
                [_aryFilter addObject:product];
            }
        }
    }
    else
    {
        _bSearch = NO;
    }
    
    [_tvProduct reloadData];
}

@end
