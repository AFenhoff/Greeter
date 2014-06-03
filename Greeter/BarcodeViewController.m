//
//  BarcodeViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 3/19/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BarcodeViewController.h"

@interface BarcodeViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
    UIView *_bottomView;
    UIView *_roundedBoxView;
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;

}
@end

@implementation BarcodeViewController

@synthesize closeButton, tempDrawImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidLoad
{
    red = 255.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;

    [super viewDidLoad];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    [self.view addSubview:_bottomView];
    
    
    _label = [[UILabel alloc] init];
//    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(none)";
    [_bottomView addSubview:_label];

    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    _output.metadataObjectTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypePDF417Code];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 100);//
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    [self.view.layer addSublayer:_prevLayer];
    
    _roundedBoxView = [[UIView alloc] init];
    _roundedBoxView.frame = CGRectMake(10, self.view.bounds.size.height/2 - 50 + 10, self.view.bounds.size.width-20, 50);
    _roundedBoxView.layer.borderColor = [UIColor whiteColor].CGColor;
    _roundedBoxView.layer.borderWidth = 3;
    _roundedBoxView.layer.cornerRadius = 15.0;
    [self.view addSubview:_roundedBoxView];
    
    [_session startRunning];
    [self.view bringSubviewToFront:closeButton];
    
    /*
    [self.view bringSubviewToFront:_label];
    [self.view bringSubviewToFront:_closeButton];
    [self.view bringSubviewToFront:_bottomView];
    */
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{

    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    /*
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    */
    NSArray *barCodeTypes = @[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypePDF417Code];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil && ![detectionString isEqualToString:_label.text])
        {
            [self stopReading];
            _label.text = detectionString;
            [self.delegate barcodeCaptured:detectionString CallingViewController:self];
            [self runScanAnimation];
            break;
        }
        else
            _label.text = @"(none)";
    }
    
    _highlightView.frame = highlightViewRect;
    //[self.view bringSubviewToFront:_highlightView];
    
}

-(void)runScanAnimation
{
    [UIView animateWithDuration:0.05 animations:^{
        _roundedBoxView.backgroundColor = [UIColor redColor];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.05 animations:^{_roundedBoxView.backgroundColor = [UIColor clearColor];}
                             completion:^(BOOL finished){[self dismissViewControllerAnimated:YES completion:nil];}]
            ;}];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)stopReading{
    [_session stopRunning];
    _session = nil;
    //[_prevLayer removeFromSuperlayer];
}

-  (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
