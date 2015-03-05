//
//  News.m
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import "News.h"

@implementation News

- (id)initWithTitle: (NSString*)title
            andText: (NSString*)text
        andCategory: (NSString*)category
            andTime: (NSString*)time
          andImages: (NSArray*)images{
    
    self = [super init];
    if (self) {
        self.title = title;
        self.text = text;
        self.category = category;
        self.time = time;
        self.imageURLs = images;
    }
    return self;
}

+ (instancetype)convertFromNewsDictionaryToNewsObject: (NSDictionary*)dict{
    News* news = [[News alloc] initWithTitle:[dict objectForKey:@"title"]
                                     andText:[dict objectForKey:@"text"]
                                 andCategory:[dict objectForKey:@"category"]
                                     andTime:[dict objectForKey:@"time"]
                                   andImages:[dict objectForKey:@"images"]];
    return news;
}

@end
