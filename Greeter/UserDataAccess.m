//
//  UserDataAccess.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/8/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "UserDataAccess.h"
#import "SharedObjects.h"
#import "NSDictionary+ToCookie.h"

@implementation UserDataAccess

+(void)clearUser:(NSNumber *)employeeID
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"employeeID == %@", employeeID];
    
    NSFetchRequest *allObjects = [[NSFetchRequest alloc] init];
    [allObjects setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:sharedObjects.managedObjectContext]];
    [allObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    [allObjects setPredicate:predicate];
    
    NSError * error = nil;
    NSArray * objects = [sharedObjects.managedObjectContext executeFetchRequest:allObjects error:&error];
    //error handling goes here
    for (NSManagedObject *object in objects) {
        [sharedObjects.managedObjectContext deleteObject:object];
    }
    NSError *saveError = nil;
    [sharedObjects.managedObjectContext save:&saveError];
    
}

+(NSArray *)getUserCookiesForEmployeeID:(NSNumber *)employeeID
{
    NSArray *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Cookies", employeeID]];
    /*
    if(cookiesdata.count > 0) {
        NSArray *cookiesAsDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSMutableArray *cookies = [[NSMutableArray alloc] init];
        for(NSDictionary *cookie in cookiesAsDictionaries)
        {
            [cookies addObject:[cookie toCookie]];
        }
        return cookies;
    }
    return nil;
     */
    return cookiesdata;
}

-(void)authenticateUser
{
    self.lastRequestURL = @"user/getemployeeid";
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}

-(User *)getUserByEmployeeID:(NSNumber *)employeeID
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"employeeID == %@", employeeID];
    
    NSFetchRequest *allObjects = [[NSFetchRequest alloc] init];
    [allObjects setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:sharedObjects.managedObjectContext]];
    [allObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    [allObjects setPredicate:predicate];
    
    NSError * error = nil;
    NSArray * objects = [sharedObjects.managedObjectContext executeFetchRequest:allObjects error:&error];
    //return the first object found
    for (NSManagedObject *object in objects) {
        sharedObjects.currentUser = (User *)object;
        return sharedObjects.currentUser;
    }
    return nil;
}

-(void)authenticationComplete:(id)sender
{
    //NEED TO FIGURE OUT HOW TO RESUME WHERE WE LEFT OFF SINCE WE GET BACK HERE AFTER ADFS AUTHENTICATION
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
    
}

-(void)didReceiveData:(NSMutableArray *)data
{
    NSLog(@"User Data Received");
    [self.delegate didReceiveData:data];
}


@end
