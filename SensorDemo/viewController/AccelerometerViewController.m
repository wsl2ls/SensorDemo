//
//  AccelerometerViewController.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/26.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "AccelerometerViewController.h"
#import "WLBallView.h"
#import "BezierPathView.h"

@interface AccelerometerViewController ()

@end

@implementation AccelerometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"加速计 滚动小球";
    
    [self acceleratorBall];
    
}


//滚动小球 仿真物理学 加速计
- (void)acceleratorBall{
    
    NSArray  * array = @[@"ball",@"eyes.png"];
    
    BezierPathView * referenceView = [[BezierPathView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    referenceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:referenceView];
    
    
    WLBallView * ellipseBallView1 = [[WLBallView alloc] initWithFrame:CGRectMake(30, 300, 30, 30) AndImageName:array[1]];
    [referenceView addSubview:ellipseBallView1];
    [ellipseBallView1 starMotion];
    
    WLBallView * ellipseBallView2 = [[WLBallView alloc] initWithFrame:CGRectMake(230, 300, 30, 30) AndImageName:array[1]];
    [referenceView addSubview:ellipseBallView2];
    [ellipseBallView2 starMotion];
    
    
    WLBallView * ballView1 = [[WLBallView alloc] initWithFrame:CGRectMake(100, 64, 40, 40) AndImageName:array[0]];
    [referenceView addSubview:ballView1];
    [ballView1 starMotion];
    
    WLBallView * ballView2 = [[WLBallView alloc] initWithFrame:CGRectMake(100, 64, 28, 28) AndImageName:array[0]];
    [referenceView addSubview:ballView2];
    [ballView2 starMotion];
    
    
    WLBallView * ballView3 = [[WLBallView alloc] initWithFrame:CGRectMake(100, 500, 28, 28) AndImageName:array[0]];
    [referenceView addSubview:ballView3];
    [ballView3 starMotion];
    
    WLBallView * ballView4 = [[WLBallView alloc] initWithFrame:CGRectMake(100, 500, 40, 40) AndImageName:array[0]];
    [referenceView addSubview:ballView4];
    [ballView4 starMotion];
    
}


- (void)dealloc{
    
    for (BezierPathView * referenceView in self.view.subviews) {
        for (WLBallView * ballView in referenceView.subviews) {
            [ballView stopMotion];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
