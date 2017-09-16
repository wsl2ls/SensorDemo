//
//  WLBallView.h
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/18.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLBallView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame AndImageName:(NSString *)imageName;

- (void)starMotion;

- (void)stopMotion;

@end
