//
//  MCImageWebpDecoder.m
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageWebPDecoder.h"
#import <WebP/demux.h>
#import "MCImageFrame.h"

static void FreeImageData(void *info, const void *data, size_t size) {
    free((void *)data);
}

@implementation MCImageWebPDecoder

+ (NSArray<MCImageFrame *> *)decodeData:(NSData *)data {
    WebPData webData;
    WebPDataInit(&webData);
    webData.bytes = data.bytes;
    webData.size = data.length;
    WebPDemuxer *demuxer = WebPDemux(&webData);
    if (!demuxer) {
        return nil;
    }
    NSMutableArray *lArray = [NSMutableArray array];
    uint32_t width = WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_WIDTH);
    uint32_t height = WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_HEIGHT);
    uint32_t loopCount = WebPDemuxGetI(demuxer, WEBP_FF_LOOP_COUNT);
    uint32_t frameCount = WebPDemuxGetI(demuxer, WEBP_FF_FRAME_COUNT);
    uint32_t bgColor = WebPDemuxGetI(demuxer, WEBP_FF_BACKGROUND_COLOR);
    uint32_t flags = WebPDemuxGetI(demuxer, WEBP_FF_FORMAT_FLAGS);
    if (width < 1 || height < 1 || frameCount == 0) {
        WebPDemuxDelete(demuxer);
        return nil;
    }
    CGBitmapInfo bitmapInfo;
    if (!(flags & ALPHA_FLAG)) {
        bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipLast;
    } else {
        bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    }
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
    if (context == nil) {
        WebPDemuxDelete(demuxer);
        return nil;
    }
    if (!(flags & ANIMATION_FLAG)) {
        UIImage *lImage = [self singleImageWithWebPData:webData];
        if (lImage) {
            MCImageFrame *lFrame = [MCImageFrame imageFrameWithImage:lImage duration:0];
            [lArray addObject:lFrame];
        }
    }else {
        WebPIterator iter;
        if (WebPDemuxGetFrame(demuxer, 1, &iter)) {
            do {
                UIImage *lImage = [self imageWithContext:context iterator:iter];
                MCImageFrame *lFrame = [MCImageFrame imageFrameWithImage:lImage duration:iter.duration / 1000.0];
                [lArray addObject:lFrame];
            } while (WebPDemuxNextFrame(&iter));
        }
    }
    
    return [lArray copy];
}

+ (UIImage *)imageWithContext:(CGContextRef)context iterator:(WebPIterator)iter {
    UIImage *lImage = [self singleImageWithWebPData:iter.fragment];
    if (lImage == nil) {
        return nil;
    }
    size_t width = CGBitmapContextGetWidth(context);
    size_t height = CGBitmapContextGetHeight(context);
    CGFloat x = iter.x_offset;
    CGFloat y = height - iter.height - iter.y_offset;
    CGRect lImageRect = CGRectMake(x, y, iter.width, iter.height);
    BOOL shouldBlend = (iter.blend_method == WEBP_MUX_BLEND);
    if (!shouldBlend) {
        CGContextClearRect(context, lImageRect);
    }
    CGContextDrawImage(context, lImageRect, lImage.CGImage);
    CGImageRef lImageRef = CGBitmapContextCreateImage(context);
    lImage = [UIImage imageWithCGImage:lImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(lImageRef);
    if (iter.dispose_method == WEBP_MUX_DISPOSE_BACKGROUND) {
        CGContextClearRect(context, lImageRect);
    }
    return lImage;
}

+ (UIImage *)singleImageWithWebPData:(WebPData)data {
    WebPDecoderConfig config;
    if (!WebPInitDecoderConfig(&config)) {
        return nil;
    }
    
    if (WebPGetFeatures(data.bytes, data.size, &config.input) != VP8_STATUS_OK) {
        return nil;
    }
    
    config.output.colorspace = config.input.has_alpha ? MODE_rgbA : MODE_RGB;
    config.options.use_threads = 1;
    
    // Decode the WebP image data into a RGBA value array.
    if (WebPDecode(data.bytes, data.size, &config) != VP8_STATUS_OK) {
        return nil;
    }
    
    int width = config.input.width;
    int height = config.input.height;
    if (config.options.use_scaling) {
        width = config.options.scaled_width;
        height = config.options.scaled_height;
    }
    
    // Construct a UIImage from the decoded RGBA value array.
    CGDataProviderRef provider =
    CGDataProviderCreateWithData(NULL, config.output.u.RGBA.rgba, config.output.u.RGBA.size, FreeImageData);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = config.input.has_alpha ? kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast : 0;
    size_t components = config.input.has_alpha ? 4 : 3;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, 8, components * 8, components * width, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return image;
}


@end
