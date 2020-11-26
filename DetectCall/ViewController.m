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
    
    [self sharingJsonDataToCallKit];
    
}

- (void) sharingJsonDataToCallKit{
    NSUserDefaults * userDefaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.geuntaek.DetectCall"];
    
    NSMutableArray * phoneBookDatas = [self loadJsonFile];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:phoneBookDatas];
    [userDefaults setObject:data forKey:@"dbData"];
    
}


-(NSMutableArray*) loadJsonFile{
    NSMutableArray<NSDictionary*> * dbData = [[NSMutableArray alloc] init];
    
    NSURL * file = [[NSBundle mainBundle] URLForResource:@"DBData" withExtension:@"json"];
    NSData * data = [[NSData alloc] initWithContentsOfURL:file];
    NSArray<NSDictionary*> *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    for(NSDictionary<NSNumber *, NSString *>* object in json){
        [dbData addObject:object];
    }
    return dbData;
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
