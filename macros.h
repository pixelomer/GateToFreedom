#ifndef __GF_MACROS_H
#define __GF_MACROS_H
#import <Foundation/Foundation.h>
#if DEBUG
#define NSLog(args...) NSLog(@"[GateToFreedom] "args)
#else
#define NSLog(...)
#endif
#endif