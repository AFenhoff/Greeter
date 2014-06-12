//
//  BaseDataAccess.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 5/30/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "BaseDataAccess.h"
#import "NSManagedObject+ToDictionary.h"
#import "Common.h"
#import "ADFSViewController.h"
#import "SharedObjects.h"
#import "NSString+ContainsString.h"
#import "User.h"
#import "UserDataAccess.h"
#import "NSHTTPCookie+ToString.h"

@implementation BaseDataAccess

@synthesize cookie, returnedObjects, responseStatusCode,
    responseStatusMsg, returnedData, callbackDelegate, lastRequestURL,
    returnedResponse;


+(void)clearAllObjectsForEntity:(NSString *)entityName
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest * allObjects = [[NSFetchRequest alloc] init];
    [allObjects setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:sharedObjects.managedObjectContext]];
    [allObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * objects = [sharedObjects.managedObjectContext executeFetchRequest:allObjects error:&error];
    //error handling goes here
    for (NSManagedObject *object in objects) {
        [sharedObjects.managedObjectContext deleteObject:object];
    }
    NSError *saveError = nil;
    [sharedObjects.managedObjectContext save:&saveError];
}


- (void)executeWCFMethod:(NSString *)methodName forDelegate:(id)delegate
{
    
    callbackDelegate = delegate;
    if(!activityIndicator)
    {
        activityIndicator = [Common getNewActivityIndicator];
    }
    [activityIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", WCF_BASE_URL, methodName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSDictionary *data = [NSDictionary dictionaryWithObject:@"abf-abf-abf-abf" forKey:@"GUID"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];

    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];

    //Set ADFS cookies here
    
	[request setHTTPBody:jsonData];
    		
    if(conn)
    {
        [conn cancel];
        conn = nil;
        returnedData = nil;
    }
    conn = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)executeWCFMethod:(NSString *)methodName forDelegate:(id)delegate withMoreInTheURL:(NSString *)moreURL
{
    
    callbackDelegate = delegate;
    if(!activityIndicator)
    {
        activityIndicator = [Common getNewActivityIndicator];
    }
    [activityIndicator startAnimating];
    		
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", WCF_BASE_URL, methodName, moreURL	]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSDictionary *data = [NSDictionary dictionaryWithObject:@"abf-abf-abf-abf" forKey:@"GUID"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
	
    //Set ADFS cookies here
    
    [request setHTTPBody:jsonData];
    
    if(conn)
    {
        [conn cancel];
        conn = nil;
        returnedData = nil;
    }
    conn = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)executeWCFMethod:(NSString *)methodName forDelegate:(id)delegate withObject:(NSManagedObject*)objectToSend
{
    
    callbackDelegate = delegate;
    if(!activityIndicator)
    {
        activityIndicator = [Common getNewActivityIndicator];
    }
    [activityIndicator startAnimating];
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", WCF_BASE_URL, methodName	]];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    //NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObject:[objectToSend toDictionary] forKey:[objectToSend class]];
//    [data setObject:[objectToSend jsonStringValue]  forKey:[objectToSend class]];
    
    
    
    //NSError *error;
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    //NSLog(@"\nPosting to %@\n\nObject Posted:\n%@", url,jsonData);
 
    ///////////////////////////////////////////////////////////////////
    
    NSManagedObject *theDb = objectToSend;
    NSEntityDescription *theDescription = theDb.entity;
    NSMutableDictionary *caseDict = [NSMutableDictionary dictionary];
    [caseDict setObject:@"Closed" forKey:@"status"];
    
    [self loadDict:theDescription dictionary:caseDict caseDb:theDb];

    NSString *dataString;
    NSData *data;
    if ([NSJSONSerialization isValidJSONObject:caseDict])
    {
        data = [NSJSONSerialization dataWithJSONObject:caseDict options:0 error:nil];
        dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"\"%@\":", [objectToSend class]];
    [urlString appendFormat:@"%@", dataString];
    
    NSData *postData = [urlString dataUsingEncoding:NSASCIIStringEncoding
                               allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSString *baseurl = [NSString stringWithFormat:@"%@/%@", WCF_BASE_URL, methodName];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    	
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [urlRequest setHTTPBody:data];
    
    ///////////////////////////////////////////////////////////////////
    
    //[request setHTTPMethod:@"POST"];
    //[request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
	//[request setHTTPBody:jsonData];
    
    /*
    if(conn)
    {
        [conn cancel];
        conn = nil;
        returnedData = nil;
    }
    */
    conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];

}

