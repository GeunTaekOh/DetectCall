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

static bool dataChange = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    if(dataChange){
        file = [[NSBundle mainBundle] URLForResource:@"DBData" withExtension:@"json"];
        NSLog(@"DETECT // get DBData.json");
    }else{
        file = [[NSBundle mainBundle] URLForResource:@"DBData2" withExtension:@"json"];
        NSLog(@"DETECT // get DBData2.json");
    }
    
    NSData * data = [[NSData alloc] initWithContentsOfURL:file];
    NSArray<NSDictionary*> *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    for(NSDictionary<NSNumber *, NSString *>* object in json){
        [dbData addObject:object];
    }
    return dbData;
}

- (IBAction)clickBtn:(id)sender {
    CXCallDirectoryManager * manager = [CXCallDirectoryManager sharedInstance];
    
    [self sharingJsonDataToCallKit];
    
    dataChange = !dataChange;
    
    [manager reloadExtensionWithIdentifier:@"com.geuntaek.DetectCall.CallDirectoryHandler" completionHandler:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"DETECT // error : %@", [error localizedDescription]);
        }else{
            NSLog(@"DETECT // 성공");
        }
    }];
}

@end
