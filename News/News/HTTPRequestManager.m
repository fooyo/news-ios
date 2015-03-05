//
//  HTTPRequestManager.m
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import "HTTPRequestManager.h"

@implementation HTTPRequestManager

+ (instancetype)manager{
    NSURL *url = [NSURL URLWithString:REQUEST_DOMAIN];
    return [[self alloc] initWithBaseURL:url];
}

- (id) initWithBaseURL:(NSURL *)url{
    
    self = [super initWithBaseURL:url];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    return self;
}
@end
