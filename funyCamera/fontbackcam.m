//
//  fontbackcam.m
//  funyCamera
//
//  Created by Đỗ Hữu Điển on 12/20/13.
//  Copyright (c) 2013 Đỗ Hữu Điển. All rights reserved.
//

#import "fontbackcam.h"
#import "CameraImage.h"
#import "GPUImage.h"
#import "AppDelegate.h"

@interface fontbackcam (){
    Byte Frontcamera;
    CGPoint point;
    UIImageView* facebookImage;
    UIAlertView* alview;
}
@property(retain,nonatomic) CameraImage *CameraHelper;
@end

@implementation fontbackcam

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    facebookImage = [[UIImageView alloc] init];
    self.scrollview2.transform = CGAffineTransformMake(self.scrollview2.transform.a * -1,
                                                           0,
                                                           0,
                                                           self.scrollview2.transform.d,
                                                           self.scrollview2.transform.tx,
                                                           0);
     [self performSelector:@selector(cameraview:) withObject:nil afterDelay:0.01];
	// Do any additional setup after loading the view.
}

- (IBAction)cameraview:(id)sender {
//    [self.cameraview setHidden:YES];
    Frontcamera = 0;
    [self.iCamera2 setImage:nil];
    _CameraHelper = [[CameraImage alloc] init];
    [_CameraHelper setDelegate:self];
    [self.flashonoff setHidden:NO];
    [self.fontback setHidden:NO];
    [self.viewcamera setHidden:NO];
    [self.viewcamera setFrame:self.scrollview1.frame];
    [self.camera setBackgroundImage:[UIImage imageNamed:@"small-button-camera@2x.png"] forState:UIControlStateNormal];
    [_CameraHelper initialize:FALSE];
    [_CameraHelper startRunning];
    [_CameraHelper embedPreviewInView:self.viewcamera];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"maincamera"]) {
        // Get destination view
        NSLog(@"log");
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flashonoff:(id)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device isTorchAvailable] && Frontcamera == 0) {
        BOOL success = [device lockForConfiguration:nil];
        if (success) {
            if ([sender isSelected]) {
                [sender setSelected:NO];
                [sender setBackgroundImage:[UIImage imageNamed:@"small-button-flash-active@2x.png"] forState:UIControlStateNormal];
                [device setTorchMode:AVCaptureTorchModeOff];  // use AVCaptureTorchModeOff to turn off
            }else{
                [sender setSelected:YES];
                [sender setBackgroundImage:[UIImage imageNamed:@"small-button-flash@2x.png"] forState:UIControlStateNormal];
                [device setTorchMode:AVCaptureTorchModeOn];  // use AVCaptureTorchModeOff to turn off
            }
            [device unlockForConfiguration];
        }
    }
}
- (IBAction)fortback:(id)sender {
    BOOL isfb = _CameraHelper.frontcamera;
    [self.viewcamera setHidden:YES];
    _CameraHelper = [[CameraImage alloc] init];
    [_CameraHelper setDelegate:self];
    [self.flashonoff setHidden:NO];
    [self.fontback setHidden:NO];
    [self.viewcamera setHidden:NO];
    if (Frontcamera==0) {
        [self.viewcamera setFrame:self.scrollview1.frame];
    }
    if (Frontcamera==1) {
        [self.viewcamera setFrame:self.scrollview2.frame];
    }
    if (isfb) [_CameraHelper initialize:FALSE];
    else [_CameraHelper initialize:TRUE];
    [_CameraHelper startRunning];
    [_CameraHelper embedPreviewInView:self.viewcamera];
}
- (IBAction)camera:(id)sender {
    if (Frontcamera == 2) {
        UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Cool... now what?"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Nervermind"
                                                         destructiveButtonTitle:nil
                                                              otherButtonTitles:@"Facebook", @"Save It",@"Capture",nil];
        
        [filterActionSheet showInView:self.view];
        filterActionSheet =nil;
        return;
    }
    
    [self.camera setEnabled:FALSE];
    
    [_CameraHelper CaptureStillImage];

}

