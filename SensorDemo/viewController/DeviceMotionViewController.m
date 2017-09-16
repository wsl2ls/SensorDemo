//
//  DeviceMotionViewController.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/26.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "DeviceMotionViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "UIImageView+Tranform3D.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface DeviceMotionViewController ()

@property (nonatomic, strong) CMMotionManager * motionManager;

@end

@implementation DeviceMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"运动传感器 手机水平位置测试";
    
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 70, SCREEN_WIDTH/2, 250)];
    imageView1.image = [UIImage imageNamed:@"qiaoba.jpeg"];
    [self.view addSubview:imageView1];
    
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT/2 + 60, SCREEN_WIDTH/2, 250)];
    
    imageView2.image = [UIImage imageNamed:@"qiaoba.jpeg"];
    [self.view addSubview:imageView2];

    
    self.motionManager= [[CMMotionManager alloc] init];
    //判断设备运动是否可用
    if(!self.motionManager.isDeviceMotionAvailable){
        NSLog(@"手机没有此功能，换肾吧");
    }
    
    //更新速率是100Hz
    self.motionManager.deviceMotionUpdateInterval = 0.1;
    //开始更新采集数据
    //需要时采集数据
    //[motionManager startDeviceMotionUpdates];
    //实时获取数据
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        
        //获取X的值
        double x = motion.gravity.x;
        
        //手机水平位置测试
        //判断y是否小于0，大于等于-1.0
        if(motion.gravity.y < 0.0 && motion.gravity.y >= -1.0){
                //设置旋转
                [imageView1 setRotation:80 * motion.gravity.y];
            }else if (motion.gravity.z * -1 > 0 && motion.gravity.z * -1 <= 1.0){
                [imageView1 setRotation:80 - (80 * motion.gravity.z * -1)];
            }
            
        //X、Y方向上的夹角
        double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
        NSLog(@"%.2f",rotation);
        //图片始终保持垂直方向
        imageView2.transform = CGAffineTransformMakeRotation(rotation);

    }];
 
}


- (void)dealloc{
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}
 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
