//
//  AppDelegate.m
//  YYLocalNotificationDemo
//
//  Created by Ryan on 2017/7/15.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

///* <#description#> */
//@property (nonatomic,strong) UILocalNotification *localNotification;
///* <#description#> */
//@property (nonatomic,strong) UNLocationNotificationTrigger *<#name#>;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    [self registerLocalNotifyPushWithApplication:application];
    
    

    return YES;
}

//http://www.jianshu.com/p/9cf65105364d
//MARK:----获取系统通知授权----
- (void)registerLocalNotifyPushWithApplication:(UIApplication *)application {
    
    if iOS10 {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)  completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (!error && granted) {
                NSLog(@"获得授权");
            } else {
                NSLog(@"没有获得授权");
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"System Info" message:@"Please open notifycation to receive message" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertCtrl addAction:cancelAction];
                [alertCtrl addAction:confirmAction];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:true completion:nil];
            }
        }];
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"------%@",settings);
        }];
        
    } else if iOS8 {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
//    else { //低于ios8系统        
//        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
//    }
}


//MARK:-UNUserNotificationCenterDelegate  >=ios10
//app 在前台的时候 在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    //1,拿到内容，处理通知
//    UNNotificationRequest *request = notification.request;
//    
//    UNNotificationContent *content = request.content;
//    
//    UNNotificationSound *sound  = content.sound;
//    
//    NSDictionary *userInfo = content.userInfo;
//    
//    NSNumber *badge = content.badge;
//    
//    NSString *alertBody = content.body;
//    
//    NSString *title = content.title;
//    
//    NSString *subTitle = content.subtitle;
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
         NSLog(@"receive remote message");
    } else {
        NSLog(@"receive local message");
    }
    
    //2,处理完用 completionHandler 用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    UNNotificationRequest *request = response.notification.request;
    
    UNNotificationContent *content = request.content;
    
//    UNNotificationSound *sound  = content.sound;
    
//    NSDictionary *userInfo = content.userInfo;
    
    NSInteger badge = content.badge.integerValue;
    badge--;
    badge = (badge >= 0) ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
//    NSString *alertBody = content.body;
//    
//    NSString *title = content.title;
//    
//    NSString *subTitle = content.subtitle;
    
    completionHandler();
    
}


//MARK:-ios10之前的本地通知在这处理
//接收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = (badge >= 0) ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
}

//MARK:-注册远程推送 友盟注册推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
}









- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = (badge >= 0) ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"YYLocalNotificationDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
