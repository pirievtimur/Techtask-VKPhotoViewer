//
//  PVLoginViewController.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/11/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "PVLoginViewController.h"
#import "UIAlertController+Additions.h"
#import "PVAlbumsTableViewController.h"
#import "MBProgressHUD.h"

static NSArray *permissions = nil;
static NSString *appId = @"5723402";

@implementation PVLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    permissions = @[VK_PER_PHOTOS];
    [[VKSdk initializeWithAppId:appId] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:permissions completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self.navigationController pushViewController:[PVAlbumsTableViewController newInstance] animated:true];
        } else if (error) {
            [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:@"Fail to authorize"] animated:true completion:nil];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [self.navigationController setToolbarHidden:true];
}

//MARK: - IBAction

- (IBAction)onButtonClickLogin:(id)sender {
    [VKSdk authorize:permissions];
}

//MARK: - VkSDKDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self.navigationController pushViewController:[PVAlbumsTableViewController newInstance] animated:true];
    } else if (result.error) {
         [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:@"Fail to authorize"] animated:true completion:nil];
       // [self presentViewController:[self alertViewControllerWithTitle:@"Error" message:@"Fail to authorize"] animated:true completion:nil];
    }
}

- (void)vkSdkUserAuthorizationFailed {
     [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:@"Fail to authorize"] animated:true completion:nil];
   // [self presentViewController:[self alertViewControllerWithTitle:@"Error" message:@"Fail to authorize"] animated:true completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//MARK: - VKSdkUIDelegate

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

@end
