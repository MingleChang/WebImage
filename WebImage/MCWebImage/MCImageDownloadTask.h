//
//  MCImageDownloadTask.h
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCWebImageConfigure.h"

@interface MCImageDownloadTask : NSObject

@property (nonatomic, strong, readonly)NSURLSessionTask *sessionTask;
@property (nonatomic, assign, readonly)NSUInteger taskIdentifier;

@property (nonatomic, copy)MCWebImageProgressBlock downloadProgressBlock;
@property (nonatomic, copy)MCWebImageCompleteBlock completeBlock;

- (instancetype)initWithSessionTask:(NSURLSessionTask *)task;
+ (MCImageDownloadTask *)taskWithSessionTask:(NSURLSessionTask *)task;

- (void)suspend;
- (void)resume;
- (void)cancel;

- (void)didReceiveData:(NSData *)data;
- (void)didCompleteWithError:(NSError *)error;

@end
