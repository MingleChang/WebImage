//
//  UIImageView+MCWebImage.m
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "UIImageView+MCWebImage.h"
#import "MCImageDownloadManager.h"
#import "MCImageCacheManager.h"
#import "MCImageDownloadTask.h"
#import "NSString+MCWebImage.h"
#import <objc/runtime.h>

@interface UIImageView (_MCWebImage)
@property (readwrite, nonatomic, strong,setter = mc_setImageTask:) MCImageDownloadTask *mc_imageTask;
@end
@implementation UIImageView (_MCWebImage)

-(MCImageDownloadTask *)mc_imageTask{
    return (MCImageDownloadTask *)objc_getAssociatedObject(self, @selector(mc_imageTask));
}

-(void)mc_setImageTask:(MCImageDownloadTask *)imageTask{
    objc_setAssociatedObject(self, @selector(mc_imageTask), imageTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIImageView (MCWebImage)
-(void)mc_cancelImageRequest{
    [self.mc_imageTask cancel];
}
-(void)mc_setImageWith:(NSString *)urlString {
    [self mc_setImageWith:urlString placeholder:nil];
}
-(void)mc_setImageWith:(NSString *)urlString placeholder:(UIImage *)placeholder {
    [self mc_setImageWith:urlString placeholder:placeholder options:0 progress:nil completed:nil];
}
-(void)mc_setImageWith:(NSString *)urlString placeholder:(UIImage *)placeholder options:(MCWebImageOptions)options progress:(MCWebImageProgressBlock)progressBlock completed:(MCWebImageResultBlock)completedBlock{
    [self mc_cancelImageRequest];
    NSString *lCacheKey=[urlString mc_md5];
    MCWebImageCacheType lCacheType = 0;
    UIImage *lCacheImage=[[MCImageCacheManager manager]imageCacheWith:lCacheKey type:&lCacheType];
    if (lCacheImage) {
        mc_dispatch_main_sync_safe(^{
            self.image=lCacheImage;
            if (completedBlock) {
                completedBlock(lCacheImage,nil,nil, lCacheType);
            }
        });
        return;
    }
    mc_dispatch_main_sync_safe(^{
        self.image=placeholder;
    });
    __weak __typeof(self)weakself = self;
    self.mc_imageTask=[[MCImageDownloadManager manager]downloadURLString:urlString progress:progressBlock complete:^(UIImage *image, NSData *data, NSError *error) {
        mc_dispatch_main_sync_safe(^{
            if (error || image==nil) {
                weakself.image=placeholder;
            }else{
                weakself.image=image;
                [[MCImageCacheManager manager]cacheImage:image imageData:data withKey:lCacheKey toDisk:YES];
            }
            if (completedBlock) {
                completedBlock(image,data,error, MCWebImageCacheTypeNone);
            }
        });
    }];
}
@end
