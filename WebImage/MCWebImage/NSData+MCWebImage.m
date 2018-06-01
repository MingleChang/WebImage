//
//  NSData+MCWebImage.m
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "NSData+MCWebImage.h"

@implementation NSData (MCWebImage)
- (BOOL)mc_isImagePNG {
    uint8_t c;
    [self getBytes:&c length:1];
    if (c == 0x89) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)mc_isImageJPEG{
    uint8_t c;
    [self getBytes:&c length:1];
    if (c == 0xFF) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)mc_isImageGIF{
    uint8_t c;
    [self getBytes:&c length:1];
    if (c == 0x47) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)mc_isImageTIFF{
    uint8_t c;
    [self getBytes:&c length:1];
    if (c == 0x49 || c == 0x4D) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)mc_isImageWEBP{
    if ([self length] < 12) {
        return NO;
    }
    
    NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
    if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
        return YES;
    }else{
        return NO;
    }
}
- (MCWebImageType)mc_imageType {
    if ([self mc_isImagePNG]) {
        return MCWebImageTypePNG;
    }
    if ([self mc_isImageJPEG]) {
        return MCWebImageTypeJPEG;
    }
    if ([self mc_isImageGIF]) {
        return MCWebImageTypeGIF;
    }
    if ([self mc_isImageTIFF]) {
        return MCWebImageTypeTIFF;
    }
    if ([self mc_isImageWEBP]) {
        return MCWebImageTypeWEBP;
    }
    return MCWebImageTypeUnknown;
    
}

@end
