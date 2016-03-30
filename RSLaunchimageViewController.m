//
//  RSLaunchimageViewController.m
//  RedScarf
//
//  Created by 李江 on 16/3/29.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSLaunchimageViewController.h"

@interface RSLaunchimageViewController ()
{
    UIImageView * _imageView;
    UIImageView *launchImageView;
}
@end

@implementation RSLaunchimageViewController

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
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_imageView];
    [self loadLaunchImage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performSelector:@selector(switchRootViewController) withObject:nil afterDelay:1.5f];
}

- (void)loadLaunchImage{

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"pttms" forKey:@"utm_campaign"];
    [params setObject:@"ios" forKey:@"utm_media"];
    [params setObject:@"1.0.0" forKey:@"utm_term"];
    [RSHttp mobileRequestWithURL:@"/mobile/index/loadingimg" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSDictionary *dic = [data objectForKey:@"body"];
        if ([[data objectForKey:@"code"] integerValue] == 0) {
            NSString *loadingimgStr = [dic objectForKey:@"loadingimg"];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:loadingimgStr]];
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)switchRootViewController{
    AppDelegate *myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [myDelegate switchRootViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}

@end
