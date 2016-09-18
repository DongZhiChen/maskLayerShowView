//
//  customButton.m
//  duoxianchen
//
//  Created by 陈东芝 on 16/9/13.
//  Copyright © 2016年 陈东芝. All rights reserved.
//

#import "customButton.h"

@implementation customButton{

    CAShapeLayer *shapeTouchBegain;
    
}

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if(self){
    
        shapeTouchBegain = [CAShapeLayer layer];
        shapeTouchBegain.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:shapeTouchBegain];
        
    
    }
    
    return self;
    
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{

    [self animationTouchBegain];
    


    return YES;
}


-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{

 CGPoint point = [touch locationInView:self];
    
    NSLog(@"%@",NSStringFromCGPoint(point));
}


-(void)animationTouchBegain{

    CGFloat centerX = self.bounds.size.width/2.0;
    CGFloat centerY = self.bounds.size.height/2.0;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:centerY startAngle:0 endAngle:2*M_PI clockwise:YES];
    shapeTouchBegain.path = path.CGPath;
    
  
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithInt:0];
    animation.toValue = [NSNumber numberWithInt:1];
    animation.duration = 1;
    [shapeTouchBegain addAnimation:animation forKey:nil];
    
}


@end
