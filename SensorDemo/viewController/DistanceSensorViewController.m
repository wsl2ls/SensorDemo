//
//  DistanceSensorViewController.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/26.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "DistanceSensorViewController.h"

@interface DistanceSensorViewController ()
{
    AVPlayer * _play;
}
@end

@implementation DistanceSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"距离传感器";
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    label.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    label.numberOfLines =  0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    label.text = @"当前默认用扬声器播放音乐，如果有物体靠近手机的听筒附近(距离传感器),音乐将从听筒播放，离开后用扬声器播放";
    
    [self distanceSensor];
}

//距离传感器 感应是否有其他物体靠近屏幕,iPhone手机中内置了距离传感器，位置在手机的听筒附近，当我们在打电话或听微信语音的时候靠近听筒，手机的屏幕会自动熄灭，这就靠距离传感器来控制
- (void)distanceSensor{
    
    // 打开距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    // 通过通知监听有物品靠近还是离开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"SeeYouAgain" ofType:@"mp3"];
    if(path == nil){
        return;
    }
    _play = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:path]];
    
    [_play play];
    
}

- (void)proximityStateDidChange:(NSNotification *)note
{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有东西靠近");
        //听筒播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        NSLog(@"有物体离开");
        //扬声器播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)dealloc{
    [_play pause];
    _play = nil;
    //关闭距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [self removeObserver];
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
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
