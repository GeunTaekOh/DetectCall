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

    // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
    // and identification entries which have been added or removed since the last time this extension's data was loaded.
    // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
    // and identification phone numbers if the request is not incremental.
    NSLog(@"DETECT // [begin Request With Extension Context]]");
    [self addAllIdentificationPhoneNumbersToContext:context];
//    [self addAllBlockingPhoneNumbersToContext:context];
//
//    [self addAllIdentificationPhoneNumbersToContext:context];
//
//    if (context.isIncremental) {
//        NSLog(@"DETECT // isIncremental true");
//        [self addOrRemoveIncrementalBlockingPhoneNumbersToContext:context];
//
//        [self addOrRemoveIncrementalIdentificationPhoneNumbersToContext:context];
//    } else {
//        NSLog(@"DETECT // isIncremental false");
//        [self addAllBlockingPhoneNumbersToContext:context];
//
//        [self addAllIdentificationPhoneNumbersToContext:context];
//    }
////
    [context completeRequestWithCompletionHandler:nil];
}

- (void)addAllBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    
    
    
    NSLog(@"DETECT // [add All Blocking PhoneNumbers To Context]");
    
    CXCallDirectoryPhoneNumber allPhoneNumbers[] = { 14085555555, 18005555555 };
    NSUInteger count = (sizeof(allPhoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
    for (NSUInteger index = 0; index < count; index += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = allPhoneNumbers[index];
        NSLog(@"DETECT // phone : %lld", phoneNumber);
        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    }
}

- (void)addOrRemoveIncrementalBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    
    NSLog(@"DETECT // [add Or Remove Incremental Blocking PhoneNumbers To Context]");
    
    CXCallDirectoryPhoneNumber phoneNumbersToAdd[] = { 14085551234 };
    NSUInteger countOfPhoneNumbersToAdd = (sizeof(phoneNumbersToAdd) / sizeof(CXCallDirectoryPhoneNumber));

    for (NSUInteger index = 0; index < countOfPhoneNumbersToAdd; index += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToAdd[index];
        NSLog(@"DETECT // phone : %lld", phoneNumber);
        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    }

    CXCallDirectoryPhoneNumber phoneNumbersToRemove[] = { 18005555555 };
    NSUInteger countOfPhoneNumbersToRemove = (sizeof(phoneNumbersToRemove) / sizeof(CXCallDirectoryPhoneNumber));
    for (NSUInteger index = 0; index < countOfPhoneNumbersToRemove; index += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToRemove[index];
        NSLog(@"DETECT // phone : %lld", phoneNumber);
        [context removeBlockingEntryWithPhoneNumber:phoneNumber];
    }

    // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
}

- (void)addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    NSLog(@"DETECT // [add All Identification PhoneNumbers To Context]");
//    CXCallDirectoryPhoneNumber allPhoneNumbers[] = { 821054947694, 821067454412, 821076202711, 821077639375, 821082859212, 821090926572, };
//
//    NSArray<NSString *> *labels = @[ @"니지팸 정동제", @"그룹웨어기술팀 오근택 책임",@"손이가 전연희 대리", @"경영지원시스템실 신연수 책임",@"니지팸 꼬르", @"그룹웨어기술팀 최종윤 책임" ];
//    NSUInteger count = (sizeof(allPhoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
//    for (NSUInteger i = 0; i < count; i += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = allPhoneNumbers[i];
//        NSString *label = labels[i];
//        NSLog(@"DETECT // phone : %lld", phoneNumber);
//        NSLog(@"DETECT // label : %@", label);
//        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
//    }
    //context.inputItems
    
    NSLog(@"DETECT // context input items : %@",context.inputItems.description);
    
    NSDictionary<NSNumber *, NSString *> *labelsKeyedByPhoneNumber = @{
        @821077639375:@"경영지원시스템실 신연수 책임",
        @821082859212:@"니지팸 꼬르",
        @821090926572:@"그룹웨어기술팀 최종윤 책임",
        @821054947694:@"니지팸 정동제",
        @821067454412:@"그룹웨어기술팀 오근택 책임",
        @821076202711:@"손이가 전연희 대리"
    };
        for (NSNumber *phoneNumber in [labelsKeyedByPhoneNumber.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
            
           NSString *label = labelsKeyedByPhoneNumber[phoneNumber];
            NSLog(@"DETECT // phone : %@", phoneNumber);
            NSLog(@"DETECT // label : %@", label);
            
           [context addIdentificationEntryWithNextSequentialPhoneNumber:(CXCallDirectoryPhoneNumber)[phoneNumber unsignedLongLongValue] label:label];
        }
    
    
}

- (void)addOrRemoveIncrementalIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve any changes to the set of phone numbers to identify (and their identification labels) from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    
    NSLog(@"DETECT // [add Or Remove Incremental Identification PhoneNumbers To Context]");
    
//    CXCallDirectoryPhoneNumber phoneNumbersToAdd[] = { 14085555678 };
//    NSArray<NSString *> *labelsToAdd = @[ @"New local business" ];
    
    CXCallDirectoryPhoneNumber phoneNumbersToAdd[] = { 821054947694, 821067454412, 821076202711, 821077639375, 821082859212, 821090926572, };
    NSArray<NSString *> *labelsToAdd = @[ @"니지팸 정동제", @"그룹웨어기술팀 오근택 책임", @"손이가 전연희 대리", @"경영지원시스템실 신연수 책임",@"니지팸 꼬르", @"그룹웨어기술팀 최종윤 책임" ];
    
    NSUInteger countOfPhoneNumbersToAdd = (sizeof(phoneNumbersToAdd) / sizeof(CXCallDirectoryPhoneNumber));

    for (NSUInteger i = 0; i < countOfPhoneNumbersToAdd; i += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToAdd[i];
        NSString *label = labelsToAdd[i];
        NSLog(@"DETECT // phone : %lld", phoneNumber);
        NSLog(@"DETECT // label : %@", label);
        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
    }

    CXCallDirectoryPhoneNumber phoneNumbersToRemove[] = { 18885555555 };
    NSUInteger countOfPhoneNumbersToRemove = (sizeof(phoneNumbersToRemove) / sizeof(CXCallDirectoryPhoneNumber));

    for (NSUInteger i = 0; i < countOfPhoneNumbersToRemove; i += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbersToRemove[i];
        [context removeIdentificationEntryWithPhoneNumber:phoneNumber];
    }

    // Record the most-recently loaded set of identification entries in data store for the next incremental load...
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occurred while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
    NSLog(@"DETECT // [request Failed For ExtensionContext]");
    NSLog(@"DETECT // Log : %@", [error description]);
}

@end
