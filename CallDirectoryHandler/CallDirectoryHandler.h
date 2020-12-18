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


@interface CallDirectoryHandler : CXCallDirectoryProvider

@property (retain, nonatomic) NSMutableArray * phoneBookDatas;


@end


