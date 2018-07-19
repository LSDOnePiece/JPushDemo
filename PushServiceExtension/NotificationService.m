//
//  NotificationService.m
//  PushServiceExtension
//
//  Created by 神州锐达 on 2018/7/19.
//  Copyright © 2018年 onePiece. All rights reserved.
//

#import "NotificationService.h"
#import "JPushNotificationExtensionService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [NotificationService]", self.bestAttemptContent.title];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSString * attachmentPath = self.bestAttemptContent.userInfo[@"my-attachment"];
    
//    https://img13.360buyimg.com/n1/jfs/t20668/256/422418703/157944/fe933358/5b0c1928N8eb2d743.jpg
    //if exist
    if (attachmentPath && [attachmentPath hasSuffix:@"jpg"]) {
        //download
        NSURLSessionTask * task = [session dataTaskWithURL:[NSURL URLWithString:attachmentPath] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                NSString * localPath = [NSString stringWithFormat:@"%@/myAttachment.jpg", NSTemporaryDirectory()];
                if ([data writeToFile:localPath atomically:YES]) {
                    UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:@"myAttachment" URL:[NSURL fileURLWithPath:localPath] options:nil error:nil];
                    self.bestAttemptContent.attachments = @[attachment];
                }
            }
            [self apnsDeliverWith:request];
        }];
        [task resume];
    }else{
        [self apnsDeliverWith:request];
    }
}

- (void)apnsDeliverWith:(UNNotificationRequest *)request {
    
    //please invoke this func on release version
    //[JPushNotificationExtensionService setLogOff];
    
    //service extension sdk
    //upload to calculate delivery rate
    //please set the same AppKey as your JPush
    [JPushNotificationExtensionService jpushSetAppkey:@"3031925cf459dca93d26309b"];
    [JPushNotificationExtensionService jpushReceiveNotificationRequest:request with:^ {
        NSLog(@"apns upload success");
        self.contentHandler(self.bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

@end
#endif
