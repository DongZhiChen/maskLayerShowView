//
//  V_dynamicViewShow.m
//  duoxianchen
//
//  Created by 陈东芝 on 16/9/18.
//  Copyright © 2016年 陈东芝. All rights reserved.
//

#import "V_dynamicViewShow.h"

#define radiu 30
#define maskLayerCenter CGPointMake(MainSize.width-radiu, MainSize.height-radiu)
#define  MainSize  [UIScreen mainScreen].bounds.size

#define V_BTN_BG_H  200
#define BTN_W_H  45

#define verticalitySpeace 20
#define  horizontalSpeace  ([UIScreen mainScreen].bounds.size.width -  (BTN_W_H * BTN_Row_Count)) / (BTN_Row_Count+1)

#define BTN_Top  20
#define BTN_Row_Count 3

#define showAnimationID @"showAnimation"

@implementation V_dynamicViewShow{

    CAShapeLayer *maskLayer;
    UIBezierPath *showPath;
    UIBezierPath *startPath;
    NSMutableArray *arrayBtns;
    UIButton *BTN_CloseOrOpen;
    
}

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if(self){
    
        self.backgroundColor= [UIColor blueColor];
        maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        
        arrayBtns =[NSMutableArray new];
        [self initView];
        [self openAddColseButton];
        [self createMenuButton];
        
        
    }
    
    return self;
    
}



-(void)openAddColseButton{

    BTN_CloseOrOpen  = [UIButton buttonWithType:UIButtonTypeCustom];
    BTN_CloseOrOpen.frame = CGRectMake(0, 0, radiu, radiu);
    BTN_CloseOrOpen.center = maskLayerCenter;
    [BTN_CloseOrOpen setTitle:@"+" forState:0];
    [BTN_CloseOrOpen addTarget:self action:@selector(BTN_OpenAddColse:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:BTN_CloseOrOpen];
    
}



-(void)createMenuButton{

    
    for(int i = 0; i < 3; i++){
        
        UIButton *BTN_Share = [UIButton buttonWithType:UIButtonTypeCustom];
        
        float x = (horizontalSpeace + BTN_W_H) * (i % BTN_Row_Count) + horizontalSpeace;
        float y = (BTN_W_H + verticalitySpeace)  *( i /BTN_Row_Count)  + verticalitySpeace + V_BTN_BG_H +BTN_Top;
        
        BTN_Share.frame =  CGRectMake(x, y, BTN_W_H, BTN_W_H);

        [BTN_Share setImage:[UIImage imageNamed:@"11"] forState:0];
        
        [BTN_Share addTarget:self action:@selector(BTN_Menu:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:BTN_Share];
        
        [arrayBtns addObject:BTN_Share];
        
    }
    
    
}



-(void)showShareButtonAnimation{
    
    for(int i = 0; i < arrayBtns.count; i++){
        
        UIButton *btn = (UIButton *) arrayBtns[i];
        ///显示btn延迟时间
        float begainTime = [btn.layer convertTime:CACurrentMediaTime() fromLayer:nil] +  i*0.1-i/BTN_Row_Count*0.3;
        CGPoint point = btn.layer.position;
        
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
        spring.delegate =  self;
        spring.mass = 1;
        spring.damping =5;
        spring.stiffness = 45;
        spring.initialVelocity = 0;
        spring.fromValue = @(point.y+80);
        spring.toValue = @(point.y );
        spring.beginTime =  begainTime;
        spring.duration = 0.8;
        [spring setValue:[NSNumber numberWithInt:i] forKey:showAnimationID];
        [btn.layer addAnimation:spring forKey:nil];
        
    }
    
    
}



-(void)initView{

   
    if(!startPath){
    
        startPath =[UIBezierPath bezierPath];
        [startPath addArcWithCenter:maskLayerCenter radius:radiu startAngle:0 endAngle:2*M_PI clockwise:YES];
    }
    
    maskLayer.path = startPath.CGPath;
    self.layer.mask = maskLayer;
 
    _isShow = NO;
    
}


#pragma mark - Show,Hidden Aniamtion -

-(void)showViewAniamtion{

    _isShow = YES;
    
    if( !showPath ){
    
        CGFloat x = maskLayerCenter.x;
        CGFloat y = maskLayerCenter.y;
        
        CGFloat maxRadiu = sqrtf(x*x + y*y);
        
        showPath = [UIBezierPath bezierPath];
        [showPath addArcWithCenter:maskLayerCenter radius:maxRadiu startAngle:0 endAngle:2*M_PI clockwise:YES];
    }
    
    CGFloat duration = 0.5;
    
    CABasicAnimation *showAniamtion = [CABasicAnimation animationWithKeyPath:@"path"];
    showAniamtion.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    showAniamtion.toValue =( id)showPath.CGPath;
    showAniamtion.duration = duration;
    [showAniamtion setValue:@"showPathAniamtion" forKey:@"showPathAniamtion"];
    showAniamtion.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showAniamtion.fillMode = kCAFillModeForwards;
    showAniamtion.removedOnCompletion = NO;
    
    [maskLayer addAnimation:showAniamtion forKey:@"showAniamtion"];

   
    CABasicAnimation* rotationAnimation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -315*M_PI/180 ];
    rotationAnimation.duration = duration;
    
    CABasicAnimation *moveAniamtion = [CABasicAnimation animationWithKeyPath:@"position.x"];
    moveAniamtion.toValue = [NSNumber numberWithFloat:self.bounds.size.width/2.0];
    moveAniamtion.duration = duration;

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = duration;
    group.animations = @[rotationAnimation,moveAniamtion];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.delegate = self;
    [group setValue:@"btnShowAnimation" forKey:@"btnShowAnimation"];
    
    [BTN_CloseOrOpen.layer addAnimation:group forKey:@"btnAnimation"];
    
    
    [self showShareButtonAnimation];
    
    //for(int i = 0; i < arrayBtns.count; i++){
//    
//        UIButton *btn = arrayBtns[i];
//        [self menuButtonAnimationWithButton:btn addBegainTime:i*0.1+0.5];
//    }
}


-(void)menuButtonAnimationWithButton:(UIButton *)btn addBegainTime:(CGFloat)begainTime{

    CASpringAnimation *aniamtion = [CASpringAnimation animationWithKeyPath:@"position.y"];
    aniamtion.damping = 0.4;
    aniamtion.fromValue = [NSNumber numberWithFloat:btn.center.y-50];
    aniamtion.toValue = [NSNumber numberWithFloat:btn.center.y];
    aniamtion.duration = 0.3;
    aniamtion.beginTime = begainTime;
    [btn.layer addAnimation:aniamtion forKey:nil];
    
    

}
-(void)hiddenViewAnimation{

    _isShow = NO;
    CABasicAnimation *hiddenAniamtion = [CABasicAnimation animationWithKeyPath:@"path"];
    hiddenAniamtion.fromValue = (__bridge id _Nullable)(showPath.CGPath);
    hiddenAniamtion.toValue =( id)startPath.CGPath;
    hiddenAniamtion.duration = 0.5;
    hiddenAniamtion.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    hiddenAniamtion.fillMode = kCAFillModeForwards;
    hiddenAniamtion.removedOnCompletion = NO;
    [maskLayer addAnimation:hiddenAniamtion forKey:@"hiddenShowAniamtion"];

    
       CGFloat duration = 0.5;
    
    CABasicAnimation* rotationAnimation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: 360*M_PI/180 ];
    rotationAnimation.duration = duration;
    
    CABasicAnimation *moveAniamtion = [CABasicAnimation animationWithKeyPath:@"position.x"];
    moveAniamtion.toValue = [NSNumber numberWithFloat:maskLayerCenter.x];
    moveAniamtion.duration = duration;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = duration;
    group.animations = @[rotationAnimation,moveAniamtion];
    group.delegate = self;
    [group setValue:@"btnHiddenAnimation" forKey:@"btnHiddenAnimation"];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    
    [BTN_CloseOrOpen.layer addAnimation:group forKey:@"btnHiddenAnimation"];

}

