//
//  SettingView.m
//  InstantlyTimer
//
//  Created by aiharakohei on 2014/02/19.
//  Copyright (c) 2014年 aiharakohei. All rights reserved.
//

#import "SettingView.h"
#import "MainViewController.h"

@implementation SettingView

@synthesize prickerView;
@synthesize storeBtn;
@synthesize backBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    MainViewController *viewcontroller =  (MainViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    
    self.prickerView = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, 200)];
    
    [self addSubview:self.prickerView];
    // UIPickerのインスタンス化
    UIPickerView  *picker = [[UIPickerView alloc]init];
    // デリゲートを設定
    picker.delegate = self;
    
    // データソースを設定
    picker.dataSource = self;
    
    // 選択インジケータを表示
    picker.showsSelectionIndicator = YES;

    
//    [picker setBackgroundColor:[UIColor whiteColor]];
    
    // UIPickerのインスタンスをビューに追加
    
    [self.prickerView addSubview:picker];
    

    
    
    UIImage *storeImg = [UIImage imageNamed:@"store.png"];  // ボタンにする画像を生成する
    self.storeBtn = [[UIButton alloc]
                             initWithFrame:CGRectMake(320, 320, storeImg.size.width/2, storeImg.size.height/2)];  // ボタンのサイズを指定する
    [self.storeBtn setBackgroundImage:storeImg forState:UIControlStateNormal];  // 画像をセットする
    [self.storeBtn addTarget:self
                    action:@selector(pressStore:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.storeBtn];
    
    
    UIImage *backImg = [UIImage imageNamed:@"timer.png"];  // ボタンにする画像を生成する
    self.backBtn = [[UIButton alloc]
                          initWithFrame:CGRectMake(320, 440, backImg.size.width/2, backImg.size.height/2)];  // ボタンのサイズを指定する
    [self.backBtn setBackgroundImage:backImg forState:UIControlStateNormal];  // 画像をセットする
    [self.backBtn addTarget:viewcontroller
                 action:@selector(pressBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBtn];
    
    return self;

}


-(void)pressPattern:(id)sender{
    UIButton *btn = (UIButton*)sender;
    patternNum = (int)[btn tag];
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
            return 50.0;
            break;
            
        case 1: // 2列目
            return 50.0;
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
    minute = [pickerView selectedRowInComponent:0];
    
    // 2列目の選択された行数を取得
    second = [pickerView selectedRowInComponent:1];
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

@end
