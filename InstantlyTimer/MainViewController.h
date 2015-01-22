//
//  ViewController.h
//  InstantlyTimer
//
//  Created by aiharakohei on 2014/02/18.
//  Copyright (c) 2014年 aiharakohei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingView.h"
#import "TimerView.h"
#import "StartView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define SETTING_MODE 0
#define START_MODE 1
#define TIMER_MODE 2

@interface MainViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
    StartView *startView;
    TimerView *timerView;
    SettingView *settingView;
    
    UIButton *settingBtn;
    UIButton *startBtn;
    UIButton *pattern1Btn;
    UIButton *pattern2Btn;
    UIButton *pattern3Btn;
    
    UIView *pickerView;
    UIPickerView *picker;
    UIButton *storeBtn;
    UIButton *backBtn;
    
    UIButton *pauseBtn;
    UIButton *resumeBtn;
    UIButton *moreappBtn;
    UIButton *cancelBtn;

    int stockMinute;
    int stockSecond;

    
    int storeNum;
    BOOL is4inch;
    
    AVAudioPlayer *audioPlayer;
    
    BOOL isTouchEnabeld;
    
    
}

@property BOOL isTimerRunning;
@property float minute;
@property float second;
@property UILabel *timeLabel;
@property NSTimer *timer;
@property int nowMode;
@property int prevMode;


-(void)pressCancel:(id)sender;
-(void)pressStart:(id)sender;
-(void)pressBack:(id)sender;
-(void)startTimer;

@end
