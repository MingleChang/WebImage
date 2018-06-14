//
//  MCImageCoder.m
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageCoder.h"
#import "NSData+MCWebImage.h"
#import "MCImageDefaultDecoder.h"
#import "MCImageGifDecoder.h"
#import "MCImageWebpDecoder.h"
#import "MCImageFrame.h"
#import "MCImageDefaultEncoder.h"
#import "MCImageGifEncoder.h"
#import "MCImageWebPEncoder.h"

@implementation MCImageCoder

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        [self decodeData:data];
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        [self decodeImage:image];
    }
    return self;
}
#pragma mark - Public
- (UIImage *)image {
    if (self.frameCount == 0) {
        return nil;
    }else if (self.frameCount == 1) {
        return self.frames.firstObject.image;
    }else {
        NSArray *lAnimationImages = [self.frames mutableArrayValueForKey:@"image"];
        NSTimeInterval lDuration = [[self.frames valueForKeyPath:@"@sum.duration"] doubleValue];
        UIImage *lImage = [UIImage animatedImageWithImages:lAnimationImages duration:lDuration];
        return lImage;
    }
}
- (NSData *)dataWithType:(MCWebImageType)type {
    NSData *lData = nil;
    switch (type) {
        case MCWebImageTypeGIF:{
            lData = [MCImageGifEncoder encodeFrames:self.frames];
        }break;
        case MCWebImageTypeWEBP:{
            lData = [MCImageWebPEncoder encodeFrames:self.frames];
        }default:{
            lData = [MCImageDefaultEncoder encodeFrames:self.frames];
        }break;
    }
    return lData;
}
#pragma mark - Private
#pragma mark - Decode
- (void)decodeImage:(UIImage *)image {
    if (image == nil) {
        return;
    }else if(image.images.count == 0) {
        MCImageFrame *lFrame = [MCImageFrame imageFrameWithImage:image duration:0];
        self.frames = @[lFrame];
    }else {
        __block NSMutableArray *lFrames = [NSMutableArray array];
        NSTimeInterval lAvgDuration = image.duration / image.images.count;
        if (lAvgDuration == 0) {
            lAvgDuration = 0.1;
        }
        [image.images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MCImageFrame *lFrame = [MCImageFrame imageFrameWithImage:image duration:lAvgDuration];
            [lFrames addObject:lFrame];
        }];
        self.frames = lFrames;
    }
}
- (void)decodeData:(NSData *)data {
    MCWebImageType lType = [data mc_imageType];
    switch (lType) {
        case MCWebImageTypeGIF:{
            [self decodeGifImageData:data];
        }break;
        case MCWebImageTypeWEBP:{
            [self decodeWebPImageData:data];
        }break;
        default:{
            [self decodeDefaultImageData:data];
        }break;
    }
}
- (void)decodeDefaultImageData:(NSData *)data {
    NSArray<MCImageFrame *> *lFrames = [MCImageDefaultDecoder decodeData:data];
    self.frames = lFrames;
}
- (void)decodeGifImageData:(NSData *)data {
    NSArray<MCImageFrame *> *lFrames = [MCImageGifDecoder decodeData:data];
    self.frames = lFrames;
}
- (void)decodeWebPImageData:(NSData *)data {
    NSArray<MCImageFrame *> *lFrames = [MCImageWebPDecoder decodeData:data];
    self.frames = lFrames;
}
#pragma mark - Setter And Getter
- (NSInteger)frameCount {
    return self.frames.count;
}

@end
