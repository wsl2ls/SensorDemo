//
//  FingerprintViewController.m
//  WSL
//
//  Created by 王双龙 on 16/10/24.
//  Copyright © 2016年 http://www.jianshu.com/users/e15d1f644bea All rights reserved.
//

#import "FingerprintViewController.h"
#import "LocalAuthentication/LAContext.h"

@interface FingerprintViewController ()
{
    NSString * _localizedReason;
}

@end

@implementation FingerprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"指纹识别";
    [self createBtn];
}
-(void)createBtn{
    UIButton *touchIDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchIDBtn.frame = CGRectMake(0, 0, 300, 300);
    touchIDBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [touchIDBtn setTitle:@"点击我进行指纹验证" forState:UIControlStateNormal];
    [touchIDBtn setImage:[UIImage imageNamed:@"指纹解锁"] forState:UIControlStateNormal];
    [touchIDBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [touchIDBtn addTarget:self action:@selector(OnTouchIDBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchIDBtn];
    touchIDBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    touchIDBtn.imageEdgeInsets = UIEdgeInsetsMake(50,  100,  80,  100);
    touchIDBtn.titleEdgeInsets = UIEdgeInsetsMake(200, 0, 50,  0);
    
}

-(void)OnTouchIDBtn:(UIButton *)sender{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        [self createAlterView:@"不支持指纹识别"];
        return;
    }else{
        LAContext *ctx = [[LAContext alloc] init];
        //设置 输入密码 按钮的标题
        ctx.localizedFallbackTitle = @"验证登录密码";
        //设置 取消 按钮的标题 iOS10之后
        ctx.localizedCancelTitle = @"取消";
        //检测指纹数据库更改 验证成功后返回一个NSData对象，否则返回nil
        //ctx.evaluatedPolicyDomainState;
        // 这个属性应该是类似于支付宝的指纹开启应用，如果你打开他解锁之后，按Home键返回桌面，再次进入支付宝是不需要录入指纹的。因为这个属性可以设置一个时间间隔，在时间间隔内是不需要再次录入。默认是0秒，最长可以设置5分钟
        //ctx.touchIDAuthenticationAllowableReuseDuration = 5;
        
        
        NSError * error;
        _localizedReason = @"通过Home键验证已有手机指纹";
        // 判断设备是否支持指纹识别
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
            
            // 验证指纹是否匹配，需要弹出输入密码的弹框的话：iOS9之后用 LAPolicyDeviceOwnerAuthentication ；      iOS9之前用LAPolicyDeviceOwnerAuthenticationWithBiometrics
            [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:_localizedReason reply:^(BOOL success, NSError * error) {
                if (success) {
                    [self createAlterView:@"指纹验证成功"];
                }else{
                    
                    // 错误码 error.code
                    NSLog(@"指纹识别错误描述 %@",error.description);
                    
                    // -1: 连续三次指纹识别错误
                    // -2: 在TouchID对话框中点击了取消按钮
                    // -3: 在TouchID对话框中点击了输入密码按钮
                    // -4: TouchID对话框被系统取消，例如按下Home或者电源键
                    // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    NSString * message;
                    switch (error.code) {
                        case -1://LAErrorAuthenticationFailed
                            message = @"已经连续三次指纹识别错误了，请输入密码验证";
                            _localizedReason = @"指纹验证失败";
                            break;
                        case -2:
                            message = @"在TouchID对话框中点击了取消按钮";
                            return ;
                            break;
                        case -3:
                            message = @"在TouchID对话框中点击了输入密码按钮";
                            break;
                        case -4:
                            message = @"TouchID对话框被系统取消，例如按下Home或者电源键或者弹出密码框";
                            break;
                        case -8:
                            message = @"TouchID已经被锁定,请前往设置界面重新启用";
                            break;
                        default:
                            break;
                    }
                    [self createAlterView:message];
                }
            }];
        }else{
            
            if (error.code == -8) {
                [self createAlterView:@"由于五次识别错误TouchID已经被锁定,请前往设置界面重新启用"];
            }else{
                [self createAlterView:@"TouchID没有设置指纹,请前往设置"];
            }
        }
    }
}

- (void)createAlterView:(NSString *)message{
    
    UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:vc animated:NO completion:^(void){
        [NSThread sleepForTimeInterval:1.0];
        [vc dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

/*
 typedef NS_ENUM(NSInteger, LAError)
 {
 //授权失败
 LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
 
 //用户取消Touch ID授权
 LAErrorUserCancel           = kLAErrorUserCancel,
 
 //用户选择输入密码
 LAErrorUserFallback         = kLAErrorUserFallback,
 
 //系统取消授权(例如其他APP切入)
 LAErrorSystemCancel         = kLAErrorSystemCancel,
 
 //系统未设置密码
 LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
 
 //设备Touch ID不可用，例如未打开
 LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
 
 //设备Touch ID不可用，用户未录入
 LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
 } NS_ENUM_AVAILABLE(10_10, 8_0);
 
 LAErrorTouchIDLockout   NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorTouchIDLockout,
 
 LAErrorAppCancel        NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorAppCancel,
 
 LAErrorInvalidContext   NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorInvalidContext
 
 其中，LAErrorTouchIDLockout是在8.0中也会出现的情况，但并未归为单独的错误类型，这个错误出现，源自用户多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁，这个错误的交互LocalAuthentication.framework已经封装好了，不需要开发者关心。
 
 LAErrorAppCancel和LAErrorSystemCancel相似，都是当前软件被挂起取消了授权，但是前者是用户不能控制的挂起，例如突然来了电话，电话应用进入前台，APP被挂起。后者是用户自己切到了别的应用，例如按home键挂起。
 
 LAErrorInvalidContext很好理解，就是授权过程中,LAContext对象被释放掉了，造成的授权失败。
 
 */

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
