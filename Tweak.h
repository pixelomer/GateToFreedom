#ifndef __GF_TWEAK_H
#define __GF_TWEAK_H

#import <UIKit/UIKit.h>

// This is basically a UIAlertController that doesn't autorotate
@interface GFAlertController : UIAlertController
@end

void GFDisableHooks(void);

#endif