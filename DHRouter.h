//
//  DHRouter.h
//  Router
//
//  Created by 杜建虎 on 2019/2/13.
//  Copyright © 2019 DuJiAnHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHRouterRequest.h"

typedef void(^DHRouterUnhandledCallBack)(DHRouterRequest *request,UIViewController *topViewController); // 无法处理时的回调

@interface DHRouter : NSObject
+(instancetype)shared;
- (void)handleRequest:(DHRouterRequest *)request completionHandler:(nullable DHCompletionHandler)comletionHandler;

@property (nonatomic,copy,nullable)DHRouterUnhandledCallBack unHandleCallback;
- (BOOL)canHandleRoutePath:(NSString *)routePath;           // 是否可以处理某个路径

@end


