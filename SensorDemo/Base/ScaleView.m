//
//  ScaleView.m
//  SensorDemo
//
//  Created by 王双龙 on 2017/7/26.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "ScaleView.h"


@interface ScaleView ()
{
    UIView * _backgroundView;
    UIView * _levelView;
    UIView * _verticalView;
}

@end


@implementation ScaleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = frame.size.width/2;
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_backgroundView];
        
        [self paintingScale];
    }
    
    return self;
}

//化刻度表
- (void)paintingScale{
    
    CGFloat perAngle = M_PI/(90);
    
    NSArray *array = @[@"北",@"东",@"南",@"西"];
    
    for (int i = 0; i < 180; i++) {
        
        CGFloat startAngle = (-(M_PI_2+M_PI/180/2)+perAngle*i);
        CGFloat endAngle = startAngle+perAngle/2;
        
        UIBezierPath *bezPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                               radius:(self.frame.size.width/2 - 50)
                                                           startAngle:startAngle
                                                             endAngle:endAngle
                                                            clockwise:YES];
        
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        if (i%15 == 0) {
            shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 20;
        }else{
            shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
            shapeLayer.lineWidth = 10;
        }
        
        shapeLayer.path = bezPath.CGPath;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [_backgroundView.layer addSublayer:shapeLayer];
        
        
        if (i % 15 == 0){
            //刻度的标注 0 30 60...
            NSString *tickText = [NSString stringWithFormat:@"%d",i * 2];
            CGFloat textAngel = startAngle+(endAngle-startAngle)/2;
            CGPoint point = [self calculateTextPositonWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                              Angle:textAngel andScale:1.2];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x, point.y, 30, 15)];
            label.center = point;
            label.text = tickText;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            [_backgroundView addSubview:label];
            
            if (i%45 == 0){
                //北 东 南 西
                tickText = array[i/45];
                CGPoint point2 = [self calculateTextPositonWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                                   Angle:textAngel andScale:0.8];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point2.x, point2.y, 30, 20)];
                label.center = point2;
                label.text = tickText;
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:20];
                label.textAlignment = NSTextAlignmentCenter;
                if ([tickText isEqualToString:@"北"]) {
                    UILabel * markLabel = [[UILabel alloc]initWithFrame:CGRectMake(point.x, point.y, 8, 8)];
                    markLabel.center = CGPointMake(point.x, point.y + 12);
                    markLabel.clipsToBounds = YES;
                    markLabel.layer.cornerRadius = 4;
                    markLabel.backgroundColor = [UIColor redColor];
                    [_backgroundView addSubview:markLabel];
                    
                }
                
                [_backgroundView addSubview:label];
            }
        }
    }
    
    
    //画十字线
    
    UIView *  levelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2/2, 1)];
    levelView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    levelView.backgroundColor = [UIColor whiteColor];
    [self addSubview:levelView];
    
    UIView *  verticalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.width/2/2)];
    verticalView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    verticalView.backgroundColor = [UIColor whiteColor];
    [self addSubview:verticalView];
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 -1.5, self.frame.size.height/2 - (self.frame.size.width/2 - 50) - 50, 3, 30 + 30)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    
}

//计算中心坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel andScale:(CGFloat)scale
{
    CGFloat x = (self.frame.size.width/2 - 50) * scale * cosf(angel);
    CGFloat y = (self.frame.size.width/2 - 50) * scale * sinf(angel);
    
    return CGPointMake(center.x + x, center.y + y);
}

//重置刻度标志的方向
- (void)resetDirection:(CGFloat)heading{
    
    _backgroundView.transform = CGAffineTransformMakeRotation(heading);
    
    for (UILabel * label in _backgroundView.subviews) {
        
        label.transform = CGAffineTransformMakeRotation(-heading);
        
    }
    
}


@end
