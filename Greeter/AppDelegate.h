//
//  AppDelegate.h
//  Greeter
//
//  Created by Andrew Fenhoff on 9/20/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)popAuthenticationWithHTML:(NSString *)html withRequestURL:(NSURLRequest *)requestedURL ;

@end