//delegate cameraimage
-(void)imageCameraImage:(UIImage *)image{
    
    CGSize size = image.size;
    float scale = size.width/[AppDelegate W];
    float hight = size.height/scale;
    if (Frontcamera == 0) {
        [self.iCamera1 setFrame:CGRectMake(0, 0, [AppDelegate W], hight)];
        [self.iCamera1 setCenter:CGPointMake([AppDelegate W]/2, [AppDelegate H]/4)];
        self.iCamera1.image = image;
        [_CameraHelper stopRunning];
        _CameraHelper = nil;
        [self.viewcamera setFrame:self.scrollview2.frame];
        _CameraHelper = [[CameraImage alloc] init];;
        [_CameraHelper setDelegate:self];
        [_CameraHelper initialize:TRUE];
        [_CameraHelper startRunning];
        [_CameraHelper embedPreviewInView:self.viewcamera];
        Frontcamera = 1;
        [self.camera setEnabled:TRUE];
    }
    else if (Frontcamera == 1){
        [self.iCamera2 setFrame:CGRectMake(0, 0, [AppDelegate W], hight)];
        [self.iCamera2 setCenter:CGPointMake([AppDelegate W]/2, [AppDelegate H]/4)];
        Frontcamera = 2;
        self.iCamera2.image = image;
        [_CameraHelper stopRunning];
        [self.viewcamera setHidden:NO];
        [self.camera setBackgroundImage:[UIImage imageNamed:@"main-button-arrow-active@2x.png"] forState:UIControlStateNormal];
        _CameraHelper = nil;
        [self.flashonoff setHidden:YES];
        [self.fontback setHidden:YES];
        [self.viewcamera setHidden:YES];
        [self.camera setEnabled:TRUE];
    }
    
}

///touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan Frontcamera %i",Frontcamera);
    if (Frontcamera != 2 || ![self.viewEdit isHidden]) {
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    point = [touch locationInView:self.view];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesEnded Frontcamera %i",Frontcamera);
    if (Frontcamera != 2 || ![self.viewEdit isHidden]) {
        return;
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (abs(touchLocation.y - point.y) <= 5 && abs(touchLocation.x - point.x <= 5)){
        [self editImageMethod];
        return;
    }
    
    //doi vi tri 2 anh voi nhau
    if ( (CGRectContainsPoint(self.scrollview1.frame, touchLocation) && CGRectContainsPoint(self.scrollview2.frame, point)) ||
        (CGRectContainsPoint(self.scrollview2.frame, touchLocation) && CGRectContainsPoint(self.scrollview1.frame, point)) ){
        CGPoint pointimage1 = self.scrollview1.center;
        [UIView animateWithDuration:0.2f animations:^{
            //Move the image view to 100, 100 over 10 seconds.
            self.scrollview1.center = self.scrollview2.center;
            self.scrollview2.center = pointimage1;
        }];
        return;
    }
    //xoay anh trai phai.
    if ((abs((touchLocation.y - point.y)) - abs((touchLocation.x - point.x))) > 0) {
        if (abs(touchLocation.y - point.y) > 5) {
            
            if ( CGRectContainsPoint(self.scrollview1.frame, touchLocation) ) {
                [UIView animateWithDuration:0.2f animations:^{
                    self.scrollview1.transform = CGAffineTransformMake(self.scrollview1.transform.a,
                                                                           0,
                                                                           0,
                                                                           self.scrollview1.transform.d * -1,
                                                                           0,
                                                                           self.scrollview1.transform.ty);
                }];
            }
            if ( CGRectContainsPoint(self.scrollview2.frame, touchLocation) ) {
                [UIView animateWithDuration:0.2f animations:^{
                    self.scrollview2.transform = CGAffineTransformMake(self.scrollview2.transform.a,
                                                                            0,
                                                                            0,
                                                                            self.scrollview2.transform.d * -1,
                                                                            0,
                                                                            self.scrollview2.transform.ty);
                }];
            }
            
        }
    }
    else{
        if (abs(touchLocation.x - point.x) > 5) {
            if ( CGRectContainsPoint(self.scrollview1.frame, touchLocation) ) {
                [UIView animateWithDuration:0.2f animations:^{
                    self.scrollview1.transform = CGAffineTransformMake(self.scrollview1.transform.a * -1,
                                                                           0,
                                                                           0,
                                                                           self.scrollview1.transform.d,
                                                                           self.scrollview1.transform.tx,
                                                                           0);
                }];
            }
            if ( CGRectContainsPoint(self.scrollview2.frame, touchLocation) ) {
                [UIView animateWithDuration:0.2f animations:^{
                    self.scrollview2.transform = CGAffineTransformMake(self.scrollview2.transform.a * -1,
                                                                            0,
                                                                            0,
                                                                            self.scrollview2.transform.d,
                                                                            self.scrollview2.transform.tx,
                                                                            0);
                }];
            }
        }
    }
    
}

-(void)editImageMethod{
    
    //    originalImage.transform = CGAffineTransformMake(1, 0, 0, originalImage.transform.d * -1, 0, originalImage.transform.ty);
    [self hiden];
    [self.viewEdit setHidden:NO];
    if ( CGRectContainsPoint(self.scrollview1.frame, point)){
        [self.viewEdit setCenter:self.scrollview2.center];
        facebookImage.image = self.iCamera1.image;
    }
    if ( CGRectContainsPoint(self.scrollview2.frame, point)){
        [self.viewEdit setCenter:self.scrollview1.center];
        facebookImage.image = self.iCamera2.image;
    }
}

-(void)hiden{
    [self.camera setHidden:YES];
    [self.back setHidden:YES];
}
-(void)show{
    [self.camera setHidden:NO];
    [self.back setHidden:NO];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    [self hiden];
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, self.view.opaque, 0.0);
        //    UIGraphicsBeginImageContext(CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height));
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* screenImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        switch (buttonIndex) {
            case 0:
                facebookImage.image = screenImage;
                [self upphoto];
                break;
            case 1:
            {
                UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, nil);
                UIAlertView *alvs = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Save photo Success!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alvs show];
                alvs = nil;
            }
                break;
            case 2:
            {
               [self performSelector:@selector(cameraview:) withObject:nil afterDelay:0.01];
            }
                break;
        }
    }
    [self show];
}

