//
//  categoryButton.m
//  News
//
//  Created by Zhixing Yang on 2015.03.06.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import "CategoryButton.h"

@implementation CategoryButton

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])){
        [self setupView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

# pragma mark - main

- (void)setupView{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.borderWidth = 0;
    self.titleLabel.font = [UIFont systemFontOfSize: 20];
    self.titleLabel.contentMode = UIViewContentModeCenter;
    self.backgroundColor = [UIColor colorFromRGB: 0x446cb3];
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected: selected];
    if (selected) {
        [self setTitleColor:[UIColor colorFromRGB: 0x446cb3] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
    } else{
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorFromRGB: 0x446cb3];
    }
}

@end
