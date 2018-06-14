//
//  MCImageFrame.m
//  WebImage
//
//  Created by gongtao on 2018/6/14.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCImageFrame.h"

@interface MCImageFrame ()
@property (nonatomic, strong, readwrite)UIImage *image;
@property (nonatomic, assign, readwrite)NSTimeInterval duration;
@end

@implementation MCImageFrame

- (instancetype)initWithImage:(UIImage *)image duration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        self.image = image;
        self.duration = duration;
    }
    return self;
}
+ (MCImageFrame *)imageFrameWithImage:(UIImage *)image duration:(NSTimeInterval)duration {
    MCImageFrame *lFrame = [[MCImageFrame alloc] initWithImage:image duration:duration];
    return lFrame;
}

@end
