//
//  UIViewController+ScreenSize.h
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ScreenSize)

- (CGFloat) getScreenWidth;
- (CGFloat) getScreenHeight;
- (CGSize) getScreenSize;

- (BOOL)isIPhone4;
- (BOOL)isIPhone5;
- (BOOL)isIPhone6;
- (BOOL)isIphone6Plus;
- (BOOL)isIPad;

- (BOOL)isDeviceOrientationLandscape;
- (BOOL)isDeviceOrientationPortrait;

@end
