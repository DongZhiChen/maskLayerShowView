//
//  ViewController.m
//  duoxianchen
//
//  Created by 陈东芝 on 16/9/12.
//  Copyright © 2016年 陈东芝. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "customButton.h"
#import "V_dynamicViewShow.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
 
    
    V_dynamicViewShow *view= [[V_dynamicViewShow alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    
    
}

-(void)clicknima:(UIButton *)sender{

    NSLog(@"wfeeefe");
    
}


-(void)clickCancel:(UIButton *)sender{

    NSLog(@"sdfsafawwwww");
}
-(void)clickFinish:(UIButton *)sender{

    NSLog(@"sdfsdfasf");
}
-(void)click:(UIButton *)sender{

    NSLog(@"sdf");
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
   
    
}
-(void)test{


    NSLog(@"test%@0",[NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
