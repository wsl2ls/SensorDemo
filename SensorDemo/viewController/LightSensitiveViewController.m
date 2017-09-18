//
//  LightSensitiveViewController.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/26.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "LightSensitiveViewController.h"

@interface LightSensitiveViewController ()
{
    AVCaptureSession * _session;
}
@end

@implementation LightSensitiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"利用摄像头捕捉光感参数";
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    label.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    label.numberOfLines =  0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    label.text = @"环境变暗后就自动提示是否打开闪光灯，打开之后，环境变亮后会自动提示是否关闭闪光灯。";
    
    
    [self lightSensitive];
    
}

//利用摄像头获取环境光感参数 比如拍照时光线暗的时候闪光灯自动打开
- (void)lightSensitive {
    
    // 1.获取硬件设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        NSLog(@"该换肾了");
        return;
    }
    
    // 2.创建输入流
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    
    // 3.创建设备输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    // AVCaptureSession属性
    _session = [[AVCaptureSession alloc]init];
    // 设置为高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加会话输入和输出
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }
    
    // 9.启动会话
    [_session startRunning];
    
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"环境光感 ： %f",brightnessValue);
    
    
    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL result = [device hasTorch];// 判断设备是否有闪光灯
    if ((brightnessValue < 0) && result) {// 打开闪光灯
        
        if(device.torchMode == AVCaptureTorchModeOn){
            return;
        }
        
        UIAlertController * alertVC  = [UIAlertController alertControllerWithTitle:@"提示" message:@"小主是否要打开闪光灯？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [device lockForConfiguration:nil];
            
            [device setTorchMode: AVCaptureTorchModeOn];//开
            
            [device unlockForConfiguration];
            
        }];
        [alertVC addAction:openAction];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancleAction];
        
        [self presentViewController:alertVC animated:NO completion:nil];
        
        
    }else if((brightnessValue > 0) && result) {// 关闭闪光灯
        
        if(device.torchMode == AVCaptureTorchModeOn){
            
            UIAlertController * alertVC  = [UIAlertController alertControllerWithTitle:@"提示" message:@"小主是否要关闭闪光灯？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * openAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [device lockForConfiguration:nil];
                [device setTorchMode: AVCaptureTorchModeOff];//关
                [device unlockForConfiguration];
                
            }];
            [alertVC addAction:openAction];
            UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:cancleAction];
            
            [self presentViewController:alertVC animated:NO completion:nil];
            
        }
        
    }
    
}

- (void)dealloc{
    [_session stopRunning];
    _session = nil;
    
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
