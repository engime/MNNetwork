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
//@property (nonatomic, strong) NSArray *trustedCerArr;
//@property (nonatomic, strong) NSURLSession *session;
@end

@implementation MNNetWork

static NSString * const FORM_FLE_INPUT = @"file";

+ (void)POST:(NSURL *)url params:(NSString *)params completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{

    
    // 创建请求
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
    
    
    // 创建请求
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


+ (void)POSTWITHIMAGE: (NSString *)url postParems: (NSMutableDictionary *)postParems picFilePath: (NSString *)picFilePath picFileName: (NSString *)picFileName completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
    
    NSLog(@"%@", picFilePath);
    NSLog(@"%@", picFileName);
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath){
        
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSLog(@"dataTaskWithRequest");
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:completionHandler];
    
    [task resume];
    
}

+ (void)POSTWITHIMAGES: (NSString * _Nonnull)url postParems: (NSMutableDictionary * _Nonnull)postParems images: (NSMutableDictionary * _Nonnull)images completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {

    
    NSString *hyphens = @"--";
    NSString *boundary = @"AaB03x";
    NSString *end = @"\r\n";
    
    NSMutableData *myRequestData1 = [NSMutableData data];
    
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //添加其他参数
    for(int i = 0;i < [keys count];i ++)
    {
        
        NSMutableString *body = [[NSMutableString alloc]init];
        [body appendString:hyphens];
        [body appendString:boundary];
        [body appendString:end];
        //得到当前key
        NSString *key = [keys objectAtIndex:i];
        //添加字段名称
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"%@%@",key,end,end];
        
        //添加字段的值
        [body appendFormat:@"%@",[postParems objectForKey:key]];
        [body appendString:end];
        [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    keys= [images allKeys];
    //遍历数组，添加多张图片
    for(int i = 0;i < [keys count];i ++) {
    
        NSString *key=[keys objectAtIndex:i];
        
        UIImage *image=[UIImage imageWithContentsOfFile:[images valueForKey:key]];
        NSLog(@"image:%@", [images valueForKey:key]);
        
        NSData *data = UIImagePNGRepresentation(image);
    
        //所有字段的拼接都不能缺少，要保证格式正确
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *fileTitle = [[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端用file接收
        [fileTitle appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image%d.png\"%@", FORM_FLE_INPUT, i, end];
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:image/png%@%@",end,end]];
        
        
        [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:data];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"myRequestData1:%@", [[NSString alloc]initWithData:myRequestData1 encoding:NSUTF8StringEncoding]);
    
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //http method
    [request setHTTPMethod:@"POST"];
    //设置HTTPHeader中Content-Type的值
    NSString *content = [[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData1 length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //设置http body
    [request setHTTPBody:myRequestData1];
    
    
    NSLog(@"dataTaskWithRequest");
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:completionHandler];
    
    [task resume];
}

+ (void)POSTWITHVOICE: (NSString *)url completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
//    if(picFilePath){
    
        NSString *tempDir = NSTemporaryDirectory ();
        NSString *soundFilePath = [tempDir stringByAppendingString: @"sound.aac"];
    
//        NSString*filePath = [[NSBundlemainBundle] pathForResource:@"Test" ofType:@"mp3"];
        data = [NSData dataWithContentsOfFile:soundFilePath];
        
//        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
//        //判断图片是不是png格式的文件
//        if (UIImagePNGRepresentation(image)) {
//            //返回为png图像。
//            data = UIImagePNGRepresentation(image);
//        }else {
//            //返回为JPEG图像。
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }
//    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
//    NSArray *keys= [postParems allKeys];
//    
//    //遍历keys
//    for(int i=0;i<[keys count];i++)
//    {
//        //得到当前key
//        NSString *key=[keys objectAtIndex:i];
//        
//        //添加分界线，换行
//        [body appendFormat:@"%@\r\n",MPboundary];
//        //添加字段名称，换2行
//        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//        //添加字段的值
//        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
//        
//        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
//    }
    
//    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT, @"sound.aac"];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: audio/aac\r\n\r\n"];
//    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
//    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSLog(@"dataTaskWithRequest");
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:completionHandler];
    
    [task resume];
    
}

@end
