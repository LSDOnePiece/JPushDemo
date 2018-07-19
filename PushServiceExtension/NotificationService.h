//
//  NotificationService.h
//  PushServiceExtension
//
//  Created by 神州锐达 on 2018/7/19.
//  Copyright © 2018年 onePiece. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
@interface NotificationService : UNNotificationServiceExtension

@end
#endif
