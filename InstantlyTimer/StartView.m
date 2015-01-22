//
//  StartView.m
//  InstantlyTimer
//
//  Created by aiharakohei on 2014/02/19.
//  Copyright (c) 2014年 aiharakohei. All rights reserved.
//

#import "StartView.h"
#import "MainViewController.h"

@implementation StartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    self.backgroundColor = [UIColor colorWithRed:51 green:51 blue:51 alpha:1.0];

    MainViewController *viewcontroller =  (MainViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    

    
//    UIImage *settingImg = [UIImage imageNamed:@"setting.png"];  // ボタンにする画像を生成する
//    UIButton *settingBtn = [[UIButton alloc]
//                            initWithFrame:CGRectMake(200, 378, 78, 78)];  // ボタンのサイズを指定する
//    [settingBtn setBackgroundImage:settingImg forState:UIControlStateNormal];  // 画像をセットする
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [settingBtn setTitle:@"setting" forState:UIControlStateNormal];
    [settingBtn setFrame:CGRectMake(110, 254, 100, 78)];
    [settingBtn.titleLabel setFont:[UIFont systemFontOfSize:30]];

    // resumeBtnが押された時にhogeメソッドを呼び出す
    [settingBtn addTarget:viewcontroller
                   action:@selector(pressSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingBtn];
    
    
    NSNumber *patternNum = (NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPattern"];
    int num = [patternNum intValue];
    NSNumber *minute = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dMinute",num]];
    NSNumber *second = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dSecond",num]];

    
    timeLabel = [[UILabel alloc]init];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", [minute intValue], [second intValue]];
    timeLabel.frame =  CGRectMake(39, 87, 242, 115);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:90];
    timeLabel.font = font;
    [self addSubview:timeLabel];
    
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(void)pressPattern:(id)sender{
    UIButton *btn = (UIButton*)sender;
    int patternNum = (int)[btn tag];
    NSNumber *minute = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dMinute",patternNum]];
    NSNumber *second = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"pattern%dSecond",patternNum]];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", [minute intValue], [second intValue]];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:patternNum] forKey:@"currentPattern"];
    
}

@end
