//
//  HttpClient.h
//  News
//
//  Created by Zhixing Yang on 2015.03.05.
//  Copyright (c) 2015 Shaohuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "HttpRequestConsts.h"
#import <AFHTTPRequestOperation.h>
#import <AFHTTPSessionManager.h>
#import <AFHTTPRequestOperationManager.h>
#import "HTTPRequestManager.h"

@class HttpClient;

@interface HttpClient : NSObject
+ (HttpClient *) sharedInstance;

#pragma mark - Authentication

- (void)getCategoriesSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSInteger statusCode, NSError *error))failure;

- (void)getNewsWithOffset: (NSNumber*) offset
             withCategory: (NSString*) category
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSInteger statusCode, NSError *error))failure;

@end
