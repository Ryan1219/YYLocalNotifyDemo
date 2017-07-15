//
//  YYLocalNotifyManager.m
//  YYLocalNotificationDemo
//
//  Created by Ryan on 2017/7/15.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import "YYLocalNotifyManager.h"
#import <UserNotifications/UserNotifications.h>


@interface YYLocalNotifyManager ()

@end

@implementation YYLocalNotifyManager

//http://www.jianshu.com/p/9cf65105364d
+ (void)registerLocalNotifyWithStartDate:(NSString *)startDate alertBody:(NSString *)alertBody listingId:(NSString *)listingId badge:(NSInteger)badge {
    
    CGFloat countDown = 10;
    
    NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    //活动开始时间
    NSDate *upcomingDate = [dateFormatter dateFromString:startDate];
    NSString *startDateString = [NSString stringWithFormat:@"%.0f",[upcomingDate timeIntervalSince1970]];
    
    //当前时间
//    NSString *currentDataString =[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    
    //时间间隔
    CGFloat timeDistance = startDateString.integerValue - countDown;
    
    if iOS10 {
        
        //使用UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *notifyCenter = [UNUserNotificationCenter currentNotificationCenter];
        
        //通知内容
        UNMutableNotificationContent *notifyContent = [[UNMutableNotificationContent alloc] init];
        notifyContent.title = @"Local Notify";
        notifyContent.body = alertBody;
        notifyContent.sound = [UNNotificationSound defaultSound];
        notifyContent.badge = [NSNumber numberWithInteger:badge];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:alertBody forKey:listingId];
        notifyContent.userInfo = userInfo;
        
        //在alertTime后推送本地消息
//        UNTimeIntervalNotificationTrigger *notifyTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeDistance repeats:false];
        UNTimeIntervalNotificationTrigger *notifyTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:6.f repeats:false];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:listingId content:notifyContent trigger:notifyTrigger];
        
        //添加推送成功后的处理
        [notifyCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
            if (!error) {
                NSLog(@"Add Local Notify Success");
                
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Local Notify" message:@"Success push message" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertCtrl addAction:cancelAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:true completion:nil];
            }
        }];

    } else {
        
        UILocalNotification *localNotify = [[UILocalNotification alloc] init];
        if (localNotify) {
            
//            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeDistance];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:6.f];
            localNotify.fireDate = date;
            localNotify.timeZone = [NSTimeZone defaultTimeZone];
            localNotify.repeatInterval = 0;
            localNotify.alertBody = alertBody;
            localNotify.applicationIconBadgeNumber = badge;
            localNotify.soundName = UILocalNotificationDefaultSoundName;
            localNotify.alertTitle = @"Local Notify";
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:alertBody forKey:listingId];
            localNotify.userInfo = userInfo;
            
//            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//                UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
//                
//                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//            } else {
//                
//            }
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotify];
        }

    }
    
}

+ (void)cancelLocalNotifyWithListingId:(NSString *)listingId {
    
    if iOS10 {
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[listingId]];
    } else {
        //获取所有本地通知数据
        NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
        for (UILocalNotification *notification in localNotifications) {
            NSDictionary *userInfo = notification.userInfo;
            if (userInfo != nil) {
                NSString *alertBody = userInfo[listingId];
                if (alertBody != nil) {
                    [[UIApplication sharedApplication] cancelLocalNotification:notification];
                }
            }
        }
    }

}




@end



























































