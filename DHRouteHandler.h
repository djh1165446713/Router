//
//  DHRouteHandler.h
//  Router
//
//  Created by 杜建虎 on 2019/2/13.
//  Copyright © 2019 DuJiAnHu. All rights reserved.
//

#ifndef DHRouteHandler_h
#define DHRouteHandler_h
#import <UIKit/Uikit.h>

typedef id DHParameters;

typedef void(^DHCompletionHandler)(id _Nullable result, NSError *_Nullable error);

@protocol DHRouteHandler <NSObject>
@required
+ (void)handleRequestWithParameters:(nullable DHParameters)parameters topViewController:(UIViewController *)topViewController completionHandler:(nullable DHCompletionHandler)completionHandler;

@optional
+ (NSString *)routePath;                    // 单路径  可以用这方法返回
+ (NSArray<NSString *> *)multiRoutePath;    // 多路径  可以用着方法返回


@end

#endif /* DHRouteHandler_h */
