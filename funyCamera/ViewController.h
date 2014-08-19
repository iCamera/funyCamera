//
//  ViewController.h
//  funyCamera
//
//  Created by Đỗ Hữu Điển on 12/18/13.
//  Copyright (c) 2013 Đỗ Hữu Điển. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popOver;
- (IBAction)Camera:(id)sender ;
- (IBAction)CameraFBack:(id)sender ;
- (IBAction)Album:(id)sender ;
- (IBAction)info:(id)sender ;
@property (weak, nonatomic) IBOutlet UIButton *album;
@end
