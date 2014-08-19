//
//  CameraImage.m
//  camera
//
//  Created by Đỗ Hữu Điển on 11/19/13.
//  Copyright (c) 2013 Đỗ Hữu Điển. All rights reserved.
//

#import "CameraImage.h"

@implementation CameraImage
@synthesize delegate=_delegate;
- (id) init
{
	if (self = [super init]){
        
    }
	return self;
}

-(void)initialize:(BOOL)isFrontcamera{
    _isFrontcamera = isFrontcamera;
    self.frontcamera = _isFrontcamera;
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    AVCaptureDevice *device;
    if (isFrontcamera) {
        device = [self frontFacingCameraIfAvailable];
    }else{
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    //stillImageOutput is a global variable in .h file: "AVCaptureStillImageOutput *stillImageOutput;"
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
}

-(AVCaptureDevice *)frontFacingCameraIfAvailable{
    
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in videoDevices){
        
        if (device.position == AVCaptureDevicePositionFront){
            
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if (!captureDevice){
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

-(void) embedPreviewInView: (UIView *) aView {
    if (!session) return;
    preview = [AVCaptureVideoPreviewLayer layerWithSession: session];
    preview.frame = aView.bounds;
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer: preview];
}

- (void) dealloc
{
    stillImageOutput = nil;
	session = nil;
//	[super dealloc];
}

#pragma mark Class Interface


- (void) startRunning
{
	[session startRunning];
}

- (void) stopRunning
{
	[session stopRunning];
}

-(void)CaptureStillImage{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections){
        for (AVCaptureInputPort *port in [connection inputPorts]){
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error){

        CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments){
            
            // Do something with the attachments if you want to.
            NSLog(@"attachements: %@", exifAttachments);
        }
        else
            NSLog(@"no attachments");
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [_delegate imageCameraImage:image];
    }];
}


@end