- (IBAction)editimage:(id)sender {
    GPUImageFilter *selectedFilter;
    switch ([sender tag]) {
        case 0:
            selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 1:
            selectedFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 2:
            selectedFilter = [[GPUImageSketchFilter alloc] init];
            break;
        case 3:
            selectedFilter = [[GPUImagePixellateFilter alloc] init];
            break;
        case 4:
            selectedFilter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 5:
            selectedFilter = [[GPUImageToonFilter alloc] init];
            break;
        case 6:
            selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
            break;
        case 7:
            if ( CGRectContainsPoint(self.scrollview1.frame, point))
                self.iCamera1.image = facebookImage.image;
            else
                self.iCamera2.image = facebookImage.image;
            return;
        case 8:
            [self.viewEdit setHidden:YES];
            [self show];
            return;
    }
    if ( CGRectContainsPoint(self.scrollview1.frame, point)){
        UIImage *filteredImage = [selectedFilter imageByFilteringImage:self.iCamera1.image];
        self.iCamera1.image = filteredImage;
    }else{
        UIImage *filteredImage = [selectedFilter imageByFilteringImage:self.iCamera2.image];
        self.iCamera2.image = filteredImage;
    }
    
}

-(void)promptUserWithAccountNameForUploadPhoto {
    [self controlStatusUsable:NO];
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             UIAlertView *tmp = [[UIAlertView alloc]
                                 initWithTitle:@"Upload to FB?"
                                 message:[NSString stringWithFormat:@"Upload to ""%@"" Account?", user.name]
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"No",@"Yes", nil];
             tmp.tag = 100; // to upload
             [tmp show];
             tmp = nil;
             
         }
         [self controlStatusUsable:YES];
     }];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!facebookImage.image) {
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"Error" message:@"image error" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alv show];
        alv =nil;
        return;
    }
    if (buttonIndex==1) { // yes answer
        if (alertView.tag==100) {
            // then upload
            [self controlStatusUsable:NO];
            [FBRequestConnection startForUploadPhoto:facebookImage.image
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                       if (!error) {
                                           UIAlertView *tmp = [[UIAlertView alloc]
                                                               initWithTitle:@"Success"
                                                               message:@"Photo Uploaded"
                                                               delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:@"Ok", nil];
                                           
                                           [tmp show];
                                           tmp = nil;
                                       } else {
                                           UIAlertView *tmp = [[UIAlertView alloc]
                                                               initWithTitle:@"Error"
                                                               message:@"Some error happened"
                                                               delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:@"Ok", nil];
                                           
                                           [tmp show];
                                           tmp = nil;
                                       }
                                       [self controlStatusUsable:YES];
                                   }];
        }
        
    }
    NSLog(@"buttonIndex %d",buttonIndex);
    if (buttonIndex == 0) {
        if (alertView.tag==100) {
            [FBSession.activeSession closeAndClearTokenInformation];
            //            [self upphoto];
        }
    }
    
}

-(void)upphoto{
    if (FBSession.activeSession.isOpen) {
        
        // Yes, we are open, so lets make a request for user details so we can get the user name.
        
        [self promptUserWithAccountNameForUploadPhoto];
        
    } else {
        
        // We don't have an active session in this app, so lets open a new
        // facebook session with the appropriate permissions!
        
        // Firstly, construct a permission array.
        // you can find more "permissions strings" at http://developers.facebook.com/docs/authentication/permissions/
        // In this example, we will just request a publish_stream which is required to publish status or photos.
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                nil];
        // OPEN Session!
        [FBSession openActiveSessionWithPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error) {
                                      // if login fails for any reason, we alert
                                      if (error) {
                                          
                                          // show error to user.
                                          
                                      } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                          
                                          // no error, so we proceed with requesting user details of current facebook session.
                                          
                                          [self promptUserWithAccountNameForUploadPhoto];
                                      }
                                  }];
    }
    
}

-(void)controlStatusUsable:(BOOL)usable {
    if (!alview) {
        UIActivityIndicatorView* activ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activ startAnimating];
        activ.frame = CGRectMake(50, 50, 24, 24);
        alview = [[UIAlertView alloc] initWithTitle:@"Upload" message:@"loading..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alview addSubview:activ];
    }
    if (usable) {
        [alview dismissWithClickedButtonIndex:0 animated:YES];
    } else {
        [alview show];
    }
    
}

@end
