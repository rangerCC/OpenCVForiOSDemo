//
//  UIImage+OpenCV.m
//  OpenCV4iOSDemo
//
//  Created by 恒阳 on 15/11/1.
//  Copyright © 2015年 ranger. All rights reserved.
//

#import "UIImage+OpenCV.h"

@implementation UIImage (OpenCV)

#pragma mark - properties
-(cv::Mat)CVMat
{
    CGColorSpaceRef colorSpace =CGImageGetColorSpace(self.CGImage);
    
    CGFloat cols =self.size.width;
    
    CGFloat rows =self.size.height;
    
    cv::Mat cvMat(rows, cols,CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, // Pointer to backing data
                                                    
                                                    cols, // Width of bitmap
                                                    
                                                    rows, // Height of bitmap
                                                    
                                                    8, // Bits per component
                                                    
                                                    cvMat.step[0], // Bytes per row
                                                    
                                                    colorSpace, // Colorspace
                                                    
                                                    kCGImageAlphaNoneSkipLast |
                                                    
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(cv::Mat)CVGrayscaleMat
{
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceGray();
    
    CGFloat cols =self.size.width;
    
    CGFloat rows =self.size.height;
    
    cv::Mat cvMat =cv::Mat(rows, cols,CV_8UC1); // 8 bits per component, 1 channel
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, // Pointer to backing data
                                                    
                                                    cols, // Width of bitmap
                                                    
                                                    rows, // Height of bitmap
                                                    
                                                    8, // Bits per component
                                                    
                                                    cvMat.step[0], // Bytes per row
                                                    
                                                    colorSpace, // Colorspace
                                                    
                                                    kCGImageAlphaNone |
                                                    
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    
    CGContextRelease(contextRef);
    
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
- (IplImage *)iplImage
{
    CGImageRef imageRef = self.CGImage;
    
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    IplImage *iplimage =cvCreateImage(cvSize(self.size.width, self.size.height),IPL_DEPTH_8U,4);
    CGContextRef contextRef =CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
                                                   iplimage->depth, iplimage->widthStep,
                                                   colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef,CGRectMake(0,0, self.size.width, self.size.height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    IplImage *ret =cvCreateImage(cvGetSize(iplimage),IPL_DEPTH_8U,3);
    cvCvtColor(iplimage, ret,CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}

#pragma mark - class methods
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    return [[UIImage alloc] initWithCVMat:cvMat];
}


- (id)initWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1)
    {
        colorSpace = CGColorSpaceCreateDeviceGray();
    }
    else
    {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider =CGDataProviderCreateWithCFData((CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols, // Width
                                        
                                        cvMat.rows, // Height
                                        
                                        8, // Bits per component
                                        
                                        8 * cvMat.elemSize(), // Bits per pixel
                                        
                                        cvMat.step[0], // Bytes per row
                                        
                                        colorSpace, // Colorspace
                                        
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault, // Bitmap info flags
                                        
                                        provider, // CGDataProviderRef
                                        
                                        NULL, // Decode
                                        
                                        false, // Should interpolate
                                        
                                        kCGRenderingIntentDefault); // Intent
    
    self = [self initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    CGDataProviderRelease(provider);
    
    CGColorSpaceRelease(colorSpace);
    
    return self;
}

+ (UIImage *)imageWithIplImage:(const IplImage*)iplImage
{
    return [[self alloc] initWithIplImage:iplImage];
}

// NOTE You should convert color mode as RGB before passing to this function
- (id)initWithIplImage:(const IplImage *)iplImage {
    NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", iplImage->width, iplImage->height, iplImage->depth, iplImage->nChannels, iplImage->widthStep, iplImage->channelSeq);
    
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    NSData *data = [NSData dataWithBytes:iplImage->imageData length:iplImage->imageSize];
    CGDataProviderRef provider =CGDataProviderCreateWithCFData((CFDataRef)data);
    CGImageRef imageRef =CGImageCreate(iplImage->width, iplImage->height,
                                       iplImage->depth, iplImage->depth * iplImage->nChannels, iplImage->widthStep,
                                       colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                       provider,NULL,false,kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}
@end
