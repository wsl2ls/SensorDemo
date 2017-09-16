//
//  CompassViewController.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/26.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "CompassViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

#import "ScaleView.h"

@interface CompassViewController ()<CLLocationManagerDelegate>
{
    ScaleView * _scaView;
    UILabel * _directionLabel;
    UILabel * _angleLabel;
    UILabel * _positionLabel;
    UILabel * _latitudlongitudeLabel;
}
//位置信息
@property(nonatomic, strong)  CLLocation *currLocation;

@property(strong,nonatomic)CLLocationManager *locationManager;

@end

@implementation CompassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"指南针";
    
    [self setupUI];
    
    [self createLocationManager];
    
}

- (void)setupUI{
    
    _scaView = [[ScaleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 30, self.view.frame.size.width - 30)];
    _scaView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _scaView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scaView];
    
    _angleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, _scaView.frame.size.height + _scaView.frame.origin.y, 100, 100)];
    _angleLabel.font = [UIFont systemFontOfSize:30];
    _angleLabel.textAlignment = NSTextAlignmentCenter;
    _angleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_angleLabel];
    
    _directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, _angleLabel.frame.origin.y, 50, 50)];
    _directionLabel.font = [UIFont systemFontOfSize:15];
    _directionLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_directionLabel];
    
    _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, _angleLabel.frame.origin.y + _directionLabel.frame.size.height, self.view.frame.size.width/2, 70)];
    _positionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _positionLabel.numberOfLines = 3;
    _positionLabel.font = [UIFont systemFontOfSize:15];
    _positionLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_positionLabel];
    
    _latitudlongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _positionLabel.frame.origin.y + _positionLabel.frame.size.height, self.view.frame.size.width, 30)];
    _latitudlongitudeLabel.font = [UIFont systemFontOfSize:16];
    _latitudlongitudeLabel.textAlignment = NSTextAlignmentCenter;
    _latitudlongitudeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_latitudlongitudeLabel];
    
}

//创建初始化定位装置
- (void)createLocationManager{
    
    //attention 注意开启手机的定位服务，隐私那里的
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    self.locationManager.delegate=self;
    //  定位频率,每隔多少米定位一次
    // 距离过滤器，移动了几米之后，才会触发定位的代理函数
    self.locationManager.distanceFilter = 0;
    
    // 定位的精度，越精确，耗电量越高
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//导航
    
    //请求允许在前台获取用户位置的授权
        [self.locationManager requestWhenInUseAuthorization];
    //求允许在前后台都能获取用户位置的授权
//    [self.locationManager requestAlwaysAuthorization ];
    //允许后台定位更新,进入后台后有蓝条闪动
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    
    //判断定位设备是否能用和能否获得导航数据
    if ([CLLocationManager locationServicesEnabled]&&[CLLocationManager headingAvailable]){
        
        [self.locationManager startUpdatingLocation];//开启定位服务
        [self.locationManager startUpdatingHeading];//开始获得航向数据
        
        //        这个方法已被执行，就会回调下面的方法
        //        -(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
    }
    else{
        NSLog(@"不能获得航向数据");
    }
    
}

#pragma mark---与导航有关方法

#pragma mark - CLLocationManagerDelegate
// 定位成功之后的回调方法，只要位置改变，就会调用这个方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    
    self.currLocation = [locations lastObject];
    
    //维纬度
    NSString * latitudeStr = [NSString stringWithFormat:@"%3.2f",
                              _currLocation.coordinate.latitude];
    //经度
    NSString * longitudeStr  = [NSString stringWithFormat:@"%3.2f",
                                _currLocation.coordinate.longitude];
    //高度
    NSString * altitudeStr  = [NSString stringWithFormat:@"%3.2f",
                               _currLocation.altitude];
    
    NSLog(@"纬度 %@  经度 %@  高度 %@", latitudeStr, longitudeStr, altitudeStr);
    
    _latitudlongitudeLabel.text = [NSString stringWithFormat:@"纬度：%@  经度：%@  海拔：%@", latitudeStr, longitudeStr, altitudeStr];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:self.currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if ([placemarks count] > 0) {
                           
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =  placemark.addressDictionary;
                           
                           NSString *street = [addressDictionary
                                               objectForKey:(NSString *)kABPersonAddressStreetKey];
                           street = street == nil ? @"": street;
                           
                           NSString *country = placemark.country;
                           
                           NSString * subLocality = placemark.subLocality;
                           
                           NSString *city = [addressDictionary
                                             objectForKey:(NSString *)kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           
                           NSLog(@"%@",[NSString stringWithFormat:@"%@ \n%@ \n%@  %@ ",country, city,subLocality ,street]);
                           
                           _positionLabel.text = [NSString stringWithFormat:@" %@\n %@\n %@%@ " ,country, city,subLocality ,street];
                           
                       }
                       
                   }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    //获得当前设备
    UIDevice *device =[UIDevice currentDevice];
    
    //    判断磁力计是否有效,负数时为无效，越小越精确
    if (newHeading.headingAccuracy>0)
    {
        //地磁航向数据-》magneticHeading
        float magneticHeading =[self heading:newHeading.magneticHeading fromOrirntation:device.orientation];
        
        //地理航向数据-》trueHeading
        float trueHeading =[self heading:newHeading.trueHeading fromOrirntation:device.orientation];
        
        //地磁北方向
        float heading = -1.0f *M_PI *newHeading.magneticHeading /180.0f;
        _angleLabel.text = [NSString stringWithFormat:@"%3.1f°",magneticHeading];
        
        //旋转变换
        [_scaView resetDirection:heading];
        
        [self updateHeading:newHeading];
        
    }
    
    
}

//返回当前手机（摄像头)朝向方向
- (void)updateHeading:(CLHeading *)newHeading{
    
    CLLocationDirection  theHeading = ((newHeading.magneticHeading > 0) ?
                                       newHeading.magneticHeading : newHeading.trueHeading);
    
    int angle = (int)theHeading;
    
    switch (angle) {
        case 0:
            _directionLabel.text = @"北";
            break;
        case 90:
            _directionLabel.text = @"东";
            break;
        case 180:
            _directionLabel.text = @"南";
            break;
        case 270:
            _directionLabel.text = @"西";
            break;
            
        default:
            break;
    }
    if (angle > 0 && angle < 90) {
        _directionLabel.text = @"东北";
    }else if (angle > 90 && angle < 180){
        _directionLabel.text = @"东南";
    }else if (angle > 180 && angle < 270){
        _directionLabel.text = @"西南";
    }else if (angle > 270 ){
        _directionLabel.text = @"西北";
    }
}


-(float)heading:(float)heading fromOrirntation:(UIDeviceOrientation)orientation{
    
    float realHeading =heading;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            realHeading=heading-180.0f;
            break;
        case UIDeviceOrientationLandscapeLeft:
            realHeading=heading+90.0f;
            break;
        case UIDeviceOrientationLandscapeRight:
            realHeading=heading-90.0f;
            break;
        default:
            break;
    }
    if (realHeading>360.0f)
    {
        realHeading-=360.0f;
    }
    else if (realHeading<0.0f)
    {
        realHeading+=360.0f;
    }
    return  realHeading;
}

//判断设备是否需要校验，受到外来磁场干扰时
-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
    
}


- (void)dealloc{
    
    [self.locationManager stopUpdatingHeading];//停止获得航向数据，省电
    
    self.locationManager.delegate=nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    [self.locationManager stopUpdatingHeading];//停止获得航向数据，省电
    
    self.locationManager.delegate=nil;
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
