//
//  ViewController.m
//  OpenCV4iOSDemo
//
//  Created by 恒阳 on 15/11/1.
//  Copyright © 2015年 ranger. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/opencv.hpp>

#import "UIImage+OpenCV.h"

@interface ViewController (){
    cv::Mat _cvImage;
}
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"OpenCV for iOS";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIImage *image = [UIImage imageNamed:@"face.jpg"];
    _cvImage = image.CVMat;
    
    if(!_cvImage.empty()){
        cv::Mat gray;
        
        // 将图像转换为灰度显示
        cv::cvtColor(_cvImage,gray,CV_RGB2GRAY);
        
        // 应用高斯滤波器去除小的边缘
        cv::GaussianBlur(gray, gray, cv::Size(5,5), 1.2,1.2);
        
        // 计算与画布边缘
        cv::Mat edges;
        cv::Canny(gray, edges, 0, 50);
        
        // 使用白色填充
        _cvImage.setTo(cv::Scalar::all(225));
        
        // 修改边缘颜色
        _cvImage.setTo(cv::Scalar(0,128,255,255),edges);
        
        // 将Mat转换为Xcode的UIImageView显示
        self.imageView.image = [UIImage imageWithCVMat:_cvImage];
    }
}

@end
