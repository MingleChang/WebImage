//
//  MCImageFrame.h
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCImageFrame : NSObject

@property (nonatomic, strong, readonly)UIImage *image;
@property (nonatomic, assign, readonly)NSTimeInterval duration;

- (instancetype)initWithImage:(UIImage *)image duration:(NSTimeInterval)duration;
+ (MCImageFrame *)imageFrameWithImage:(UIImage *)image duration:(NSTimeInterval)duration;

@end
