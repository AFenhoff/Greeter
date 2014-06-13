//
//  ADFSViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/2/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "ADFSViewController.h"
#import "Common.h"
#import "NSString+ContainsString.h"

@interface ADFSViewController ()

@end

@implementation ADFSViewController

@synthesize employeeID;

@synthesize webView, urlRequest, delegate;

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
    // Do any additional setup after loading the view.
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.msn.com"]];
    
    if (req) {
     [webView loadRequest:req];
    }
    
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

-(void)setURLRequestInWebView:(NSURLRequest *)req
{
    urlRequest = req;
    [webView loadRequest:req];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Webview shouldStartLoadWithRequest:NavigationType: %i", navigationType);

    //DO THIS FIRST Trouble here because of HTTP encoding of the URL during the request

    if ([[request.URL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""] isEqualToString:[[urlRequest.URL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"%2F" withString:@""]])
    {
        NSLog(@"This is the original request %@", request.description);
        
        NSHTTPCookie *cookie;
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [cookieJar cookies])
        {
            NSLog(@"Cookie: %@", cookie.name);
            if([cookie.name isEqualToString:@"FedAuth"])
                
                [delegate authenticationComplete:self];
                [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        
        /******************************************************************************************************************************
         PERSIST the Federation Authentication cookie
        NSHTTPCookie *cookie;
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [cookieJar cookies])
        {
            if([cookie.name isEqualToString:@"FedAuth"])
            {
                [Common saveStringSetting:@"authCookie" Value:cookie.value];
                [delegate authenticationComplete:self];
                [self dismissViewControllerAnimated:YES completion:nil];
                
                NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
                [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
                [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
                //[cookieProperties setObject:forKey:NSHTTPCookieOriginURL];
                [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
                [cookieProperties setObject:[NSString stringWithFormat:@"%d", cookie.version] forKey:NSHTTPCookieVersion];
                
                // set expiration to one month from now
                [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743*12] forKey:NSHTTPCookieExpires];
                
                cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                
            }
            NSLog(@"%@", cookie);
        }
         *****************************************************************************************************************************/
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)myWebView
{
    [myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var field = document.getElementById('ctl00_ContentPlaceHolder1_UsernameTextBox');field.value = '%@';",self.employeeID]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Webview Error : %@",error);
}

@end
