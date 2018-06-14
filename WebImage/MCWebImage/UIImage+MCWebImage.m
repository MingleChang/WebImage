//
//  UIImage+MCWebImage.m
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "UIImage+MCWebImage.h"
#import "NSData+MCWebImage.h"
#import "MCImageCoder.h"

@implementation UIImage (MCWebImage)

+ (UIImage *)mc_imageWithData:(NSData *)data {
    if (!data || ![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    MCImageCoder *lCoder = [[MCImageCoder alloc] initWithData:data];
    UIImage *lImage = [lCoder image];
    return lImage;
//    UIImage *lImage = nil;
//    MCWebImageType lType = [data mc_imageType];
//    switch (lType) {
//        case MCWebImageTypeGIF:{
//            lImage = [UIImage mc_animatedGIFWithData:data];
//        }break;
//        default:{
//            lImage = [UIImage imageWithData:data];
//        }break;
//    }
//    return lImage;
}


#pragma mark - GIF
+ (UIImage *)mc_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            duration += [self mc_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

+ (float)mc_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
