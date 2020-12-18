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
    NSLog(@"DETECT // insert data to user defaults start");
    [self printCurrentTime];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:phoneBookDatas];
    [userDefaults setObject:data forKey:@"dbData"];
    NSLog(@"DETECT // insert data to user defaults end");
    [self printCurrentTime];
}

-(NSMutableArray*) loadJsonFile{
    NSLog(@"DETECT // load json start");
    [self printCurrentTime];
    
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
    
    NSLog(@"DETECT // load json end");
    [self printCurrentTime];
    
    return dbData;
}

- (IBAction)clickBtn:(id)sender {
    CXCallDirectoryManager * manager = [CXCallDirectoryManager sharedInstance];
    
    //[self sharingJsonDataToCallKit];
    //[self insertFMDBToUserCallKit];
    
    //dataChange = !dataChange;
    
    NSLog(@"DETECT // call manager start");
    [self printCurrentTime];
    
    
    [manager reloadExtensionWithIdentifier:@"com.geuntaek.DetectCall.CallDirectoryHandler" completionHandler:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"DETECT // error VC : %@", [error localizedDescription]);
            
            
        }else{
            NSLog(@"DETECT // 성공");
            [self printCurrentTime];
        }
    }];
        
    
    
    
    NSLog(@"DETECT // call manager end");
    [self printCurrentTime];
}

-(void) printCurrentTime{
    NSDateFormatter * today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString * date = [today stringFromDate:[NSDate date]];
    NSLog(@"DETECT // date : %@",date);
}

@end
