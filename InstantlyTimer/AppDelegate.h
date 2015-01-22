//
//  AppDelegate.h
//  InstantlyTimer
//
//  Created by aiharakohei on 2014/02/18.
//  Copyright (c) 2014年 aiharakohei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SETTING_MODE 0
#define START_MODE 1
#define TIMER_MODE 2

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSDate *prevRunDate;
}

@property (strong, nonatomic) UIWindow *window;

@end
