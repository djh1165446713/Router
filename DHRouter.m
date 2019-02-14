//
//  DHRouter.m
//  Router
//
//  Created by 杜建虎 on 2019/2/13.
//  Copyright © 2019 DuJiAnHu. All rights reserved.
//

#import "DHRouter.h"
#import <objc/message.h>
static UIViewController *_dh_get_top_view_controller(){
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    while ([vc isKindOfClass:[UINavigationController class]] || [vc isKindOfClass:[UITabBarController class]]) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc topViewController];
        }
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
    }
    return vc;
}

@interface DHRouter()
@property (nonatomic,strong,readonly)NSMutableDictionary<NSString *,Class<DHRouteHandler>> *handlersM;
@end

@implementation DHRouter
+ (instancetype)shared{
    static id _instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    _handlersM = [NSMutableDictionary new];
    unsigned int img_count = 0;
    const char **imgs = objc_copyImageNames(&img_count);
    const char *main = NSBundle.mainBundle.bundlePath.UTF8String;
    for (unsigned int i = 0; i < img_count; ++i) {
        const char *img = imgs[i];
        if (!strstr(img, main)) {
            continue;
        }
        unsigned int cls_count = 0;
        const char **classes = objc_copyClassNamesForImage(img, &cls_count);
        Protocol *p_handler = @protocol(DHRouteHandler);
        for (unsigned int i = 0; i < cls_count; ++i) {
            const char *cls_name = classes[i];
            NSString *cls_str = [NSString stringWithUTF8String:cls_name];
            Class cls = NSClassFromString(cls_str);
            if (![cls conformsToProtocol:p_handler]) {
                continue;
            }
            if (![(id)cls respondsToSelector:@selector(handleRequestWithParameters:topViewController:completionHandler:)]) {
                continue;
            }
            if ([(id)cls respondsToSelector:@selector(routePath)]) {
                _handlersM[[(id<DHRouteHandler>)cls routePath]] = cls;
            }else if ([(id)cls respondsToSelector:@selector(multiRoutePath)]){
                for (NSString *request in [(id<DHRouteHandler>)cls multiRoutePath]) {
                    _handlersM[request] = cls;
                }
            }
        }
        if (classes) {
            free(classes);
        }
    }
    if (imgs) {
        free(imgs);
    }
    return self;
}

- (void)handleRequest:(DHRouterRequest *)request completionHandler:(DHCompletionHandler)comletionHandler{
    NSParameterAssert(request);
    if (!request) {
        return;
    }
    Class<DHRouteHandler>handler = _handlersM[request.requestPath];
    if (handler) {
        [handler handleRequestWithParameters:request.pars topViewController:_dh_get_top_view_controller() completionHandler:comletionHandler];
    }else{
        printf("\n (-_-) Unhandled request: %s", request.description.UTF8String);
        if (_unHandleCallback) {
            _unHandleCallback(request,_dh_get_top_view_controller());
        }
    }
}

- (BOOL)canHandleRoutePath:(NSString *)routePath{
    if (0 == routePath.length) {
        return NO;
    }
    return YES;
}
@end
