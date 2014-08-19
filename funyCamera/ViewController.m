//
//  ViewController.m
//  funyCamera
//
//  Created by Đỗ Hữu Điển on 12/18/13.
//  Copyright (c) 2013 Đỗ Hữu Điển. All rights reserved.
//

#import "ViewController.h"
#import "CamAndPhoto.h"
@interface ViewController (){
    BOOL isCamera;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Camera:(id)sender {
    isCamera = true;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.wantsFullScreenLayout = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)CameraFBack:(id)sender {
}

- (IBAction)Album:(id)sender {
    isCamera = false;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [popover presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.album.frame.origin.y, 200, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.popOver = popover;
    } else {
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)info:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CameraAlbum"]) {
        // Get destination view
        CamAndPhoto *vc = [segue destinationViewController];
        [vc setImage1:sender];
    }
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *choseImage;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && !isCamera) {
        choseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.popOver dismissPopoverAnimated:YES];
         [self performSegueWithIdentifier:@"CameraAlbum" sender:choseImage];
    }else{
        choseImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
             [self performSegueWithIdentifier:@"CameraAlbum" sender:choseImage];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self prefersStatusBarHidden];
}

//fix not hide status on ios7
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
//end


@end
