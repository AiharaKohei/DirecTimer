//
//  AppliPromotionSDK
//
//  Copyright © CyberAgent, Inc. All Rights Reserved.
//

#import <UIKit/UIKit.h>

@interface AMoAdSDK : NSObject {
}

/*
 * Wallの表示.
 */
+ (UIViewController *) showAppliPromotionWall:(UIViewController *)owner;
+ (UIViewController *) showAppliPromotionWall:(UIViewController *)owner
                                  orientation:(UIInterfaceOrientation)orientation;
+ (UIViewController *) showAppliPromotionWall:(UIViewController *)owner onStatusArea:(BOOL)onStatusArea;
+ (UIViewController *) showAppliPromotionWall:(UIViewController *)owner
                                  orientation:(UIInterfaceOrientation)orientation
                                 onStatusArea:(BOOL)onStatusArea;


/*
 * Wallの表示が初めてかどうかのチェック.
 */
+ (BOOL)isFirstTimeInToday;

/*
 * UUIDの送信.
 */
+ (void)sendUUID;

/*
 * Wall誘導枠IDを送信し、Wall誘導枠画像を取得.
 */
+ (void)sendTriggerID:(UIViewController *)owner
			  trigger:(NSString *)TriggerID
			 callback:(SEL)callback;

/*
 * Wall誘導枠となっている、対象ボタンが押下時のWall表示。
 */
+ (void)pushTrigger:(UIViewController *)owner
		  TriggerID:(NSString *)triggerID;
+ (void)pushTrigger:(UIViewController *)owner
		orientation:(UIInterfaceOrientation)orientation
		  TriggerID:(NSString *)triggerID;
+ (void)pushTrigger:(UIViewController *)owner
		  TriggerID:(NSString *)triggerID
	   onStatusArea:(BOOL)onStatusArea;
+ (void)pushTrigger:(UIViewController *)owner
		orientation:(UIInterfaceOrientation)orientation
		  TriggerID:(NSString *)triggerID
	   onStatusArea:(BOOL)onStatusArea;

/*
 * Wall誘導枠となっている、対象ボタンが押下時のPopup表示。
 */
+ (void)popupDisp:(UIViewController *)owner
		TriggerID:(NSString *)triggerID
		 callback:(SEL)callback;
+ (void)popupDisp:(UIViewController *)owner
	  orientation:(UIInterfaceOrientation)orientation
		TriggerID:(NSString *)triggerID
		 callback:(SEL)callback;
+ (void)popupDisp:(UIViewController *)owner
		TriggerID:(NSString *)triggerID
	 onStatusArea:(BOOL)onStatusArea
		 callback:(SEL)callback;
+ (void)popupDisp:(UIViewController *)owner
	  orientation:(UIInterfaceOrientation)orientation
		TriggerID:(NSString *)triggerID
	 onStatusArea:(BOOL)onStatusArea
		 callback:(SEL)callback;

/*
 * Unity用Wall誘導枠のcallback用.
 */
+ (void)setTriggerDelegate:(id)delegate;
+ (void)popupTriggerDelegate:(id)delegate;

@end
