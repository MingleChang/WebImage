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
    if (frames.count == 0) {
        return nil;
    }else if (frames.count == 1) {
        MCImageFrame *lFrame = frames.firstObject;
        size_t width = CGImageGetWidth(lFrame.image.CGImage);
        size_t height = CGImageGetHeight(lFrame.image.CGImage);
        size_t stride = CGImageGetBytesPerRow(lFrame.image.CGImage);
        CGDataProviderRef lProviderRef = CGImageGetDataProvider(lFrame.image.CGImage);
        CFDataRef lDataRef = CGDataProviderCopyData(lProviderRef);
        NSData *lData = (__bridge NSData *)lDataRef;
        WebPData webPData;
        webPData.size = WebPEncodeLosslessRGB(lData.bytes, (int)width, (int)height, (int)stride, (uint8_t **)&webPData.bytes);
        NSData *result = [NSData dataWithBytes:webPData.bytes length:webPData.size];
        return result;
    }else {//还有问题
        WebPMux *mux = WebPMuxNew();
        for (int i = 0; i < frames.count; i++) {
            MCImageFrame *lFrame = [frames objectAtIndex:i];
            size_t width = CGImageGetWidth(lFrame.image.CGImage);
            size_t height = CGImageGetHeight(lFrame.image.CGImage);
            size_t stride = CGImageGetBytesPerRow(lFrame.image.CGImage);
            CGDataProviderRef lProviderRef = CGImageGetDataProvider(lFrame.image.CGImage);
            CFDataRef lDataRef = CGDataProviderCopyData(lProviderRef);
            NSData *lData = (__bridge NSData *)lDataRef;
            
            if (i == 0) {
                WebPMuxSetCanvasSize(mux, (int)width, (int)height);
                WebPMuxAnimParams lAnimparams = {0};
                lAnimparams.bgcolor = 0xFF000000;
                WebPMuxSetAnimationParams(mux, &lAnimparams);
            }
            WebPMuxFrameInfo lFrameInfo = {0};
            lFrameInfo.bitstream.size = WebPEncodeLosslessRGB(lData.bytes, (int)width, (int)height, (int)stride, (uint8_t **)&lFrameInfo.bitstream.bytes);
            lFrameInfo.x_offset = 0;
            lFrameInfo.y_offset = 0;
            lFrameInfo.duration = lFrame.duration * 1000;
            lFrameInfo.id = WEBP_CHUNK_ANMF;
            WebPMuxPushFrame(mux, &lFrameInfo, i);
        }
        WebPData webPData;
        WebPDataInit(&webPData);
        WebPMuxAssemble(mux, &webPData);
        NSData *result = [NSData dataWithBytes:webPData.bytes length:webPData.size];
        return result;
    }
    return nil;
}

@end
