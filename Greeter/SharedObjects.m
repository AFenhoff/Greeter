//
//  SharedObjects.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/3/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "SharedObjects.h"
#import "Common.h"

@implementation SharedObjects

+ (id)getSharedObjects {
    static SharedObjects *sharedObjects = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObjects = [[self alloc] init];
    });
    return sharedObjects;
}

- (id)init {
    if (self = [super init]) {
        //someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
        self.greeterType = [Common getIntSetting:kGreeterMode];
                            
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(void)clearData
{
    self.dataManager = [[DataManager alloc] init];
    self.selectedSupplier = nil;
    self.selectedVehicle = nil;
    self.scannedLicense = nil;
    self.selectedMaterial = nil;
    self.inYardID = @"";
    self.bodyCount = 0;
    self.cfcTaken = 0;
    self.titlesTaken = 0;
    self.foundSupplierCount = 0;
    self.scannedBarcode = @"";
    self.scannedTrack1 = @"";
    self.scannedTrack2 = @"";
    self.scannedTrack3 = @"";
}

-(void)clearDataLeaveInYard
{
    self.dataManager = [[DataManager alloc] init];
    self.selectedSupplier = nil;
    self.selectedVehicle = nil;
    self.scannedLicense = nil;
    self.selectedMaterial = nil;
    //self.inYardID = @"";
    //self.bodyCount = 0;
    self.cfcTaken = 0;
    self.titlesTaken = 0;
    self.foundSupplierCount = 0;
    self.scannedBarcode = @"";
    self.scannedTrack1 = @"";
    self.scannedTrack2 = @"";
    self.scannedTrack3 = @"";
}




-(ADFSViewController *)authScreen
{
    if(_authScreen!=nil){
        return _authScreen;
    }
    //_authScreen = [[ADFSViewController alloc] init;
    
    _authScreen = [[UIApplication sharedApplication].keyWindow.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ADFSViewController"];
    _authScreen.delegate = self;
    return _authScreen;
}

-(DataManager *)dataManager
{
    if(_dataManager!=nil){
        return _dataManager;
    }
    _dataManager = [[DataManager alloc] init];
    return _dataManager;
}

- (void)popAuthenticationForDelegate:(id)delegate withRequestURL:(NSURLRequest *)requestedURL
{
    //    [self.authScreen.webView loadHTMLString:html baseURL:@"https://sts.djj.com"];
    
    //NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //[self.authScreen.webView loadData:requestedURL.HTTPBody MIMEType:@"" textEncodingName:@"" baseURL:nil];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    
    [topController presentViewController:self.authScreen animated:YES completion:nil];
    [self.authScreen setURLRequestInWebView:requestedURL];
    self.authScreen.delegate = delegate;
}

@end
