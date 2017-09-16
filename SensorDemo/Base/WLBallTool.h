//
//  WLBallTool.h
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/18.
//  Copyright © 2017年 王双龙. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface WLBallTool : NSObject

//参照视图，设置仿真范围）
@property (nonatomic, weak) UIView * referenceView;

+ (instancetype)shareBallTool;

- (void)addAimView:(UIView *)ballView referenceView:(UIView *)referenceView;

- (void)stopMotionUpdates;

@end
