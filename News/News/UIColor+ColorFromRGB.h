//
//  UIColor+ColorFromRGB.h
//  News
//
//  Created by Zhixing Yang on 2015.03.06.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorFromRGB)

+ (UIColor*) colorFromRGB: (int)RGBValue;

- (NSString *)hexStringFromColor;

- (NSString*) getDisplayStringFromColor;

@end
