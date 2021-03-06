//
//  HttpClient.m
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient


+ (HttpClient *)sharedInstance{
    
    static dispatch_once_t once;
    static HttpClient *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    return self;
}

#pragma mark - Authentication

- (void)getCategoriesSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSInteger statusCode, NSError *error))failure{
    
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[REQUEST_DOMAIN stringByAppendingString:GET_CATEGORIES] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(operation.response.statusCode, error);
    }];
}

- (void)getNewsWithOffset: (NSNumber*) offset
             withCategory: (NSString*) category
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSInteger statusCode, NSError *error))failure{
    
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSString* requestURL;
    
    if (category != nil) {
        requestURL = [NSString stringWithFormat:@"%@%@/%@", REQUEST_DOMAIN, GET_NEWS, [category lowercaseString]];
    }
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    if (offset != nil) {
        [parameters setObject: offset forKey:@"offset"];
    } else{
        parameters = nil;
    }
    
    [manager GET:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(operation.response.statusCode, error);
        
    }];
}

@end
