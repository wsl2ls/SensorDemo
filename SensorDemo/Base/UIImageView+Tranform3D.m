//
//  UIImageView+Tranform3D.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/18.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "UIImageView+Tranform3D.h"

@implementation UIImageView (Tranform3D)

- (void)setRotation:(CGFloat)degress{
    
    CATransform3D tranform = CATransform3DIdentity;
    tranform.m34 = 1.0 / 100;
    CGFloat radiants = degress / 360 * M_PI;
    //旋转
    tranform = CATransform3DRotate(tranform, radiants, 1.0f, 0.0f, 0.0f);
    
    //锚点
    CALayer * layer = self.layer;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.transform = tranform;
    
}

@end
