//
//  CamAndPhoto.h
//  funyCamera
//
//  Created by Đỗ Hữu Điển on 12/18/13.
//  Copyright (c) 2013 Đỗ Hữu Điển. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
@interface CamAndPhoto : UIViewController<UIActionSheetDelegate>{
    UIImage *image1;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (nonatomic) UIImage *image1;
@property (weak, nonatomic) IBOutlet UIImageView *imageFrame;
- (IBAction)setting:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewbutton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
- (IBAction)tollimage:(id)sender;
- (IBAction)saveanh:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveanh;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *setting;

@end