#pragma mark  - AnimaitonDelegate -

-(void)animationDidStart:(CAAnimation *)anim{
    
//    if([anim valueForKey:showAnimationID]){
//        
//        NSInteger index = [[anim valueForKey:showAnimationID] integerValue];
//        
//        UIView *view = arrayBtns [index];
//        CGPoint center = view.center;
//        center.y -= 80;
//        view.center = center;
//        
//        
//    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if([anim valueForKey:@"btnShowAnimation"]){
    
        maskLayer.path = showPath.CGPath;
        
        CGPoint center = BTN_CloseOrOpen.center;
        center.x = self.bounds.size.width/2.0;
        BTN_CloseOrOpen.center = center;
        
        
    }else if([anim valueForKey:@"btnHiddenAnimation"]){
    
        maskLayer.path = startPath.CGPath;
        BTN_CloseOrOpen.center = maskLayerCenter;
        
        
    }
}


#pragma mark - UIButtonEventClick -

-(void)BTN_OpenAddColse:(UIButton *)sender{

    [maskLayer removeAllAnimations];
    
    if(_isShow){
    
        [self hiddenViewAnimation];
        
    }else{
        
        [self showViewAniamtion];
    }

}


-(void)BTN_Menu:(UIButton *)sender{


}
#pragma mark - 点击判断 - 

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{

    
    return CGPathContainsPoint(maskLayer.path, NULL, point, NO);
    
}


@end
