#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSObject+YAJL.h"
#import "YAJLDocument.h"
#import "YAJLGen.h"
#import "YAJLParser.h"

FOUNDATION_EXPORT double YAJLOVersionNumber;
FOUNDATION_EXPORT const unsigned char YAJLOVersionString[];

