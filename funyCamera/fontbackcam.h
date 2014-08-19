//
//  fontbackcam.h
//  funyCamera
//
//  Created by Đỗ Hữu Điển on 12/20/13.
//  Copyright (c) 2013 Đỗ Hữu Điển. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "CameraImage.h"

@interface fontbackcam : UIViewController<UIActionSheetDelegate,CameraImageDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview1;
@property (weak, nonatomic) IBOutlet UIImageView *iCamera1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview2;
@property (weak, nonatomic) IBOutlet UIImageView *iCamera2;
@property (weak, nonatomic) IBOutlet UIView *viewcamera;
@property (weak, nonatomic) IBOutlet UIButton *flashonoff;
- (IBAction)flashonoff:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fontback;
- (IBAction)fortback:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *camera;
- (IBAction)camera:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewEdit;
- (IBAction)editimage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *back;

@end
