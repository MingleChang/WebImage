//
//  MCImageDownloadTask.m
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageDownloadTask.h"
#import "UIImage+MCWebImage.h"

@interface MCImageDownloadTask ()

@property (nonatomic, strong, readwrite)NSURLSessionTask *sessionTask;
@property (nonatomic, strong, readwrite)NSMutableData *data;

@end

@implementation MCImageDownloadTask

- (instancetype)initWithSessionTask:(NSURLSessionTask *)task {
    self = [super init];
    if (self) {
        self.sessionTask = task;
    }
    return self;
}
+ (MCImageDownloadTask *)taskWithSessionTask:(NSURLSessionTask *)task {
    MCImageDownloadTask *lTask = [[MCImageDownloadTask alloc] initWithSessionTask:task];
    return lTask;
}

#pragma mark - Public
- (void)suspend {
    [self.sessionTask suspend];
}
- (void)resume {
    [self.sessionTask resume];
}
- (void)cancel {
    [self.sessionTask cancel];
}
- (void)didReceiveData:(NSData *)data {
    [self.data appendData:data];
    if (self.downloadProgressBlock) {
        self.downloadProgressBlock(data.length, self.sessionTask.countOfBytesReceived, self.sessionTask.countOfBytesExpectedToReceive);
    }
}
- (void)didCompleteWithError:(NSError *)error {
    NSError *lError = error;
    UIImage *lImage = nil;
    if (!lError) {
        lImage = [UIImage mc_imageWithData:self.data];
    }
    if (self.completeBlock) {
        self.completeBlock(lImage, self.data, lError);
    }
}
#pragma mark - Private
#pragma mark - Setter And Getter
- (NSUInteger)taskIdentifier {
    return self.sessionTask.taskIdentifier;
}
- (NSMutableData *)data {
    if (_data) {
        return _data;
    }
    _data = [NSMutableData data];
    return _data;
}
@end
