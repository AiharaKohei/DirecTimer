//
//  SettingView.h
//  InstantlyTimer
//
//  Created by aiharakohei on 2014/02/19.
//  Copyright (c) 2014年 aiharakohei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger minute;
    NSInteger second;
    int patternNum;
}
@property UIView *prickerView;
@property UIButton *storeBtn;
@property UIButton *backBtn;
@end
