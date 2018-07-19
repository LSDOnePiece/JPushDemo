//
//  JpushManager.h
//  PushExtensionDemo
//
//  Created by 神州锐达 on 2018/7/19.
//  Copyright © 2018年 onePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AfterReceiveNoticationHandle)(NSDictionary *userInfo);

@interface JpushManager : NSObject<JPUSHRegisterDelegate>

//单例
+(instancetype)shareManager;

//初始化推送
-(void)lsd_setupWithOption:(NSDictionary *)launchingOption
                appKey:(NSString *)appKey
               channel:(NSString *)channel
      apsForProduction:(BOOL)isProduction
 advertisingIdentifier:(NSString *)advertisingId;

// 在appdelegate注册设备处调用
- (void)lsd_registerDeviceToken:(NSData *)deviceToken;

//设置角标
- (void)lsd_setBadge:(int)badge;

//接收到消息后的处理
@property(copy,nonatomic)AfterReceiveNoticationHandle afterReceiveNoticationHandle;



@end
