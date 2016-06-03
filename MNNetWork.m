//
//  MNNetWork.m
//  Neighbors
//
//  Created by Wu Hengmin on 15/12/3.
//  Copyright © 2015年 Wu Hengmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNNetWork.h"

@interface MNNetWork()

@end

@implementation MNNetWork

static NSString * const FORM_FLE_INPUT = @"file";

+ (void)POST:(NSURL *)url params:(NSString *)params completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    if (params) {
        NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:completionHandler];
    [task resume];
}

+ (void)GET:(NSURL *)url params:(NSString *)params completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    if (params) {
        NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
    }
    
    request.URL = url;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:completionHandler];
    [task resume];
}


@end
