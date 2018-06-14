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
#import "MCImageCoder.h"
#import "MCImageFrame.h"

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
    NSString *lPath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"webp"];
    NSData *lData = [NSData dataWithContentsOfFile:lPath];
    MCImageCoder *lCoder = [[MCImageCoder alloc] initWithData:lData];
    self.imageView.image = [lCoder image];
    lData = [lCoder dataWithType:MCWebImageTypePNG];
    [lData writeToFile:@"/Users/gongtao/Desktop/a.png" atomically:YES];
    NSLog(@"HelloWorld");
//    [self.imageView mc_setImageWith:@"http://img.zcool.cn/community/01c7415930cb03a8012193a313edff.gif" placeholder:[UIImage imageNamed:@"a.jpg"] options:0 progress:^(int64_t bytes, int64_t totalBytes, int64_t totalBytesExpected) {
//        NSLog(@"DOWNLOAD %lli,%lli,%lli",bytes,totalBytes,totalBytesExpected);
//    } completed:^(UIImage *image, NSData *data, NSError *error, MCWebImageCacheType type) {
//        NSLog(@"Image: %@\n Error:%@\n Type:%li", image, error, type);
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
