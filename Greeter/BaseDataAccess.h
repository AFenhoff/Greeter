//
//  BaseDataAccess.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 5/30/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

//#define BASE_WCF_URL    @"http://uatprocapps/WebServices/WCF/iPadScaleReaderWCF/Service1.svc"
#define WCF_BASE_URL      @"https://recycling.djj.com/WebServices/YardOps/api"
//https://recycling.djj.com/WebServices/YardOps/api/suppliers/get/fischer
//#define BASE_WCF_URL    @"http://recyclingwebservices.djj.com/FurnaceWCF/Service1.svc"
//#define BASE_WCF_URL    @"https://recycling.djj.com/WebServices/WCF/FurnaceWCF/Service1.svc"

//#define WCF_AUTH_URL    @"http://uatprocapps/WebServices/WCF/iPadScaleReaderWCF/Service1.svc"
#define WCF_AUTH_URL      @"http://devprocdeppc1.djjgx.biz/DJJ.WebServices.Authentication/Authentication.svc/login"
//#define WCF_AUTH_URL    @"http://recyclingwebservices.djj.com/FurnaceWCF/Service1.svc"
//#define WCF_AUTH_URL    @"https://recycling.djj.com/WebServices/WCF/FurnaceWCF/Service1.svc"


#define WCF_USER_NAME     @"djj"
#define WCF_PASSWORD      @"djjPassword1"

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Material.h"
#import "ADFSViewController.h"

@protocol BaseDataAccessDelegate<NSObject>
@optional

//POST handlers
-(void)objectCreatedSuccessfully:(id)sender;//201
-(void)contentReturnedForPostRequest:(id)sender;//251
-(void)noContentReturnedForPostRequest:(id)sender;//451
-(void)unsuccessfulPostRequest:(id)sender;//453

//GET handlers
-(void)noRecordsForGetRequest:(id)sender;//204
-(void)updateSuccessfulForGetRequest:(id)sender;//252
-(void)updateUnsuccessfulForGetRequest:(id)sender;//452

//200
-(void)requestReturnedRecordsSuccessfully:(id)sender;

@required
-(void)didReceiveData:(NSMutableArray *)data;

@end


@interface BaseDataAccess : NSObject
{
    NSURLConnection *conn;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, assign) id<BaseDataAccessDelegate> delegate;

@property (nonatomic, retain) NSString *cookie;
@property (nonatomic, retain) NSMutableArray *returnedObjects;
@property (nonatomic, assign, readonly) int responseStatusCode;
@property (nonatomic, retain, readonly)	NSString *responseStatusMsg;
@property (nonatomic, retain) NSMutableData *returnedData;
@property (nonatomic, retain) id callbackDelegate;
@property (nonatomic, retain) NSString * GUID;
@property (nonatomic, retain) NSString *lastRequestURL;
@property (nonatomic, retain) NSURLResponse *returnedResponse;

+(void)clearAllObjectsForEntity:(NSString *)entityName;

- (void)executeWCFMethod:(NSString *)methodName forDelegate:(id)delegate;
- (void)executeWCFMethod:(NSString *)methodName forDelegate:(id)delegate withMoreInTheURL:(NSString *)moreURL;
- (void)executeWCFMethod:(NSString *)methodName forDelegate:(id)delegate withObject:(NSManagedObject*)objectToSend;

//This should get renamed to executeAPIGet
- (void) executeAPIMethod:(NSString *)methodPath forDelegate:(id)delegate;
- (void) executeAPIPost:(NSString *)methodPath forDelegate:(id)delegate withObject:(NSManagedObject*)objectToSend;


@end
