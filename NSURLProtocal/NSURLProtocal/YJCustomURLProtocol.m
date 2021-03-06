//
//  YJCustomURLProtocol.m
//  NSURLProtocal
//
//  Created by yj on 17/3/22.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJCustomURLProtocol.h"
#import <SDWebImageManager.h>
static NSString *const KYJURLProtocolHandlerKey = @"URLProtocolHandlerKey";
@interface YJCustomURLProtocol ()<NSURLConnectionDataDelegate>

@property (strong,nonatomic) NSURLConnection *connection;

@end

@implementation YJCustomURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    
    NSLog(@"---requestURL = %@",request.URL.absoluteString);
    
    NSLog(@"---requestHost = %@",request.URL.host);
    
    //只处理http和https请求
    NSString *scheme = [[request URL] host];
    
    if ([scheme hasPrefix:@"images"]) {
        
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:KYJURLProtocolHandlerKey inRequest:request]) {
            
            return NO;
        }
        
        return YES;
        
    }
    
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest *)request {

    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {

    return [super requestIsCacheEquivalent:a toRequest:b];
}


- (void)startLoading {

  
    /* 如果想直接返回缓存的结果，构建一个NSURLResponse对象
     if (cachedResponse) {
     
     NSData *data = cachedResponse.data; //缓存的数据
     NSString *mimeType = cachedResponse.mimeType;
     NSString *encoding = cachedResponse.encoding;
     
     NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
     MIMEType:mimeType
     expectedContentLength:data.length
     textEncodingName:encoding];
     
     [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
     [self.client URLProtocol:self didLoadData:data];
     [self.client URLProtocolDidFinishLoading:self];
     */
    
    [[SDWebImageManager sharedManager] loadImageWithURL:self.request.URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        
        
        
        if (image) {
            
            NSLog(@"下载图片成功");
            
            NSString *mimeType = @"image/jpeg";
            NSString *contentType = [mimeType stringByAppendingString:@";charset=UTF-8"];
            NSMutableDictionary *header = [NSMutableDictionary dictionary];
            header[@"Content-Type"] = contentType;
            header[@"Content-Length"] = [NSString stringWithFormat:@"%lu", (unsigned long) UIImageJPEGRepresentation(image, 1.0).length];
            
            NSHTTPURLResponse *httpResponse = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"1.1" headerFields:header];
            
            [self.client URLProtocol:self didReceiveResponse:httpResponse cacheStoragePolicy:NSURLCacheStorageAllowed];
            
            [self.client URLProtocol:self didLoadData:UIImageJPEGRepresentation(image, 1.0)];
            
            [self.client URLProtocolDidFinishLoading:self];

            
        }else{
        
            NSLog(@"下载失败");
        }
        
        
    }];
    
    
    
    NSMutableURLRequest *mubleRequest = [[self request] mutableCopy];
     NSLog(@"---startLoad = %@",mubleRequest.URL.host);
    //做好标记
    [NSURLProtocol setProperty:@(YES) forKey:KYJURLProtocolHandlerKey inRequest:mubleRequest];
    
//    self.connection = [NSURLConnection connectionWithRequest:mubleRequest delegate:self];
    
//    [self.connection start];
}

- (void)stopLoading {

    [self.connection cancel];
}
#pragma mark - NSURLConnectionDelegate
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.client URLProtocol:self didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}
@end
