//
//  LMAppDelegate.h
//  LeagueManager
//
//  Created by lyfing on 13-5-22.
//  Copyright (c) 2013年 lyfing.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
