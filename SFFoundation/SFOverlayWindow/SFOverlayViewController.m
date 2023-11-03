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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
    } else {
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }

    UIViewController *presentedViewController = self.presentedViewController;
    if (presentedViewController) {
        if (presentedViewController.isBeingDismissed || presentedViewController.isBeingPresented) {
            return UIInterfaceOrientationMaskPortrait;
        }

        UIInterfaceOrientationMask supportedInterfaceOrientations = presentedViewController.supportedInterfaceOrientations;
        if (supportedInterfaceOrientations > 0) {
            return supportedInterfaceOrientations;
        }
    }

    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        if (@available(iOS 13.0, *)) {
            return self.view.window.windowScene.interfaceOrientation;
        } else {
            return UIApplication.sharedApplication.statusBarOrientation;
        }
    }

    return UIInterfaceOrientationPortrait;
}

@end

#endif
