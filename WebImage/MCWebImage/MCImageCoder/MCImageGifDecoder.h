//
//  MCImageGifDecoder.h
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCImageFrame;

@interface MCImageGifDecoder : NSObject

+ (NSArray<MCImageFrame *> *)decodeData:(NSData *)data;

@end