- (void) loadDict:(NSEntityDescription *) theDescription dictionary:(NSMutableDictionary *) caseDict caseDb: (NSManagedObject *) theCaseDb
{
    for (NSPropertyDescription *property in theDescription)
    {
        NSString *theName = property.name;
        id theObject = [theCaseDb valueForKey:theName];
        // Only send non-nil values...
        if (theObject)
        {
            [caseDict setObject:theObject forKey:theName];
        }else{
            [caseDict setObject:@"" forKey:theName];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (!returnedData) { returnedData = [[NSMutableData alloc] init]; }
    [returnedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    returnedResponse = response;
    [self handleResponse:response];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *myString = [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];

    //Assumes this is the ADFS STS redirection
    if([myString rangeOfString:@"<!DOCTYPE html PUBLIC " options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
        
        if(activityIndicator) {[activityIndicator stopAnimating]; }
        
        [sharedObjects popAuthenticationForDelegate:self withRequestURL:connection.currentRequest];
        return;
        /**
         PASS myString and the requested URL to the appDelegate
         load the webview in the Auth from with myString
         When it comes back, redirect to the requested URL
         **/
    }else{
        //if connecton.URL contains User (the initial user authentication) save the cookies to the custom cookie store
        //CookieStore *cookieStore = [[CookieStore alloc] init];
        NSString *urlPath = [returnedResponse.URL.path lowercaseString];
        if([[[urlPath stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"%2F" withString:@""] containsString:@"usergetemployeeid"])
        {
            NSString *myString = [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
            NSData *jsonData = [myString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *e;
            NSMutableArray *jsonList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
            
            SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
            //for(int i = 0; i < jsonList.count; i++)
            NSDictionary *string = (NSDictionary *)jsonList;
//            for(NSDictionary *string in jsonList)
//            {
                //NSDictionary *string = jsonList[i];
                //Clear only the record for this user
                [self saveUserCookiesInResponse:(NSHTTPURLResponse *)returnedResponse forEmployeeID:[string objectForKey:@"EmployeeID"]];
                [UserDataAccess clearUser:[string objectForKey:@"EmployeeID"]];
                User *user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:sharedObjects.managedObjectContext];
                
                user.employeeID          = [string objectForKey:@"EmployeeID"];
                user.userName            = [string objectForKey:@"UserName"];
                user.cookieStore         = nil;
                
                NSError *error = nil;
                if (![sharedObjects.managedObjectContext save:&error])
                {
                    // Handle the error.
                }
                sharedObjects.currentUser = user;
//            }
        }
    }
    //NSLog(@"\nPosting complete %@\n\nReturned Data:\n%@", connection.currentRequest.URL, myString);
    
    
    NSData *jsonData = [myString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *e;
    NSMutableArray *jsonList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    if(activityIndicator)
    {
        [activityIndicator stopAnimating];
    }
    [callbackDelegate didReceiveData:jsonList];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"\nPosting ERROR %@\n\n%@\n\n", connection.currentRequest.URL.path, error);
    if(activityIndicator)
    {
        [activityIndicator stopAnimating];
    }
    //[callbackDelegate didReceiveData:NULL];
    [Common showAlert:[NSString stringWithFormat:@"ERROR IN COMMUNICATION:\n%@", error.localizedDescription] forDelegate:self];
    
}

-(void) handleResponse:(NSURLResponse *)response
 {
     NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
     
#if DEBUG
     NSLog(@"response returned\nCODE:    %d\nMESSAGE: %@\n\n", httpResponse.statusCode, [[httpResponse allHeaderFields] valueForKey:@"Status-Message"] );
#endif

     
     switch (httpResponse.statusCode) {
         case 200:
             if([self.delegate respondsToSelector:@selector(requestReturnedRecordsSuccessfully:)])
                 [self.delegate requestReturnedRecordsSuccessfully:self];
             break;
         case 201:
             if([self.delegate respondsToSelector:@selector(objectCreatedSuccessfully:)])
                 [self.delegate	objectCreatedSuccessfully:self];
             break;
         case 204:
             if([self.delegate respondsToSelector:@selector(noRecordsForGetRequest:)])
                 [self.delegate noRecordsForGetRequest:self];
             break;
         case 251:
             if([self.delegate respondsToSelector:@selector(contentReturnedForPostRequest:)])
                 [self.delegate contentReturnedForPostRequest:self];
             break;
         case 252:
             if([self.delegate respondsToSelector:@selector(updateSuccessfulForGetRequest:)])
                 [self.delegate updateSuccessfulForGetRequest:self];
             break;
         case 400:
             //@@@20110427SG - set network activity indicator view to NO if any request fail. Do not route it through stopAnimatingandNetworkActivityIndicator
#if DEBUG
             NSLog(@" Data sent to server was in bad format. Server returned a bad request exception");
#endif
             
             break;
             
         case 401:
             //unauthorized
             
         case 403:

             [Common showAlert:[NSString stringWithFormat:@"%@", [[httpResponse allHeaderFields] valueForKey:@"Status-Message"] ] forDelegate:self];

             break;
         case 404:
             [Common showAlert:[NSString stringWithFormat:@"ERROR IN COMMUNICATION:\n%@", [[httpResponse allHeaderFields] valueForKey:@"Status-Message"] ] forDelegate:self];
             break;
         case 451:
             if([self.delegate respondsToSelector:@selector(noContentReturnedForPostRequest:)])
                 [self.delegate noContentReturnedForPostRequest:self];
             break;
         case 453:
             if([self.delegate respondsToSelector:@selector(unsuccessfulPostRequest:)])
                 [self.delegate unsuccessfulPostRequest:self];
             break;
         case 452:
             if([self.delegate respondsToSelector:@selector(updateUnsuccessfulForGetRequest:)])
                 [self.delegate updateUnsuccessfulForGetRequest:self];
             break;
             
         case 500:
#if DEBUG
             NSLog(@" request to server failed with response status code 500");
#endif
             
             break;
         default:
             
#if DEBUG
             NSLog(@" unknown HTTP code returned\n%d", responseStatusCode);
#endif
             break;
     }
     
}

- (void) executeAPIMethod:(NSString *)methodPath forDelegate:(id)delegate
{
    callbackDelegate = delegate;
    if(!activityIndicator)
    {
        activityIndicator = [Common getNewActivityIndicator];
    }
    [activityIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", WCF_BASE_URL, [methodPath stringByEncodingSpecialCharacters] ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    /*
    NSDictionary *data = [NSDictionary dictionaryWithObject:@"" forKey:@"DUMMY"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    */
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    //TODO: Set ADFS cookies here
    //Pull cookieStore from User entity in CoreData db
    // set all retreived cookies for this request
    //[theRequest setValue:@"myCookie" forHTTPHeaderField:@"Cookie"];
    [self handleCookiesInRequest:request];

	//Set post body
    //[request setHTTPBody:jsonData];
    
    if(conn)
    {
        [conn cancel];
        conn = nil;
        returnedData = nil;
    }
    conn = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) executeAPIPost:(NSString *)methodPath forDelegate:(id)delegate withObject:(NSManagedObject*)objectToSend
{
    callbackDelegate = delegate;
    if(!activityIndicator)
    {
        activityIndicator = [Common getNewActivityIndicator];
    }
    [activityIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", WCF_BASE_URL, [methodPath stringByEncodingSpecialCharacters] ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSManagedObject *theDb = objectToSend;
    NSEntityDescription *theDescription = theDb.entity;
    NSMutableDictionary *caseDict = [NSMutableDictionary dictionary];
    [self loadDict:theDescription dictionary:caseDict caseDb:theDb];
    
    NSString *dataString;
    NSData *data;
    if ([NSJSONSerialization isValidJSONObject:caseDict])
    {
        data = [NSJSONSerialization dataWithJSONObject:caseDict options:0 error:nil];
        dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"\"%@\":", [objectToSend class]];
    [urlString appendFormat:@"%@", dataString];
    NSData *postData = [urlString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    //TODO: Set ADFS cookies here
    //Pull cookieStore from User entity in CoreData db
    // set all retreived cookies for this request
    //[theRequest setValue:@"myCookie" forHTTPHeaderField:@"Cookie"];
    [self handleCookiesInRequest:request];
    
	//Set post body
    [request setHTTPBody:data];
    
    if(conn)
    {
        [conn cancel];
        conn = nil;
        returnedData = nil;
    }
    conn = [NSURLConnection connectionWithRequest:request delegate:self];
}
    
-(void)saveUserCookiesInResponse:(NSHTTPURLResponse *)response forEmployeeID:(NSNumber *)employeeID
{
    /*********************************************
     This works OK, putting back into request is a problem
     /*********************************************
    NSMutableArray *cookies =[[NSMutableArray alloc]init];
    for (NSHTTPCookie *thisCookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        NSLog(@"%@", thisCookie);
        // should be OK, check out category
        [cookies addObject:[thisCookie toDictionary]];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:cookies forKey:[NSString stringWithFormat:@"%@Cookies", employeeID]];
    *********************************************/
}

-(void) handleCookiesInRequest:(NSMutableURLRequest*) request
{
    /*********************************************
     HAVING A HARD TIME GETTING THIS TO WORK
    /*********************************************
     SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    NSArray *cookies = [UserDataAccess getUserCookiesForEmployeeID:sharedObjects.currentUser.employeeID];
    
    if(!cookies || cookies.count == 0) { return; }
    
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    NSUInteger count = [headers count];
    __unsafe_unretained id keys[count], values[count];
    [headers getObjects:values andKeys:keys];
    
    for (NSUInteger i=0;i<count;i++) {
        [request setValue:values[i] forHTTPHeaderField:keys[i]];
    }
    *********************************************/
}

@end
