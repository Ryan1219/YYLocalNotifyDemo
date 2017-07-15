//
//  YYLocalNotifyManager.h
//  YYLocalNotificationDemo
//
//  Created by Ryan on 2017/7/15.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYLocalNotifyManager : NSObject

/* 注册通知 */
+ (void)registerLocalNotifyWithStartDate:(NSString *)startDate alertBody:(NSString *)alertBody listingId:(NSString *)listingId badge:(NSInteger)badge;

/* 取消通知 */
+ (void)cancelLocalNotifyWithListingId:(NSString *)listingId;


@end














































