//
//  MNNetWork.h
//  Neighbors
//
//  Created by Wu Hengmin on 15/12/3.
//  Copyright © 2015年 Wu Hengmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNNetWork : NSObject



+ (void)POST:(NSURL * _Nonnull)url params:(NSString * _Nonnull)params completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+ (void)GET:(NSURL * _Nonnull)url params:(NSString * _Nonnull)params completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+ (void)POSTWITHIMAGE: (NSString * _Nonnull)url postParems: (NSMutableDictionary * _Nonnull)postParems picFilePath: (NSString * _Nonnull)picFilePath picFileName: (NSString * _Nonnull)picFileName completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+ (void)POSTWITHIMAGES: (NSString * _Nonnull)url postParems: (NSMutableDictionary * _Nonnull)postParems images: (NSMutableDictionary * _Nonnull)images completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+ (void)POSTWITHVOICE: (NSString * _Nonnull)url completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

@end
