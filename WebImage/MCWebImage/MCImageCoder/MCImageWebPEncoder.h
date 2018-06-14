//
//  MCImageWebPEncoder.h
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCImageFrame;

@interface MCImageWebPEncoder : NSObject

+ (NSData *)encodeFrames:(NSArray<MCImageFrame *> *)frames;

@end
