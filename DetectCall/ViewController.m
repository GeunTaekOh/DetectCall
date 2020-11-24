//
//  ViewController.m
//  DetectCall
//
//  Created by 오근택 on 2020/11/20.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
}

- (IBAction)clickBtn:(id)sender {
    CXCallDirectoryManager * manager = [CXCallDirectoryManager sharedInstance];
    
    [manager reloadExtensionWithIdentifier:@"com.geuntaek.DetectCall.CallDirectoryHandler" completionHandler:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"DETECT // error : %@", [error localizedDescription]);
        }else{
            NSLog(@"DETECT // 성공");
        }
    }];
}

@end
