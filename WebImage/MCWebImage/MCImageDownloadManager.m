//
//  MCImageDownloadManager.m
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageDownloadManager.h"
#import "MCImageDownloadTask.h"

@interface MCImageDownloadManager ()<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong)NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong)NSURLSession *session;
@property (nonatomic, strong)NSOperationQueue *operationQueue;

@property(nonatomic,strong)NSMutableDictionary *taskInfoByIdentifier;

@property(nonatomic,strong)dispatch_semaphore_t taskInfoSemaphore;

@end

@implementation MCImageDownloadManager

+ (MCImageDownloadManager *)manager {
    static MCImageDownloadManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MCImageDownloadManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.taskInfoByIdentifier = [NSMutableDictionary dictionary];
        self.taskInfoSemaphore = dispatch_semaphore_create(1);
        
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
    }
    return self;
}
#pragma mark - Public
- (MCImageDownloadTask *)downloadURLString:(NSString *)urlString progress:(MCWebImageProgressBlock)progress complete:(MCWebImageCompleteBlock)complete {
    NSURL *lURL = [NSURL URLWithString:urlString];
    return [self downloadURL:lURL progress:progress complete:complete];
}
- (MCImageDownloadTask *)downloadURL:(NSURL *)url progress:(MCWebImageProgressBlock)progress complete:(MCWebImageCompleteBlock)complete {
    NSURLRequest *lRequest = [NSURLRequest requestWithURL:url];
    return [self downloadRequest:lRequest progress:progress complete:complete];
}
- (MCImageDownloadTask *)downloadRequest:(NSURLRequest *)request progress:(MCWebImageProgressBlock)progress complete:(MCWebImageCompleteBlock)complete {
    NSURLSessionTask *lSessionTask = [self.session dataTaskWithRequest:request];
    MCImageDownloadTask *lTask = [MCImageDownloadTask taskWithSessionTask:lSessionTask];
    lTask.downloadProgressBlock = progress;
    lTask.completeBlock = complete;
    [self addTask:lTask];
    [lTask resume];
    return lTask;
}
#pragma mark - Private
#pragma mark - Task Manager
-(MCImageDownloadTask *)findTaskByTaskIdentifier:(NSUInteger )taskIdentifier{
    MCImageDownloadTask *task=[self.taskInfoByIdentifier objectForKey:@(taskIdentifier)];
    return task;
}
-(MCImageDownloadTask *)findTaskBySessionTask:(NSURLSessionTask *)sessionTask{
    MCImageDownloadTask *task=[self findTaskByTaskIdentifier:sessionTask.taskIdentifier];
    return task;
}
- (void)addTask:(MCImageDownloadTask *)task {
    dispatch_semaphore_wait(self.taskInfoSemaphore, DISPATCH_TIME_FOREVER);
    [self.taskInfoByIdentifier setObject:task forKey:@(task.taskIdentifier)];
    dispatch_semaphore_signal(self.taskInfoSemaphore);
}
- (void)addTaskWithSessionTask:(NSURLSessionTask *)sessionTask {
    MCImageDownloadTask *lTask = [MCImageDownloadTask taskWithSessionTask:sessionTask];
    [self addTask:lTask];
}
- (void)removeTask:(MCImageDownloadTask *)task {
    [self removeTaskByTaskIdentifier:task.taskIdentifier];
}
-(void)removeTaskBySessionTask:(NSURLSessionTask *)sessionTask{
    [self removeTaskByTaskIdentifier:sessionTask.taskIdentifier];
}
-(void)removeTaskByTaskIdentifier:(NSUInteger )taskIdentifier{
    dispatch_semaphore_wait(self.taskInfoSemaphore, DISPATCH_TIME_FOREVER);
    [self.taskInfoByIdentifier removeObjectForKey:@(taskIdentifier)];
    dispatch_semaphore_signal(self.taskInfoSemaphore);
}
-(void)removeAllTask{
    dispatch_semaphore_wait(self.taskInfoSemaphore, DISPATCH_TIME_FOREVER);
    [self.taskInfoByIdentifier removeAllObjects];
    dispatch_semaphore_signal(self.taskInfoSemaphore);
}
#pragma mark - Setter And Getter


#pragma mark - Delegate
#pragma mark - NSURLSession Delegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{

}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if (completionHandler) {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}

#pragma mark - NSURLSessionTask Delegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    if (completionHandler) {
        completionHandler(request);
    }
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if (completionHandler) {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    MCImageDownloadTask *lTask = [self findTaskBySessionTask:task];
    [lTask didCompleteWithError:error];
}

#pragma mark - NSURLSessionData Delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    if(completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    MCImageDownloadTask *lTask = [self findTaskBySessionTask:dataTask];
    [lTask didReceiveData:data];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
    if (completionHandler) {
        completionHandler(proposedResponse);
    }
}
@end
