//
//  MCWebImageConfigure.h
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#ifndef MCWebImageConfigure_h
#define MCWebImageConfigure_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MCWebImageType){
    MCWebImageTypeUnknown=0,
#pragma mark - Image
    MCWebImageTypePNG=100,
    MCWebImageTypeJPEG,
    MCWebImageTypeGIF,
    MCWebImageTypeTIFF,
    MCWebImageTypeWEBP,
};
typedef NS_ENUM(NSInteger, MCWebImageCacheType) {
    MCWebImageCacheTypeNone,
    MCWebImageCacheTypeDisk,
    MCWebImageCacheTypeMemory,
};
typedef NS_OPTIONS(NSUInteger, MCWebImageOptions) {
    MCWebImageOptionsUnknow=0,
};

typedef void (^MCWebImageProgressBlock)(int64_t bytes, int64_t totalBytes, int64_t totalBytesExpected);
typedef void (^MCWebImageCompleteBlock)(UIImage *image, NSData *data, NSError *error);
typedef void (^MCWebImageResultBlock)(UIImage *image, NSData *data, NSError *error, MCWebImageCacheType type);

FOUNDATION_EXTERN NSString *const MCWebImageCacheDirName;

#define mc_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define mc_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#endif
