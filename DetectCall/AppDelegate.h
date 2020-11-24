//
//  AppDelegate.h
//  DetectCall
//
//  Created by 오근택 on 2020/11/20.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CallKit/CallKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) UIWindow *window;
- (void)saveContext;


@end

