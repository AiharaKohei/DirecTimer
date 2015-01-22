//
//  TimerView.m
//  InstantlyTimer
//
//  Created by aiharakohei on 2014/02/19.
//  Copyright (c) 2014年 aiharakohei. All rights reserved.
//

#import "TimerView.h"
#import "MainViewController.h"

@implementation TimerView

@synthesize timeLabel;
@synthesize pauseBtn;
@synthesize resumeBtn;
@synthesize moreappBtn;
@synthesize cancelBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    
    MainViewController *viewcontroller =  (MainViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;

    UIImage *resumeImg = [UIImage imageNamed:@"resume.png"];  // ボタンにする画像を生成する
    resumeBtn = [[UIButton alloc]
                           initWithFrame:CGRectMake(0, 260, resumeImg.size.width/2, resumeImg.size.height/2)];
    [resumeBtn setBackgroundImage:resumeImg forState:UIControlStateNormal];  // 画像をセットする
    [resumeBtn addTarget:viewcontroller
                  action:@selector(pressResume:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resumeBtn];
    
    
    UIImage *pauseImg = [UIImage imageNamed:@"pause.png"];  // ボタンにする画像を生成する
    pauseBtn = [[UIButton alloc]
                          initWithFrame:CGRectMake(-320, 260, pauseImg.size.width/2, pauseImg.size.height/2)];
    [pauseBtn setBackgroundImage:pauseImg forState:UIControlStateNormal];  // 画像をセットする
    [pauseBtn addTarget:viewcontroller
                 action:@selector(pressPause:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pauseBtn];
    
    
    
    UIImage *cancelImg = [UIImage imageNamed:@"cencel.png"];  // ボタンにする画像を生成する
    cancelBtn = [[UIButton alloc]
                           initWithFrame:CGRectMake(-320, 320, cancelImg.size.width/2, cancelImg.size.height/2)];
    [cancelBtn setBackgroundImage:cancelImg forState:UIControlStateNormal];  // 画像をセットする
    [cancelBtn addTarget:viewcontroller
                  action:@selector(pressCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    
    UIImage *moreappImg = [UIImage imageNamed:@"moreapp.png"];  // ボタンにする画像を生成する
    moreappBtn = [[UIButton alloc]
                            initWithFrame:CGRectMake(-320, 380, moreappImg.size.width/2, moreappImg.size.height/2)];
    [moreappBtn setBackgroundImage:moreappImg forState:UIControlStateNormal];  // 画像をセットする
    [moreappBtn addTarget:viewcontroller
                   action:@selector(pressMoreApp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreappBtn];
    

    
    return self;
}

@end
