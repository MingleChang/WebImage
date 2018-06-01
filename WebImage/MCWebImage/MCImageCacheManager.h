//
//  MCImageCacheManager.h
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCWebImageConfigure.h"

@interface MCImageCacheManager : NSObject

+(MCImageCacheManager *)manager;
-(void)cacheImage:(UIImage *)image imageData:(NSData *)data withKey:(NSString *)key toDisk:(BOOL)toDisk;
-(UIImage *)imageCacheWith:(NSString *)key type:(MCWebImageCacheType *)type;
-(UIImage *)imageCacheWith:(NSString *)key;

@end
