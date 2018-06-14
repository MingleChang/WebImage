//
//  MCImageDefaultDecoder.m
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageDefaultDecoder.h"
#import "MCImageFrame.h"

@implementation MCImageDefaultDecoder

+ (NSArray<MCImageFrame *> *)decodeData:(NSData *)data {
    UIImage *lImage = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
    if (lImage) {
        MCImageFrame *lFrame = [MCImageFrame imageFrameWithImage:lImage duration:0];
        return @[lFrame];
    }else {
        return nil;
    }
}

@end
