#ifndef __GF_TWEAK_H
#define __GF_TWEAK_H

#import <UIKit/UIKit.h>
#define kSetupCompleted @"GateToFreedomDidCompleteSetup"

// This is basically a UIAlertController that doesn't autorotate
@interface GFAlertController : UIAlertController
@end

#ifdef __cplusplus
extern "C" {
#endif

void GFDisableHooks(void);
void GFDeleteHelper(void);
BOOL GFChangeAccountPassword(NSString *accountName, NSString *newPassword);

#ifdef __cplusplus
}
#endif

#endif