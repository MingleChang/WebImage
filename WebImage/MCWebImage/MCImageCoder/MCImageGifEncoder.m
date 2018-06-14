//
//  MCImageGifEncoder.m
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageGifEncoder.h"
#import "MCImageFrame.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation MCImageGifEncoder

+ (NSData *)encodeFrames:(NSArray<MCImageFrame *> *)frames {
    if (frames.count == 0) {
        return nil;
    }
    NSMutableData *lImageData = [NSMutableData data];
    CFStringRef lImageUTType = kUTTypeGIF;
    CGImageDestinationRef lDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)lImageData, lImageUTType, frames.count, NULL);
    if (!lDestination) {
        return nil;
    }
    for (MCImageFrame *lFrame in frames) {
        NSDictionary *lFrameProperties = @{(__bridge_transfer NSString *)kCGImagePropertyGIFDictionary : @{(__bridge_transfer NSString *)kCGImagePropertyGIFDelayTime : @(lFrame.duration)}};
        CGImageDestinationAddImage(lDestination, lFrame.image.CGImage, (__bridge CFDictionaryRef)lFrameProperties);
    }
    if (CGImageDestinationFinalize(lDestination) == NO) {
        lImageData = nil;
    }
    CFRelease(lDestination);
    return [lImageData copy];
}

@end
