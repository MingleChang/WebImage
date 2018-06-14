//
//  MCImageCoder.h
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCWebImageConfigure.h"

@class MCImageFrame;

@interface MCImageCoder : NSObject

@property (nonatomic, copy)NSArray<MCImageFrame *> *frames;
@property (nonatomic, assign, readonly)NSInteger frameCount;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithImage:(UIImage *)image;

- (UIImage *)image;
- (NSData *)dataWithType:(MCWebImageType)type;

@end
