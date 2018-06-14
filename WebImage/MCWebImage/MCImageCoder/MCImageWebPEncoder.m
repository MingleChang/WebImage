//
//  MCImageWebPEncoder.m
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageWebPEncoder.h"
#import "MCImageFrame.h"
#import <WebP/mux.h>
#import <WebP/encode.h>

@implementation MCImageWebPEncoder

+ (NSData *)encodeFrames:(NSArray<MCImageFrame *> *)frames {
    MCImageFrame *lFrame = frames.firstObject;
    size_t width = CGImageGetWidth(lFrame.image.CGImage);
    size_t height = CGImageGetHeight(lFrame.image.CGImage);
    size_t count = CGImageGetBytesPerRow(lFrame.image.CGImage);
    CGDataProviderRef lProviderRef = CGImageGetDataProvider(lFrame.image.CGImage);
    CFDataRef lDataRef = CGDataProviderCopyData(lProviderRef);
    NSData *lData = (__bridge NSData *)lDataRef;
    WebPData webPData;
    webPData.size = WebPEncodeLosslessRGB(lData.bytes, width, height, count, &webPData.bytes);
//    WebPMux *mux = WebPMuxNew();
//    if (WebPMuxSetCanvasSize(mux, width, height) != WEBP_MUX_OK) {
//        NSLog(@"WebPMuxSetCanvasSize error");
//    }
//    if (WebPMuxSetImage(mux, &webPData, 1) != WEBP_MUX_OK) {
//        NSLog(@"WebPMuxSetImage error");
//    }
//    ;
//    WebPData resultWebPData;
//    WebPMuxAssemble(mux, &resultWebPData);
    NSData *result = [NSData dataWithBytes:webPData.bytes length:webPData.size];
    return result;
}

@end
