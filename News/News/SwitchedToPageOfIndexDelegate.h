//
//  SwitchedToPageOfIndexDelegate.h
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SwitchedToPageDelegate <NSObject>

- (void) contentViewControllerDidSwitchToPageOfIndex: (int)index;

@end