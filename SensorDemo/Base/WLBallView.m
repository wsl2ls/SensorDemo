//
//  WLBallView.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/18.
//  Copyright © 2017年 王双龙. All rights reserved.
//


#import "WLBallView.h"
#import "WLBallTool.h"

@interface WLBallView ()

@property (nonatomic, assign) UIDynamicItemCollisionBoundsType collisionBoundsType;

@property (nonatomic, strong) WLBallTool * ball;

@end

@implementation WLBallView

@synthesize collisionBoundsType;

- (instancetype)initWithFrame:(CGRect)frame AndImageName:(NSString *)imageName {
    
    if (self = [super initWithFrame:frame]) {
        
        self.image = [UIImage imageNamed:imageName];
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.layer.masksToBounds = YES;
        self.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
    }
    
    return self;
    
}


- (void)starMotion {
    
    WLBallTool * ball = [WLBallTool shareBallTool];
    
    [ball addAimView:self referenceView:self.superview];
}

- (void)stopMotion{
     WLBallTool * ball = [WLBallTool shareBallTool];
    [ball stopMotionUpdates];
}

@end
