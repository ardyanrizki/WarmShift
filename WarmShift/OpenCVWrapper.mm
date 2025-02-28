// © 2025 Ardyan - Pattern Matters. All rights reserved.

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

#import "WarmShift-Bridging-Header.h"

@interface UIImage (OpenCVWrapper)
- (void)convertToMat: (cv::Mat *)pMat;
@end

@implementation UIImage (OpenCVWrapper)
- (void)convertToMat: (cv::Mat *)pMat {
    if (self.imageOrientation == UIImageOrientationRight) {
        /*
         * When taking picture in portrait orientation,
         * convert UIImage to OpenCV Matrix in landscape right-side-up orientation,
         * and then rotate OpenCV Matrix to portrait orientation
         */
        UIImageToMat([UIImage imageWithCGImage:self.CGImage scale:1.0 orientation:UIImageOrientationUp], *pMat);
        cv::rotate(*pMat, *pMat, cv::ROTATE_90_CLOCKWISE);
    } else if (self.imageOrientation == UIImageOrientationLeft) {
        /*
         * When taking picture in portrait upside-down orientation,
         * convert UIImage to OpenCV Matrix in landscape right-side-up orientation,
         * and then rotate OpenCV Matrix to portrait upside-down orientation
         */
        UIImageToMat([UIImage imageWithCGImage:self.CGImage scale:1.0 orientation:UIImageOrientationUp], *pMat);
        cv::rotate(*pMat, *pMat, cv::ROTATE_90_COUNTERCLOCKWISE);
    } else {
        /*
         * When taking picture in landscape orientation,
         * convert UIImage to OpenCV Matrix directly,
         * and then ONLY rotate OpenCV Matrix for landscape left-side-up orientation
         */
        UIImageToMat(self, *pMat);
        if (self.imageOrientation == UIImageOrientationDown) {
            cv::rotate(*pMat, *pMat, cv::ROTATE_180);
        }
    }
}
@end

@implementation OpenCVWrapper

+ (UIImage *)adjustTemperature:(UIImage *)image temperature:(float)temperature {
    cv::Mat src;
    [image convertToMat: &src];
    
    if (src.empty()) {
        NSLog(@"Error: Image conversion failed, src is empty.");
        return nil;
    }
    
    if (src.channels() == 4) {
        cv::cvtColor(src, src, cv::COLOR_BGRA2BGR);
    }
    
    cv::Mat dst;
    
    cv::Mat warmMatrix = (cv::Mat_<float>(3, 3) <<
                          1.0 + temperature * 0.1, 0, 0,
                          0, 1.0, 0,
                          0, 0, 1.0 - temperature * 0.1);

    cv::transform(src, dst, warmMatrix);
    
    return MatToUIImage(dst);
}

@end
