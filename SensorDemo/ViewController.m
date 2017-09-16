//
//  ViewController.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/18.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "ViewController.h"

#import "FingerprintViewController.h"
#import "DeviceMotionViewController.h"
#import "AccelerometerViewController.h"
#import "DistanceSensorViewController.h"
#import "LightSensitiveViewController.h"
#import "CompassViewController.h"
#import "GyroscopeViewController.h"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) NSArray * classArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"传感器集锦";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataSource = @[@"指纹识别", @"运动传感器 - 图片旋转", @"加速计 物理学 - 滚动小球", @"距离传感器 - 扬声器/听筒切换", @"环境光感 - 利用摄像头捕捉光感参数", @"磁力计 - 仿系统的指南针", @"陀螺仪"];
    _classArray = @[[FingerprintViewController class], [DeviceMotionViewController class], [AccelerometerViewController class], [DistanceSensorViewController class], [LightSensitiveViewController class], [CompassViewController class], [GyroscopeViewController class]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.tableView];
    
    
}


#pragma mark -- UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id  class = (UIViewController *)_classArray[indexPath.row];
                                          
    UIViewController * vc = [[class alloc] init];
    
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark -- Getter

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
    
}



- (void)dealloc{
    [self removeObserver];
}

- (void)removeObserver{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
