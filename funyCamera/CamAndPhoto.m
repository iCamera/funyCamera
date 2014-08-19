//
//  CamAndPhoto.m
//  funyCamera
//
//  Created by Đỗ Hữu Điển on 12/18/13.
//  Copyright (c) 2013 Đỗ Hữu Điển. All rights reserved.
//

#import "CamAndPhoto.h"
#import "AppDelegate.h"
#import "GPUImage.h"
@interface CamAndPhoto (){
     UIImageView *imageGoc;
     UIAlertView *alview;
}

@end

@implementation CamAndPhoto

@synthesize imageview,image1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize size = image1.size;
    float scale = size.width/[AppDelegate W];
    float hight = size.height / scale;
    [self.imageview setFrame:CGRectMake(0, 0, [AppDelegate W], hight)];
    [self.imageview setCenter:CGPointMake([AppDelegate W]/2, [AppDelegate H]/2)];
    [imageview setImage:image1];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MainView"]) {
        // Get destination view
        [self setImage1:nil];
        [self setImageview:nil];
    }
}

//scollview

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}
- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    UIView* zoomView = [sv.delegate viewForZoomingInScrollView:sv];
    CGRect zvf = zoomView.frame;
    if(zvf.size.width < sv.bounds.size.width)
    {
        zvf.origin.x = (sv.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
    }
    if(zvf.size.height < sv.bounds.size.height)
    {
        zvf.origin.y = (sv.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
    }
    zoomView.frame = zvf;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)setting:(id)sender {
        if ([self.scrollview isHidden]) {
            [self showFrame];
            imageGoc = [[UIImageView alloc] init];
            [imageGoc setImage:self.imageview.image];
            [self.saveanh setHidden:YES];
            [self.scrollview setHidden:NO];
            [self.viewbutton setHidden:NO];
            [sender setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        }
        else{
            [imageGoc setImage:nil];
            [self.saveanh setHidden:NO];
            [self.viewbutton setHidden:YES];
            [self.scrollview setHidden:YES];
            [sender setImage:[UIImage imageNamed:@"Setting.png"] forState:UIControlStateNormal];
        }
}

-(void)showFrame{
    int rect,rect1;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        rect = 41;//iphone
    rect1 = 60;
    }
    else {rect = 71;//ipad
        rect1 = 100;
    }
    
    for (int i = 0; i <= 31; i++) {
        UIButton* btl_frame = [[UIButton alloc] init];
        btl_frame.frame = CGRectMake(rect * i, 0, rect-1, rect1);
        btl_frame.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        btl_frame.tag = i;
        [btl_frame addTarget:self action:@selector(btl_setframe:) forControlEvents:UIControlEventTouchUpInside];
        [btl_frame setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Frame/frame%i.png",i]] forState:UIControlStateNormal];
        [self.scrollview addSubview:btl_frame];
        btl_frame = nil;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    [self.scrollview setContentSize:CGSizeMake(rect * 32, rect1)];//iphone
    else [self.scrollview setContentSize:CGSizeMake(rect * 32, rect1)];//ipad
}

- (IBAction)btl_setframe:(id)sender{
    if ([sender tag] == 0) {
        [self.imageFrame setHidden:YES];
    }
    else{
        [self.imageFrame setHidden:NO];
        self.imageFrame.image = [sender currentBackgroundImage];
    }
}

- (IBAction)tollimage:(id)sender {
    GPUImageFilter *selectedFilter;
    switch ([sender tag]) {
        case 0:
            selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 1:
            selectedFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 2:
            selectedFilter = [[GPUImageSketchFilter alloc] init] ;
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
            self.imageview.image = imageGoc.image;
            return;
    }
    UIImage *filteredImage = [selectedFilter imageByFilteringImage:self.imageview.image];
    self.imageview.image = filteredImage;
    selectedFilter = nil;
}

- (IBAction)saveanh:(id)sender {
    UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Cool... now what?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Nervermind"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"Facebook", @"Save It",nil];
    
    [filterActionSheet showInView:self.view];
    filterActionSheet = nil;
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
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* screenImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        switch (buttonIndex) {
            case 0:
                NSLog(@"fb");
                imageGoc = [[UIImageView alloc] init];
                imageGoc.image = screenImage;
                [self upphoto];
                break;
            case 1:
                NSLog(@"luu anh");
                UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, nil);
                UIAlertView *alvs = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Save photo Success!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alvs show];
                alvs = nil;
                break;
        }
    }
    [self show];
}
-(void)hiden{
    [self.setting setHidden:YES];
    [self.saveanh setHidden:YES];
    [self.back setHidden:YES];
}
-(void)show{
    [self.setting setHidden:NO];
    [self.saveanh setHidden:NO];
    [self.back setHidden:NO];
}
//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - delegeat facebook
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
    if (!imageGoc.image) {
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"Error" message:@"image error" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alv show];
        alv = nil;
        return;
    }
    if (buttonIndex==1) { // yes answer
        if (alertView.tag==100) {
            // then upload
            [self controlStatusUsable:NO];
            [FBRequestConnection startForUploadPhoto:imageGoc.image
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
