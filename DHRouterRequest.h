//
//  DHRouterRequest.h
//  Router
//
//  Created by 杜建虎 on 2019/2/13.
//  Copyright © 2019 DuJiAnHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHRouteHandler.h"

@interface DHRouterRequest : NSObject
- (instancetype)initWithPath:(NSString *)requestPath parameters:(nullable DHParameters)parameters NS_DESIGNATED_INITIALIZER;
@property (nonatomic, strong, readonly)NSString *requestPath;
@property (nonatomic, strong, readonly,nullable)DHParameters pars;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@interface DHRouterRequest(CreateByURL)
- (instancetype)initWithURL:(NSURL *)URL;

@property (nonatomic, strong, readonly,nullable)NSURL *originalURL;
@end


