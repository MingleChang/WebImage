//
//  UIImageView+MCWebImage.h
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCWebImageConfigure.h"

@interface UIImageView (MCWebImage)

-(void)mc_setImageWith:(NSString *)urlString;
-(void)mc_setImageWith:(NSString *)urlString placeholder:(UIImage *)placeholder;
-(void)mc_setImageWith:(NSString *)urlString placeholder:(UIImage *)placeholder options:(MCWebImageOptions)options progress:(MCWebImageProgressBlock)progressBlock completed:(MCWebImageResultBlock)completedBlock;

@end
