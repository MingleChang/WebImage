//
//  MCImageDefaultEncoder.m
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageDefaultEncoder.h"
#import "MCImageFrame.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation MCImageDefaultEncoder

+ (NSData *)encodeFrames:(NSArray<MCImageFrame *> *)frames {
    if (frames.count == 0) {
        return nil;
    }
    NSMutableData *lImageData = [NSMutableData data];
    UIImage *lImage = frames.firstObject.image;
    CFStringRef lImageUTType = kUTTypeJPEG;
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(lImage.CGImage);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    if (hasAlpha) {
        lImageUTType = kUTTypePNG;
    }
    CGImageDestinationRef lDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)lImageData, lImageUTType, 1, NULL);
    if (!lDestination) {
        return nil;
    }
    CGImageDestinationAddImage(lDestination, lImage.CGImage, NULL);
    if (CGImageDestinationFinalize(lDestination) == NO) {
        lImageData = nil;
    }
    CFRelease(lDestination);
    return [lImageData copy];
}

@end
