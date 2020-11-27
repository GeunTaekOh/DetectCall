//
//  CallDirectoryHandler.m
//  CallDirectoryHandler
//
//  Created by 오근택 on 2020/11/20.
//

#import "CallDirectoryHandler.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    NSLog(@"DETECT // [begin Request With Extension Context]]");
    [self addAllIdentificationPhoneNumbersToContext:context];

    [context completeRequestWithCompletionHandler:nil];
}

- (void)addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {

    NSLog(@"DETECT // [add All Identification PhoneNumbers To Context]");

    NSUserDefaults * userDefaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.geuntaek.DetectCall"];
    
    NSMutableDictionary<NSNumber *, NSString *> *labelsKeyedByPhoneNumber = [[NSMutableDictionary alloc] init];
    
    NSData * data = [userDefaults objectForKey:@"dbData"];
    
    NSArray * dbData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    for (NSDictionary * data in dbData){
        NSString * name = [data objectForKey:@"name"];
        NSNumber * num = [data objectForKey:@"phoneNumber"];
        [labelsKeyedByPhoneNumber setObject:name forKey:num];
    }
    
    for(NSNumber * phoneNumber in [labelsKeyedByPhoneNumber.allKeys sortedArrayUsingSelector:@selector(compare:)]){
        
        NSString * label = labelsKeyedByPhoneNumber[phoneNumber];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * myNumber = [f numberFromString:phoneNumber];
        
        [context addIdentificationEntryWithNextSequentialPhoneNumber:(CXCallDirectoryPhoneNumber)[myNumber unsignedLongLongValue] label:label];
    }
}


#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    
    NSLog(@"DETECT // [request Failed For ExtensionContext]");
    NSLog(@"DETECT // Log : %@", [error description]);
}

@end
