//
//  DHRouterRequest.m
//  Router
//
//  Created by 杜建虎 on 2019/2/13.
//  Copyright © 2019 DuJiAnHu. All rights reserved.
//

#import "DHRouterRequest.h"
#import <objc/message.h>
@interface DHRouterRequest()
@property (nonatomic, strong, readonly,nullable)NSURL *originalURL;
@end

@implementation DHRouterRequest

- (instancetype)initWithPath:(NSString *)requestPath parameters:(nullable DHParameters)parameters{
    NSParameterAssert(requestPath);
    self = [super init];
    if (!self) {
        return nil;
    }
    
    while ([requestPath hasPrefix:@"/"]) {
        requestPath = [requestPath substringFromIndex:1];
    }
    _requestPath = requestPath.copy?:@"";
    _pars = parameters;
    return self;
}
@end


@implementation DHRouterRequest(CreatByURL)
- (instancetype)initWithURL:(NSURL *)URL{
    DHParameters parameters = nil;
    NSURLComponents *c = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:YES];
    if (0 != c.queryItems.count) {
        NSMutableDictionary *m = [NSMutableDictionary new];
        for (NSURLQueryItem *item in c.queryItems) {
            m[item.name] = item.value;
        }
        parameters = m.copy;
    }
    self = [self initWithPath:URL.path.stringByDeletingPathExtension parameters:parameters];
    if (!self) {
        return nil;
    }
    _originalURL = URL;
    return self;
}

- (NSString *)description{
    return
    [NSString stringWithFormat:@"[%@<%p>] {\n \
     requestPath = %@; \n \
     parameters = %@; \n \
     originalURL = %@; \n \
     }",NSStringFromClass([self class]),self,_requestPath,_pars,_originalURL];
}
@end
