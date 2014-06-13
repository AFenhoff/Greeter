//
//  ADFSViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/2/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADFSViewControllerDelegate<NSObject>

@required
-(void)authenticationComplete:(id)sender;
@end

@interface ADFSViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) id<ADFSViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSURLRequest *urlRequest;
@property (nonatomic, retain) NSString* employeeID;

-(void)setURLRequestInWebView:(NSURLRequest *)req;

@end
