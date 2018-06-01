//
//  MCImageDownloadManager.h
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCImageDownloadTask.h"

@interface MCImageDownloadManager : NSObject

+ (MCImageDownloadManager *)manager;
- (MCImageDownloadTask *)downloadURLString:(NSString *)urlString progress:(MCWebImageProgressBlock)progress complete:(MCWebImageCompleteBlock)complete;
- (MCImageDownloadTask *)downloadURL:(NSURL *)url progress:(MCWebImageProgressBlock)progress complete:(MCWebImageCompleteBlock)complete;
- (MCImageDownloadTask *)downloadRequest:(NSURLRequest *)request progress:(MCWebImageProgressBlock)progress complete:(MCWebImageCompleteBlock)complete;

@end
