//
//  MapAddressVC.m
//  xsgj
//
//  Created by ilikeido on 14-7-21.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "MapAddressVC.h"
#import "MapUtils.h"
#import "MBProgressHUD+Add.h"

@interface MapAddressVC ()<BMKGeoCodeSearchDelegate>{
   CLLocationCoordinate2D _coordinate;
    NSString *_address;
    BMKPointAnnotation *_annotation;
    BMKGeoCodeSearch *_search;
    __weak IBOutlet UIView *iv_teach;
    
    __weak IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
}

@end

@implementation MapAddressVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)teachTouch:(id)sender {
    iv_teach.hidden = YES;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ISTEACHED"];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    self.title = @"调整位置";
    [self showRightBarButtonItemWithTitle:@"确定" target:self action:@selector(sureAction)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationAddressUpdate) name:NOTIFICATION_ADDRESS_UPDATED object:nil];
    
    //实例化长按手势监听
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [_mapView addGestureRecognizer:longPress];
    _mapView.delegate = self;
    
    _lb_address.text = @"长按进行定位!";
    
    _coordinate = (CLLocationCoordinate2D){119.279601,26.112961};
    if ([ShareValue shareInstance].currentLocation.latitude >0 ) {
        _coordinate = [ShareValue shareInstance].currentLocation;
        if ([ShareValue shareInstance].address) {
            _address = [ShareValue shareInstance].address;
            _lb_address.text = _address;
        }else{
            [[MapUtils shareInstance] startGeoCodeSearch];
        }
        
    }
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(_coordinate, BMKCoordinateSpanMake(0.01, 0.01));
    
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
    _annotation = [[BMKPointAnnotation alloc]init];
    _annotation.coordinate = _coordinate;
    [_mapView addAnnotation:_annotation];
    _mapView.centerCoordinate = _coordinate;
    _search = [[BMKGeoCodeSearch alloc]init];
    _search.delegate = self;
    // Do any additional setup after loading the view from its nib.
    BOOL teached = [[NSUserDefaults standardUserDefaults]boolForKey:@"ISTEACHED"];
    if (!teached) {
        iv_teach.hidden = NO;
    }else{
        iv_teach.hidden = YES;
    }
    
}

-(void)viewDidUnload{
    _mapView.delegate = nil;
    _search.delegate = nil;
    [_mapView removeFromSuperview];
    _mapView = nil;
    _search = nil;
}

-(void)startGeoCodeSearch{

    self.lb_address.text = @"正在定位···";
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = _coordinate;
    BOOL flag = [_search reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handleTableviewCellLongPressed:(UIGestureRecognizer *)gestureRecognizer{
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){

        CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];//这里touchPoint是点击的某点在地图控件中的位置
        CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];//这里touchMapCoordinate就是该点的经纬度了
        _coordinate = touchMapCoordinate;
        [_mapView removeAnnotation:_annotation];
        
        _annotation = [[BMKPointAnnotation alloc]init];
        _annotation.coordinate = touchMapCoordinate;
        [_mapView addAnnotation:_annotation ];
        
        
        [self startGeoCodeSearch];
        
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {

    } else if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {

    }
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
	//根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
	
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
	annotationView.canShowCallout = TRUE;
    return annotationView;
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
{
    if (error) {
        _lb_address.text = @"定位失败，请重新定位!";
    }else{
        _address = result.address;
        _lb_address.text = _address;
    }
}


-(void)sureAction{
    if (_delegate) {
        [_delegate onAddressReturn:_address coordinate:_coordinate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)locationAddressUpdate{
    _lb_address.text = [ShareValue shareInstance].address;
    _address = [ShareValue shareInstance].address;
}
@end
