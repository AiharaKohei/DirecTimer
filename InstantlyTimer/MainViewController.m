//
//  ViewController.m
//  InstantlyTimer
//
//  Created by aiharakohei on 2014/02/18.
//  Copyright (c) 2014年 aiharakohei. All rights reserved.
//

#import "MainViewController.h"
#import "AMoAdSDK.h"


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize isTimerRunning;
@synthesize minute;
@synthesize second;
@synthesize timeLabel;
@synthesize timer;
@synthesize nowMode;
@synthesize prevMode;

#define MOVE_DEALY 0.2

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.137 green:0.694 blue:0.627 alpha:1.0]];
    if ([[UIScreen mainScreen ]bounds].size.height > 480.0) {
        is4inch = YES;
    } else {
        is4inch = NO;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"timer_sound" ofType:@"mp3"];
    
    // ファイルのパスを NSURL へ変換します。
    NSURL* url = [NSURL fileURLWithPath:path];
    
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [audioPlayer setNumberOfLoops:-1];
    [audioPlayer prepareToPlay];
    
    
    nowMode = TIMER_MODE;
    
    [self initSettingView];
    
    [self initTimerView];
    
    [self initStartView];
    
    UIImage *settingImg = [UIImage imageNamed:@"setting.png"];  // ボタンにする画像を生成する
    UIImage *settingHighlightedImg = [UIImage imageNamed:@"setting_h.png"];
    settingBtn = [[UIButton alloc]
                  initWithFrame:CGRectMake(0, 440 - (is4inch ? 0 : 50), settingImg.size.width/2, settingImg.size.height/2)];
    [settingBtn setBackgroundImage:settingImg forState:UIControlStateNormal];  // 画像をセットする
    [settingBtn setBackgroundImage:settingHighlightedImg forState:UIControlStateHighlighted];
    [settingBtn addTarget:self
                   action:@selector(pressSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];

    
    
    timeLabel = [[UILabel alloc]init];
    timeLabel.frame =  CGRectMake(47, 76- (is4inch ? 0 : 30), 226, 115);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:90];
    timeLabel.font = font;
    timeLabel.textColor = [UIColor whiteColor];
    [timeLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [self.view addSubview:timeLabel];
    
    
    [self startTimer];
    
    isTouchEnabeld = YES;
}

