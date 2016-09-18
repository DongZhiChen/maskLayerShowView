//
//  V_dynamicViewShow.m
//  duoxianchen
//
//  Created by 陈东芝 on 16/9/18.
//  Copyright © 2016年 陈东芝. All rights reserved.
//

#import "V_dynamicViewShow.h"

#define radiu 50
#define maskLayerCenter CGPointMake(MainSize.width-radiu, MainSize.height-radiu)
#define  MainSize  [UIScreen mainScreen].bounds.size

#define V_BTN_BG_H  300
#define BTN_W_H  80

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
    
}

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if(self){
    
        self.backgroundColor = [UIColor blueColor];
    
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

    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 50);
    btn.center = maskLayerCenter;
    [btn setTitle:@"X" forState:0];
    [btn addTarget:self action:@selector(BTN_OpenAddColse:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}


-(void)createMenuButton{

    
    for(int i = 0; i < 3; i++){
        
        UIButton *BTN_Share = [UIButton buttonWithType:UIButtonTypeCustom];
        
        float x = (horizontalSpeace + BTN_W_H) * (i % BTN_Row_Count) + horizontalSpeace;
        float y = (BTN_W_H + verticalitySpeace)  *( i /BTN_Row_Count)  + verticalitySpeace + V_BTN_BG_H +BTN_Top;
        
        BTN_Share.frame =  CGRectMake(x, y, BTN_W_H, BTN_W_H);
        [BTN_Share setTitle:@"sdfasd" forState:0];
        
        
        [BTN_Share addTarget:self action:@selector(BTN_Share:) forControlEvents:UIControlEventTouchUpInside];
        
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
        spring.damping =7;
        spring.stiffness = 45;
        spring.initialVelocity = 0;
        spring.fromValue = @(point.y);
        spring.toValue = @(point.y - V_BTN_BG_H);
        spring.beginTime =  begainTime;
        spring.duration = 1.5;
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
    
}


-(void)showViewAniamtion{

    if( !showPath ){
    
        showPath = [UIBezierPath bezierPath];
        [showPath addArcWithCenter:maskLayerCenter radius:MainSize.height+radiu startAngle:0 endAngle:2*M_PI clockwise:YES];
    }
    
    CABasicAnimation *showAniamtion = [CABasicAnimation animationWithKeyPath:@"path"];
    showAniamtion.toValue =( id)showPath.CGPath;
    showAniamtion.duration = 1;
    [showAniamtion setValue:@"showAniamtion" forKey:@"showAniamtion"];
    showAniamtion.delegate = self;
    showAniamtion.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    [maskLayer addAnimation:showAniamtion forKey:nil];

}


-(void)animationDidStart:(CAAnimation *)anim{
    
    if([anim valueForKey:showAnimationID]){
        
        NSInteger index = [[anim valueForKey:showAnimationID] integerValue];
        
        UIView *view = arrayBtns [index];
        CGRect frame =  view.layer.frame;
        
        frame.origin.y -= V_BTN_BG_H;
        view.layer.frame = frame;
        
        
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if([anim valueForKey:@"showAniamtion"]){
    
        maskLayer.path = showPath.CGPath;
    }
}


-(void)BTN_OpenAddColse:(UIButton *)sender{

    [self showViewAniamtion];

}
@end
