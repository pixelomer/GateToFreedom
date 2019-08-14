#ifndef __GF_TWEAK_H
#define __GF_TWEAK_H

#import <UIKit/UIKit.h>
#define kSetupCompleted @"GateToFreedomDidCompleteSetup"

// This is basically a UIAlertController that doesn't autorotate
@interface GFAlertController : UIAlertController
@end

void GFDisableHooks(void);
NSBundle *GFGetBundle(void);
void GFDeleteHelper(void);
NSString *GFChangeAccountPassword(NSString *accountName, NSString *newPassword);

#endif