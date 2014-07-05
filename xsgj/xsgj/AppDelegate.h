//
//  AppDelegate.h
//  xsgj
//
//  Created by ilikeido on 14-7-4.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) AKTabBarController *tabBarController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)showTabView;

-(void)hideTabView;

-(void)selectedTabView:(NSInteger)index;

@end
