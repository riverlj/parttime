//
//  RSLaunchimageViewController.m
//  RedScarf
//
//  Created by 李江 on 16/3/29.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "LaunchimageViewController.h"

@interface LaunchimageViewController ()
{
    UIImageView * _imageView;
    UIImageView *launchImageView;
}
@end

@implementation LaunchimageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    launchImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    NSString *launchImageStr = [self splashImageNameForOrientation:UIDeviceOrientationPortrait];
    UIImage *launchImage = [UIImage imageNamed:launchImageStr];
    [launchImageView setImage:launchImage];
    [self.view addSubview:launchImageView];
    [self.view sendSubviewToBack:launchImageView];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth - 70*(kUIScreenWidth)/320)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.view addSubview:_imageView];
    [self loadLaunchImage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performSelector:@selector(switchRootViewController) withObject:nil afterDelay:1.5f];
}

- (void)loadLaunchImage{

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [RSHttp mobileRequestWithURL:@"/mobile/index/loadingimg" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSDictionary *dic = [data objectForKey:@"body"];
        NSString *loadingimgStr = [dic objectForKey:@"loadingimg"];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:loadingimgStr]];
    } failure:^(NSInteger code, NSString *errmsg) {
        NSLog(@"%@", errmsg);
    }];
}

- (NSString *)splashImageNameForOrientation:(UIDeviceOrientation)orientation {
    CGSize viewSize = self.view.bounds.size;
    NSString* viewOrientation = @"Portrait";
    if (UIDeviceOrientationIsLandscape(orientation)) {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            return dict[@"UILaunchImageName"];
    }
    return nil;
}

- (void)switchRootViewController{
    AppDelegate *myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [myDelegate switchRootViewController];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
