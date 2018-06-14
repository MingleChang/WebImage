//
//  MCImageGifDecoder.m
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageGifDecoder.h"
#import "MCImageFrame.h"

@implementation MCImageGifDecoder

+ (NSArray<MCImageFrame *> *)decodeData:(NSData *)data {
    if (data == nil) {
        return nil;
    }
    NSMutableArray *lArray = [NSMutableArray array];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    if (count == 1) {
        UIImage *lImage = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
        MCImageFrame *lFrame = [MCImageFrame imageFrameWithImage:lImage duration:0];
        [lArray addObject:lFrame];
    }else {
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            UIImage *lImage = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            NSTimeInterval lDuration = [self frameDurationAtIndex:i source:source];
            MCImageFrame *lFrame = [MCImageFrame imageFrameWithImage:lImage duration:lDuration];
            [lArray addObject:lFrame];
            CGImageRelease(image);
        }
    }
    CFRelease(source);
    return [lArray copy];
}

+ (NSTimeInterval)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp doubleValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp doubleValue];
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
