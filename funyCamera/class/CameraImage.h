//
//  CameraImage.h
//  camera
//
//  Created by Đỗ Hữu Điển on 11/19/13.
//  Copyright (c) 2013 Đỗ Hữu Điển. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
@protocol CameraImageDelegate<NSObject>
@optional
-(void)imageCameraImage:(UIImage*)image;
@end


@interface CameraImage : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    id<CameraImageDelegate> __unsafe_unretained _delegate;
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    
    AVCaptureVideoPreviewLayer *preview;
    BOOL _isFrontcamera;
    
}
@property(unsafe_unretained) id<CameraImageDelegate> delegate;
@property (nonatomic) BOOL frontcamera;

- (void) initialize:(BOOL)isFrontcamera;
- (void) startRunning;
- (void) stopRunning;
- (void)embedPreviewInView: (UIView *) aView;
-(void) CaptureStillImage;
@end
