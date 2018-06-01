//
//  ViewController.m
//  WebImage
//
//  Created by gongtao on 2018/6/1.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "ViewController.h"
#import "MCImageDownloadManager.h"
#import "UIImageView+MCWebImage.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.imageView mc_setImageWith:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=4288933140,2516501701&fm=173&app=25&f=JPEG?w=218&h=146&s=ACC2722317E9A2E61E3DE09E0100C0C2" placeholder:[UIImage imageNamed:@"a.jpg"] options:0 progress:^(int64_t bytes, int64_t totalBytes, int64_t totalBytesExpected) {
        NSLog(@"DOWNLOAD %lli,%lli,%lli",bytes,totalBytes,totalBytesExpected);
    } completed:^(UIImage *image, NSData *data, NSError *error, MCWebImageCacheType type) {
        NSLog(@"Image: %@\n Error:%@\n Type:%li", image, error, type);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
