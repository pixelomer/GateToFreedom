#ifndef __GF_MACROS_H
#define __GF_MACROS_H
#import <Foundation/Foundation.h>
#import <Tweak.h>
#define LC(key) [GFGetBundle() localizedStringForKey:key value:nil table:nil]
#define NSLog(args...) NSLog(@"[GateToFreedom] "args)
#endif