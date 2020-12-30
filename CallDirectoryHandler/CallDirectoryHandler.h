//
//  CallDirectoryHandler.h
//  CallDirectoryHandler
//
//  Created by 오근택 on 2020/11/20.
//

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>
#import <YAJLO/NSObject+YAJL.h>
#import <YAJLO/YAJLDocument.h>
#import <YAJLO/YAJLGen.h>
#import <YAJLO/YAJLParser.h>


@interface CallDirectoryHandler : CXCallDirectoryProvider{
    int numberOfReadLines;
    int numberOfTotalLines;
    int currentPos;
    bool isOpenBefore;
    NSString * filePath;
    CXCallDirectoryExtensionContext * innerContext;
}


@end


