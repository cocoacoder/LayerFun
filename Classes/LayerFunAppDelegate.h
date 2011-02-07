//
//  LayerFunAppDelegate.h
//  LayerFun
//
//  Created by Anonymous Apple Employee for Jim Hillhouse on 6/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LayerFunViewController4;

@interface LayerFunAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow				*window;
    UITabBarController		*viewController;
}

@property (nonatomic, retain)		IBOutlet		UIWindow *window;
@property (nonatomic, retain)		IBOutlet		UITabBarController *viewController;

@end

