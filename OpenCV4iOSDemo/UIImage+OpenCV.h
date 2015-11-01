//
//  UIImage+OpenCV.h
//  OpenCV4iOSDemo
//
//  Created by 恒阳 on 15/11/1.
//  Copyright © 2015年 ranger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface UIImage (OpenCV)
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
+ (UIImage *)imageWithIplImage:(const IplImage*)iplImage;

- (id)initWithCVMat:(const cv::Mat&)cvMat;
- (id)initWithIplImage:(const IplImage*)iplImage;

@property(nonatomic,readonly) cv::Mat CVMat;

@property(nonatomic,readonly) cv::Mat CVGrayscaleMat;

@property(nonatomic,readonly) IplImage *iplImage;

@end