-(void)initTimerView{
    UIImage *resumeImg = [UIImage imageNamed:@"resume.png"];  // ボタンにする画像を生成する
    UIImage *resumeHighlightedImg = [UIImage imageNamed:@"resume_h.png"];

    resumeBtn = [[UIButton alloc]
                 initWithFrame:CGRectMake(320, 260- (is4inch ? 0 : 50), resumeImg.size.width/2, resumeImg.size.height/2)];
    [resumeBtn setBackgroundImage:resumeImg forState:UIControlStateNormal];  // 画像をセットする
    [resumeBtn setBackgroundImage:resumeHighlightedImg forState:UIControlStateHighlighted];
    [resumeBtn addTarget:self
                  action:@selector(pressResume:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeBtn];
    
    
    UIImage *pauseImg = [UIImage imageNamed:@"pause.png"];  // ボタンにする画像を生成する
    UIImage *pauseHighlightedImg = [UIImage imageNamed:@"pause_h.png"];

    pauseBtn = [[UIButton alloc]
                initWithFrame:CGRectMake(0, 260- (is4inch ? 0 : 50), pauseImg.size.width/2, pauseImg.size.height/2)];
    [pauseBtn setBackgroundImage:pauseImg forState:UIControlStateNormal];  // 画像をセットする
    [pauseBtn setBackgroundImage:pauseHighlightedImg forState:UIControlStateHighlighted];
    [pauseBtn addTarget:self
                 action:@selector(pressPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBtn];
    
    
    
    UIImage *cancelImg = [UIImage imageNamed:@"cencel.png"];  // ボタンにする画像を生成する
    UIImage *cancelHighlightedImg = [UIImage imageNamed:@"cancel_h.png"];

    cancelBtn = [[UIButton alloc]
                 initWithFrame:CGRectMake(0, 320- (is4inch ? 0 : 50), cancelImg.size.width/2, cancelImg.size.height/2)];
    [cancelBtn setBackgroundImage:cancelImg forState:UIControlStateNormal];  // 画像をセットする
    [cancelBtn setBackgroundImage:cancelHighlightedImg forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self
                  action:@selector(pressCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    UIImage *moreappImg = [UIImage imageNamed:@"moreapp.png"];  // ボタンにする画像を生成する
    UIImage *moreappHighlightedImg = [UIImage imageNamed:@"moreapp_h.png"];

    moreappBtn = [[UIButton alloc]
                  initWithFrame:CGRectMake(0, 380- (is4inch ? 0 : 50), moreappImg.size.width/2, moreappImg.size.height/2)];
    [moreappBtn setBackgroundImage:moreappImg forState:UIControlStateNormal];  // 画像をセットする
    [moreappBtn setBackgroundImage:moreappHighlightedImg forState:UIControlStateHighlighted];
    [moreappBtn addTarget:self
                   action:@selector(pressMoreApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreappBtn];

}

-(void)initSettingView{
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, 200)];
    
    [self.view addSubview:pickerView];
    // UIPickerのインスタンス化
    picker = [[UIPickerView alloc]init];
    // デリゲートを設定
    picker.delegate = self;
    
    // データソースを設定
    picker.dataSource = self;
    
    // 選択インジケータを表示
    picker.showsSelectionIndicator = YES;
    
    
    
    // UIPickerのインスタンスをビューに追加
    
    [pickerView addSubview:picker];
    
    UIImage *storeImg = [UIImage imageNamed:@"store.png"];  // ボタンにする画像を生成する
    UIImage *storeHighlightedImg = [UIImage imageNamed:@"store_h.png"];

    storeBtn = [[UIButton alloc]
                     initWithFrame:CGRectMake(320, 320- (is4inch ? 0 : 50), storeImg.size.width/2, storeImg.size.height/2)];  // ボタンのサイズを指定する
    [storeBtn setBackgroundImage:storeImg forState:UIControlStateNormal];  // 画像をセットする
    [storeBtn setBackgroundImage:storeHighlightedImg forState:UIControlStateHighlighted];
    [storeBtn addTarget:self
                      action:@selector(pressStore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:storeBtn];
    
    
    UIImage *backImg = [UIImage imageNamed:@"timer.png"];  // ボタンにする画像を生成する
    UIImage *backHighlightedImg = [UIImage imageNamed:@"timer_h.png"];
    backBtn = [[UIButton alloc]
                    initWithFrame:CGRectMake(320, 440- (is4inch ? 0 : 50), backImg.size.width/2, backImg.size.height/2)];  // ボタンのサイズを指定する
    [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];  // 画像をセットする
    [backBtn setBackgroundImage:backHighlightedImg forState:UIControlStateHighlighted];
    [backBtn addTarget:self
                     action:@selector(pressBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)initStartView {
    UIImage *startImg = [UIImage imageNamed:@"start.png"];  // ボタンにする画像を生成する
    UIImage *startHighlightedImg = [UIImage imageNamed:@"start_h.png"];

    startBtn = [[UIButton alloc]
                      initWithFrame:CGRectMake(320, 320- (is4inch ? 0 : 50), startImg.size.width/2, startImg.size.height/2)];  // ボタンのサイズを指定する
    [startBtn setBackgroundImage:startImg forState:UIControlStateNormal];  // 画像をセットする
    [startBtn setBackgroundImage:startHighlightedImg forState:UIControlStateHighlighted];
    [startBtn addTarget:self
                 action:@selector(pressStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIImage *pattern1Img = [UIImage imageNamed:@"1.png"];  // ボタンにする画像を生成する
    UIImage *pattern1HighlightedImg = [UIImage imageNamed:@"1_h.png"];
    pattern1Btn = [[UIButton alloc]
                             initWithFrame:CGRectMake(320, 380- (is4inch ? 0 : 50), pattern1Img.size.width/2, pattern1Img.size.height/2)];
    [pattern1Btn setBackgroundImage:pattern1Img forState:UIControlStateNormal];  // 画像をセットする
    [pattern1Btn setBackgroundImage:pattern1HighlightedImg forState:UIControlStateHighlighted];
    [pattern1Btn addTarget:self
                    action:@selector(pressPattern:) forControlEvents:UIControlEventTouchUpInside];
    [pattern1Btn setTag:1];
    [self.view addSubview:pattern1Btn];
    
    UIImage *pattern2Img = [UIImage imageNamed:@"2.png"];  // ボタンにする画像を生成する
    UIImage *pattern2HighlightedImg = [UIImage imageNamed:@"2_h.png"];

    pattern2Btn = [[UIButton alloc]
                            initWithFrame:CGRectMake(427, 380- (is4inch ? 0 : 50), pattern2Img.size.width/2, pattern2Img.size.height/2)];
    [pattern2Btn setBackgroundImage:pattern2Img forState:UIControlStateNormal];  // 画像をセットする
    [pattern2Btn setBackgroundImage:pattern2HighlightedImg forState:UIControlStateHighlighted];
    [pattern2Btn addTarget:self
                    action:@selector(pressPattern:) forControlEvents:UIControlEventTouchUpInside];
    [pattern2Btn setTag:2];
    [self.view addSubview:pattern2Btn];
    
    UIImage *pattern3Img = [UIImage imageNamed:@"3.png"];  // ボタンにする画像を生成する
    UIImage *pattern3HighlightedImg = [UIImage imageNamed:@"3_h.png"];

    pattern3Btn = [[UIButton alloc]
                             initWithFrame:CGRectMake(534, 380- (is4inch ? 0 : 50), pattern3Img.size.width/2, pattern3Img.size.height/2)];
    [pattern3Btn setBackgroundImage:pattern3Img forState:UIControlStateNormal];  // 画像をセットする
    [pattern3Btn setBackgroundImage:pattern3HighlightedImg forState:UIControlStateHighlighted];
    [pattern3Btn addTarget:self
                    action:@selector(pressPattern:) forControlEvents:UIControlEventTouchUpInside];
    [pattern3Btn setTag:3];
    [self.view addSubview:pattern3Btn];
    
    NSNumber *patternNum = (NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPattern"];
    switch ([patternNum intValue]) {
        case 1:
            [pattern1Btn setBackgroundImage:pattern1HighlightedImg forState:UIControlStateNormal];  // 画像をセットする
            break;
        case 2:
            [pattern2Btn setBackgroundImage:pattern2HighlightedImg forState:UIControlStateNormal];  // 画像をセットする
            break;
        case 3:
            [pattern3Btn setBackgroundImage:pattern3HighlightedImg forState:UIControlStateNormal];  // 画像をセットする
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTimer{
    self.isTimerRunning = YES;
    nowMode = TIMER_MODE;
    
    NSNumber *patternNum = (NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPattern"];
    self.minute = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dMinute",[patternNum intValue]]]floatValue];
    self.second = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dSecond",[patternNum intValue]]]floatValue];
    
    timeLabel.text = [NSString stringWithFormat:@"%02.f:%02.f", self.minute,self.second ];
    
    
    timer =[NSTimer scheduledTimerWithTimeInterval:0.1f
                                         target:self
                                       selector:@selector(countDown:)
                                       userInfo:nil
                                        repeats:YES
         ];
}

-(void)pressStart:(id)sender{
    if (isTouchEnabeld) {
        if(!self.isTimerRunning){
//            isTouchEnabeld = NO;
            [self performSelector:@selector(setIsTouchEnabeld) withObject:nil afterDelay:1.4];
            [self moveOffScreen:0.0 selectedView:startBtn];
            [self moveCenter:MOVE_DEALY selectedView:pauseBtn];
            [self moveOffScreen:MOVE_DEALY  moveToPosition:0 selectedView:pattern1Btn];
            [self moveOffScreen:MOVE_DEALY+0.1  moveToPosition:107 selectedView:pattern2Btn];
            [self moveOffScreen:MOVE_DEALY+ 0.2  moveToPosition:214 selectedView:pattern3Btn];
            [self moveCenter:MOVE_DEALY*2 selectedView:cancelBtn];
            [self moveCenter:MOVE_DEALY*3 selectedView:moreappBtn];
            
            nowMode = TIMER_MODE;
            [self startTimer];
        }
    }
}

-(void)pressResume:(id)sender{
    if (isTouchEnabeld) {
        self.isTimerRunning = YES;
        
        
        timer =[NSTimer scheduledTimerWithTimeInterval:0.1f
                                                target:self
                                              selector:@selector(countDown:)
                                              userInfo:nil
                                               repeats:YES
                ];
        
        [self moveOffScreen:0.0f selectedView:resumeBtn];
        [self moveCenter:MOVE_DEALY selectedView:pauseBtn];
    }
    
}

-(void)pressPause:(id)sender{
    if (isTouchEnabeld) {
        [timer invalidate];
        self.isTimerRunning = NO;
        
        [self moveOffScreen:0.0 selectedView:pauseBtn];
        [self moveCenter:MOVE_DEALY selectedView:resumeBtn];
    }
}

-(void)pressCancel:(id)sender{
    if (isTouchEnabeld) {
        UIImage *pattern1Img = [UIImage imageNamed:@"1.png"];  // ボタンにする画像を生成する
        [pattern1Btn setBackgroundImage:pattern1Img forState:UIControlStateNormal];  // 画像をセットする
        UIImage *pattern2Img = [UIImage imageNamed:@"2.png"];  // ボタンにする画像を生成する
        [pattern2Btn setBackgroundImage:pattern2Img forState:UIControlStateNormal];  // 画像をセットする
        UIImage *pattern3Img = [UIImage imageNamed:@"3.png"];  // ボタンにする画像を生成する
        [pattern3Btn setBackgroundImage:pattern3Img forState:UIControlStateNormal];  // 画像をセットする
        
        
        
        NSNumber *patternNum = (NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPattern"];
        switch ([patternNum intValue]) {
            case 1:
                [pattern1Btn setBackgroundImage:[pattern1Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                break;
            case 2:
                [pattern2Btn setBackgroundImage:[pattern2Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                break;
            case 3:
                [pattern3Btn setBackgroundImage:[pattern3Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                break;
                
            default:
                break;
        }
        
        self.minute = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dMinute",[patternNum intValue]]]floatValue];
        self.second = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dSecond",[patternNum intValue]]]floatValue];
        
        timeLabel.text = [NSString stringWithFormat:@"%02.f:%02.f", self.minute,self.second ];
        
        
        
        [timer invalidate];
        if (isTimerRunning) {
            [self moveOffScreen:0.0 selectedView:pauseBtn];
            
        } else {
            [self moveOffScreen:0.0 selectedView:resumeBtn];
        }
        [self moveOffScreen:MOVE_DEALY selectedView:cancelBtn];
        [self moveCenter:MOVE_DEALY selectedView:startBtn];
        [self moveOffScreen:MOVE_DEALY*2 selectedView:moreappBtn];
        [self moveCenter:MOVE_DEALY*2 moveToPosition:0 selectedView:pattern1Btn];
        [self moveCenter:MOVE_DEALY*2+0.1 moveToPosition:107 selectedView:pattern2Btn];
        [self moveCenter:MOVE_DEALY*2+0.2 moveToPosition:214 selectedView:pattern3Btn];
        
        nowMode = START_MODE;
        self.isTimerRunning = NO;
    }
}

-(void)pressMoreApp:(id)sender{
    [AMoAdSDK showAppliPromotionWall:self];

}

-(void)pressSetting:(id)sender{
    
    if (isTouchEnabeld) {
        UIImage *pattern1Img = [UIImage imageNamed:@"1.png"];  // ボタンにする画像を生成する
        [pattern1Btn setBackgroundImage:pattern1Img forState:UIControlStateNormal];  // 画像をセットする
        UIImage *pattern2Img = [UIImage imageNamed:@"2.png"];  // ボタンにする画像を生成する
        [pattern2Btn setBackgroundImage:pattern2Img forState:UIControlStateNormal];  // 画像をセットする
        UIImage *pattern3Img = [UIImage imageNamed:@"3.png"];  // ボタンにする画像を生成する
        [pattern3Btn setBackgroundImage:pattern3Img forState:UIControlStateNormal];  // 画像をセットする
        
        
        
        NSNumber *patternNum = (NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPattern"];
        
        storeNum = [patternNum intValue];
        NSLog(@"patternNum == %d", [patternNum intValue]);
        switch ([patternNum intValue]) {
            case 1:
                [pattern1Btn setBackgroundImage:[pattern1Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                break;
            case 2:
                [pattern2Btn setBackgroundImage:[pattern2Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                break;
            case 3:
                [pattern3Btn setBackgroundImage:[pattern3Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                break;
                
            default:
                break;
        }
        NSNumber *selectedMinute = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dMinute",[patternNum intValue]]];
        NSNumber *selectedSecond = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dSecond",[patternNum intValue]]];
        
        stockMinute = [selectedMinute intValue];
        stockSecond = [selectedSecond intValue];
        
        
        [picker selectRow:[selectedMinute intValue] inComponent:0 animated:YES];
        [picker selectRow:[selectedSecond intValue] inComponent:1 animated:YES];
        
        
        
        
        prevMode = nowMode;
        nowMode = SETTING_MODE;
        
        [self moveOffScreen:0.0 moveToPosition:47 selectedView:timeLabel];
        [self moveCenter:MOVE_DEALY selectedView:pickerView];
        
        if (prevMode == START_MODE) {
            [self moveOffScreen:MOVE_DEALY selectedView:startBtn];
            [self moveCenter:MOVE_DEALY*2 selectedView:storeBtn];
            [self moveOffScreen:MOVE_DEALY*2 selectedView:settingBtn];
            [self moveCenter:MOVE_DEALY*3 selectedView:backBtn];
            
            
        } else if (prevMode == TIMER_MODE) {
            if (isTimerRunning) {
                [self moveOffScreen:MOVE_DEALY selectedView:pauseBtn];
                
            } else {
                [self moveOffScreen:MOVE_DEALY selectedView:resumeBtn];
                
            }
            [self moveCenter:MOVE_DEALY*2 selectedView:storeBtn];
            [self moveOffScreen:MOVE_DEALY*2 selectedView:cancelBtn];
            [self moveCenter:MOVE_DEALY*3 moveToPosition:0 selectedView:pattern1Btn];
            [self moveCenter:MOVE_DEALY*3+0.1 moveToPosition:107 selectedView:pattern2Btn];
            [self moveCenter:MOVE_DEALY*3+0.2 moveToPosition:214 selectedView:pattern3Btn];
            [self moveOffScreen:MOVE_DEALY*3 selectedView:moreappBtn];
            [self moveCenter:MOVE_DEALY*4 selectedView:backBtn];
            [self moveOffScreen:MOVE_DEALY*4 selectedView:settingBtn];
        }

    }
}
-(void)pressBack:(id)sender{
    if (isTouchEnabeld) {
        [self moveOffScreen:0.0 selectedView:pickerView];
        [self moveCenter:MOVE_DEALY moveToPosition:47 selectedView:timeLabel];
        
        if (prevMode == START_MODE) {
            
            UIImage *pattern1Img = [UIImage imageNamed:@"1.png"];  // ボタンにする画像を生成する
            [pattern1Btn setBackgroundImage:pattern1Img forState:UIControlStateNormal];  // 画像をセットする
            UIImage *pattern2Img = [UIImage imageNamed:@"2.png"];  // ボタンにする画像を生成する
            [pattern2Btn setBackgroundImage:pattern2Img forState:UIControlStateNormal];  // 画像をセットする
            UIImage *pattern3Img = [UIImage imageNamed:@"3.png"];  // ボタンにする画像を生成する
            [pattern3Btn setBackgroundImage:pattern3Img forState:UIControlStateNormal];  // 画像をセットする
            
            
            
            NSNumber *patternNum = (NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPattern"];
            NSLog(@"patternNum == %d", [patternNum intValue]);
            switch ([patternNum intValue]) {
                case 1:
                    [pattern1Btn setBackgroundImage:[pattern1Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                    break;
                case 2:
                    [pattern2Btn setBackgroundImage:[pattern2Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                    break;
                case 3:
                    [pattern3Btn setBackgroundImage:[pattern3Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
                    break;
                    
                default:
                    break;
            }
            
            
            
            self.minute = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dMinute",[patternNum intValue]]]floatValue];
            self.second = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dSecond",[patternNum intValue]]]floatValue];
            
            timeLabel.text = [NSString stringWithFormat:@"%02.f:%02.f", self.minute,self.second ];
            
            [self moveOffScreen:MOVE_DEALY selectedView:storeBtn];
            [self moveCenter:MOVE_DEALY*2 selectedView:startBtn];
            [self moveOffScreen:MOVE_DEALY*2 selectedView:backBtn];
            [self moveCenter:MOVE_DEALY*3 selectedView:settingBtn];
            
        } else if (prevMode == TIMER_MODE) {
            [self moveOffScreen:MOVE_DEALY selectedView:storeBtn];
            
            if (isTimerRunning) {
                [self moveCenter:MOVE_DEALY*2 selectedView:pauseBtn];
                
            } else {
                [self moveCenter:MOVE_DEALY*2 selectedView:resumeBtn];
                
            }
            [self moveOffScreen:MOVE_DEALY*2 moveToPosition:0 selectedView:pattern1Btn];
            [self moveOffScreen:MOVE_DEALY*2+0.1 moveToPosition:107 selectedView:pattern2Btn];
            [self moveOffScreen:MOVE_DEALY*2+0.2 moveToPosition:214 selectedView:pattern3Btn];
            [self moveCenter:MOVE_DEALY*3 selectedView:cancelBtn];
            [self moveOffScreen:MOVE_DEALY*3 selectedView:backBtn];
            [self moveCenter:MOVE_DEALY*4 selectedView:moreappBtn];
            [self moveCenter:MOVE_DEALY*5 selectedView:settingBtn];
        }
        nowMode = prevMode;
        prevMode = SETTING_MODE;
    }
    
}

-(void)countDown:(NSTimer*)timer{
    
    
    self.second = self.second - 0.1;

    if (self.second <= 0.0) {
        self.second = 59.9;
        self.minute--;
    }
    
    
    if (self.minute < 0.0) {
        [timer invalidate];
        
        [audioPlayer play];
        

        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"timeOver", nil)
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        
        if (nowMode == SETTING_MODE) {
            prevMode = START_MODE;
        } else if (nowMode == TIMER_MODE){
            [self pressCancel:nil];

        }
        isTimerRunning = NO;

    }
    if (self.second >= 59.0 && self.second < 60.0) {
        timeLabel.text = [NSString stringWithFormat:@"%02.f:00", ceilf(self.minute + 1.0)];
    } else{
        timeLabel.text = [NSString stringWithFormat:@"%02.f:%02.0f", ceilf(self.minute),ceilf(self.second)];
    }
    
    NSLog(@"%s  %f  %f", [timeLabel.text UTF8String], self.minute, self.second);
 
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [audioPlayer stop];
    }
    
}

-(void)pressPattern:(id)sender{
    UIButton *btn = (UIButton*)sender;
    int patternNum = (int)[btn tag];
    
    NSNumber *selectedMinute = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dMinute",patternNum]];
    NSNumber *selectedSecond = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dSecond",patternNum]];

    
    UIImage *pattern1Img = [UIImage imageNamed:@"1.png"];  // ボタンにする画像を生成する
    [pattern1Btn setBackgroundImage:pattern1Img forState:UIControlStateNormal];  // 画像をセットする
    UIImage *pattern2Img = [UIImage imageNamed:@"2.png"];  // ボタンにする画像を生成する
    [pattern2Btn setBackgroundImage:pattern2Img forState:UIControlStateNormal];  // 画像をセットする
    UIImage *pattern3Img = [UIImage imageNamed:@"3.png"];  // ボタンにする画像を生成する
    [pattern3Btn setBackgroundImage:pattern3Img forState:UIControlStateNormal];  // 画像をセットする
    
    
        switch (patternNum) {
        case 1:
            [pattern1Btn setBackgroundImage:[pattern1Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
            break;
        case 2:
            [pattern2Btn setBackgroundImage:[pattern2Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
            break;
        case 3:
            [pattern3Btn setBackgroundImage:[pattern3Btn backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];  // 画像をセットする
            break;
            
        default:
            break;
    }
    
    NSLog(@"selected minute %d selected second %d", [selectedMinute intValue], [selectedSecond intValue]);
    if (nowMode == SETTING_MODE) {
        NSLog(@"move picker");
        [picker selectRow:[selectedMinute intValue] inComponent:0 animated:YES];
        [picker selectRow:[selectedSecond intValue] inComponent:1 animated:YES];

        
        stockMinute = [selectedMinute intValue];
        stockSecond = [selectedSecond intValue];

        storeNum = patternNum;
        
    }else if (nowMode == START_MODE){
        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", [selectedMinute intValue], [selectedSecond intValue]];
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:patternNum] forKey:@"currentPattern"];
    } else {
        
    }
}



-(void)pressStore:(id)sender{
    if (isTouchEnabeld) {
        NSNumber *currentPatternNum  = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentPattern"];
        
        if (storeNum == [currentPatternNum intValue] && isTimerRunning == YES) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"patternBucking", nil)
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            if (stockMinute == 0 && stockSecond == 0) {
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"selectedZero", nil)
                                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:stockMinute] forKey:[NSString stringWithFormat:@"pattern%dMinute",storeNum]];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:stockSecond] forKey:[NSString stringWithFormat:@"pattern%dSecond",storeNum]];
                
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"endStore", nil)
                                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                if (prevMode == START_MODE) {
                    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:storeNum] forKey:@"currentPattern"];
                }
            }
        }
    }
}

-(void)moveCenter:(float)delay  selectedView:(UIView*)view{
    view.frame = CGRectMake(320, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    
    [UIView animateWithDuration:0.4f
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"%f", view.frame.origin.x);
                     }];
}

-(void)moveOffScreen:(float)delay selectedView:(UIView*)view{
    [UIView animateWithDuration:0.4f
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.frame = CGRectMake(-320, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                        
                     }];
}

-(void)moveCenter:(float)delay moveToPosition:(float)position selectedView:(UIView*)view{
    view.frame = CGRectMake(320 + position, view.frame.origin.y, view.frame.size.width, view.frame.size.height);

    
    [UIView animateWithDuration:0.4f
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.frame = CGRectMake(position, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"%f", view.frame.origin.x);
                     }];
}

-(void)moveOffScreen:(float)delay moveToPosition:(float)position selectedView:(UIView*)view{
    [UIView animateWithDuration:0.4f
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.frame = CGRectMake(-320 + position, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

/**
 * ピッカーに表示する列数を返す
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

/**
 * ピッカーに表示する行数を返す
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return 60;
}

/**
 * 行のサイズを変更
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return 150;
            break;
            
        case 1: // 2列目
            return 150.0;
            break;
            
            
        default:
            return 0;
            break;
    }
}

/**
 * ピッカーに表示する値を返す
 */
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return [NSString stringWithFormat:@"%ld", (long)row];
            break;
            
        case 1: // 2列目
            return [NSString stringWithFormat:@"%ld", (long)row];
            break;
            
        default:
            return 0;
            break;
    }
}

/**
 * ピッカーの選択行が決まったとき
 */
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 1列目の選択された行数を取得
    stockMinute = [pickerView selectedRowInComponent:0];
    
    // 2列目の選択された行数を取得
    stockSecond = [pickerView selectedRowInComponent:1];
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >=7) {
         attString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    } else {
         attString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
   
    
    return attString;
    
}

-(void)setIsTouchEnabeld{
    isTouchEnabeld = YES;
}

@end
