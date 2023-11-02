//
//  SFOverlayViewController.m
//  SFFoundation
//
//  Created by vvveiii on 2019/6/17.
//  Copyright © 2019 lvv. All rights reserved.
//
#if SF_IOS

#import "SFOverlayViewController.h"
#import "SFOverlayWindow.h"
#import "UIViewController+SFOverlayWindow.h"

@interface SFOverlayViewController ()

@end

@implementation SFOverlayViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (!self.mainWindow.rootViewController) {
        return UIStatusBarStyleDefault;
    }

    return self.mainWindow.rootViewController.sf_topPreferredStatusBarStyle;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    __weak typeof(self) wself = self;
    [super dismissViewControllerAnimated:flag completion:^{
        if (completion) {
            completion();
        }

        if (!wself.presentedViewController) {
            [wself.rootWindow destory];
        }
    }];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }

    UIViewController *presentedViewController = self.presentedViewController;
    if (!presentedViewController) {
        return UIInterfaceOrientationMaskPortrait;
    }

    UIInterfaceOrientationMask supportedInterfaceOrientations = presentedViewController.supportedInterfaceOrientations;
    if (supportedInterfaceOrientations == 0) {
        return UIInterfaceOrientationMaskPortrait;
    }

    if (presentedViewController.isBeingDismissed) {
        return UIInterfaceOrientationMaskPortrait;
    }

    return supportedInterfaceOrientations;
}

@end

#endif
