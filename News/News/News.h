//
//  News.h
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString* time; // Time string to be displayed
@property (strong, nonatomic) NSArray* imageURLs;

- (instancetype)initWithTitle: (NSString*)title
            andText: (NSString*)text
        andCategory: (NSString*)category
            andTime: (NSString*)time
          andImages: (NSArray*)images;

+ (instancetype)convertFromNewsDictionaryToNewsObject: (NSDictionary*)dict;

@end
