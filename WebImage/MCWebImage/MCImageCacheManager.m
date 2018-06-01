//
//  MCImageCacheManager.m
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageCacheManager.h"
#import "MCWebImageConfigure.h"
#import "UIImage+MCWebImage.h"

@interface MCImageCacheManager ()

@property(nonatomic,strong)NSCache *imageCache;
@property(nonatomic,strong)NSString *localPath;
@end

@implementation MCImageCacheManager
+ (MCImageCacheManager *)manager {
    static MCImageCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MCImageCacheManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createImageLocalDirectory];
    }
    return self;
}
#pragma mark - Setter And Getter
-(NSCache *)imageCache{
    if (_imageCache) {
        return _imageCache;
    }
    _imageCache=[[NSCache alloc]init];
    return _imageCache;
}

-(NSString *)localPath{
    if (_localPath) {
        return _localPath;
    }
    _localPath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    _localPath=[_localPath stringByAppendingPathComponent:MCWebImageCacheDirName];
    return _localPath;
}
#pragma mark - Path
-(void)createImageLocalDirectory{
    BOOL isDirectory=NO;
    if (![[NSFileManager defaultManager]fileExistsAtPath:self.localPath isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:self.localPath withIntermediateDirectories:YES attributes:nil error:nil];
        return;
    }
    if (!isDirectory) {
        [[NSFileManager defaultManager]createDirectoryAtPath:self.localPath withIntermediateDirectories:YES attributes:nil error:nil];
        return;
    }
}
-(NSString *)imagePathWith:(NSString *)key{
    NSString *lPath=[self.localPath stringByAppendingPathComponent:key];
    return lPath;
}
#pragma mark - Cache
-(void)cacheImage:(UIImage *)image imageData:(NSData *)data withKey:(NSString *)key toDisk:(BOOL)toDisk{
    [self cacheToMemoryWithImage:image withKey:key];
    if (toDisk) {
        [self cacheToDiskWithImageData:data withKey:key];
    }
}
-(void)cacheToMemoryWithImage:(UIImage *)image withKey:(NSString *)key{
    [self.imageCache setObject:image forKey:key];
}
-(void)cacheToDiskWithImageData:(NSData *)data withKey:(NSString *)key{
    NSString *lPath=[self imagePathWith:key];
    [data writeToFile:lPath atomically:YES];
}

-(UIImage *)imageCacheWith:(NSString *)key type:(MCWebImageCacheType *)type {
    UIImage *lMemoryImage=[self imageMemoryCacheWith:key];
    if (lMemoryImage) {
        *type = MCWebImageCacheTypeMemory;
        return lMemoryImage;
    }
    UIImage *lDiskImage=[self imageDiskCacheWith:key];
    if (lDiskImage) {
        *type = MCWebImageCacheTypeDisk;
        [self cacheToMemoryWithImage:lDiskImage withKey:key];
        return lDiskImage;
    }
    *type = MCWebImageCacheTypeNone;
    return nil;
}
-(UIImage *)imageCacheWith:(NSString *)key{
    return [self imageCacheWith:key type:nil];
}
-(UIImage *)imageMemoryCacheWith:(NSString *)key{
    return [self.imageCache objectForKey:key];
}
-(UIImage *)imageDiskCacheWith:(NSString *)key{
    NSString *lPath=[self imagePathWith:key];
    NSData *lData=[NSData dataWithContentsOfFile:lPath];
    UIImage *lImage=[UIImage mc_imageWithData:lData];
    return lImage;
}
@end
