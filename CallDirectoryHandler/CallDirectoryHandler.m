//
//  CallDirectoryHandler.m
//  CallDirectoryHandler
//
//  Created by 오근택 on 2020/11/20.
//

#import "CallDirectoryHandler.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate, YAJLParserDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    NSLog(@"DETECT // [begin Request With Extension Context]]");

    [self printCurrentTime];
    
    //_phoneBookDatas = [self loadJsonFile];
    //NSLog(@"DETECT // phonebook datas : %@",_phoneBookDatas);
    
    [self addAllIdentificationPhoneNumbersToContext:context];

    [context completeRequestWithCompletionHandler:nil];
    
    NSLog(@"DETECT // beginRequestWithExtensionContext end");
    [self printCurrentTime];
    
}

- (void)addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {

    NSLog(@"DETECT // [add All Identification PhoneNumbers To Context]");
    [self printCurrentTime];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DBData" ofType:@"json"];
    FILE *file = fopen([filePath UTF8String], "r");
    char buffer[256];
    int count = 0;
    
    @try{
        while (fgets(buffer, 256, file) != NULL){
            
            count += 1;
                
            NSString* string = [NSString stringWithUTF8String:buffer];
            string = [self parseString:string];
            
            id json = [self stringToJson:string];
            
            NSString * name = [json objectForKey:@"name"];
            NSString * num = [json objectForKey:@"phoneNumber"];
        
            NSNumber * myNumber = [self stringToNumber:num];
            
            if(count % 1000 == 0){
                NSLog(@"DETECT // number : %@ // label : %@ // ", [myNumber stringValue], name);
            }
            
            // 실제 값을 확장된 전화번호에 입력
            [context addIdentificationEntryWithNextSequentialPhoneNumber:(CXCallDirectoryPhoneNumber)[myNumber  unsignedLongLongValue] label:name];
            
            
        }
    }@catch(NSException * e){
        NSLog(@"DETECT // error - try - catch : %@ // %@ ", [e name], [e reason]);
    }@finally{
        NSLog(@"DETECT // finally ");
    }
       
    [self printCurrentTime];
    
    
//
//
//
//
//    NSUserDefaults * userDefaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.geuntaek.DetectCall"];
//
//    NSMutableDictionary<NSNumber *, NSString *> *labelsKeyedByPhoneNumber = [[NSMutableDictionary alloc] init];
//    NSData * data = [userDefaults objectForKey:@"dbData"];
//    NSArray * dbData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//
//    NSLog(@"DETECT // _phone book data : %@",_phoneBookDatas);
//
//    for (NSDictionary * data in _phoneBookDatas){
//        NSString * name = [data objectForKey:@"name"];
//        NSNumber * num = [data objectForKey:@"phoneNumber"];
//        [labelsKeyedByPhoneNumber setObject:name forKey:num];
//    }
////    NSLog(@"DETECT // sort data start");
////    [self printCurrentTime];
//    for(NSNumber * phoneNumber in [labelsKeyedByPhoneNumber.allKeys sortedArrayUsingSelector:@selector(compare:)]){
//
//        NSString * label = labelsKeyedByPhoneNumber[phoneNumber];
//        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//        f.numberStyle = NSNumberFormatterDecimalStyle;
//        NSNumber * myNumber = [f numberFromString:phoneNumber];
//        NSLog(@"DETECT // number : %@ // label : %@ // ", [myNumber stringValue], label);
//        [context addIdentificationEntryWithNextSequentialPhoneNumber:(CXCallDirectoryPhoneNumber)[myNumber unsignedLongLongValue] label:label];
//    }
//    NSLog(@"DETECT // sort data end");
//    [self printCurrentTime];
}


#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    NSLog(@"DETECT // [request Failed For ExtensionContext]");
    NSLog(@"DETECT // Log : %@", [error description]);
}

-(void) printCurrentTime{
    NSDateFormatter * today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString * date = [today stringFromDate:[NSDate date]];
    NSLog(@"DETECT // date : %@",date);
}

-(NSString*) parseString:(NSString*)str{
    
    NSString * result = [[NSString alloc] initWithString:str];
    
    result = [result stringByReplacingOccurrencesOfString:@"[" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    NSRange strRange = [result rangeOfString:@"}"];
    result = [result substringToIndex:strRange.location + 1];
    
    return result;
}

-(id) stringToJson:(NSString *) str{
    
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if(error != nil){
        NSLog(@"DETECT // string to json error log : %@",[error description]);
    }
    return json;
}

-(NSNumber *) stringToNumber:(NSString *) numStr{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * result = [f numberFromString:numStr];
    
    return result;
}



//-(NSMutableArray*) loadJsonFile{
//    NSLog(@"DETECT // load json start");
//    [self printCurrentTime];
//
//    NSMutableArray<NSDictionary*> * dbData = [[NSMutableArray alloc] init];
//
//    NSURL * file = [[NSBundle mainBundle] URLForResource:@"DBData" withExtension:@"json"];
//    NSLog(@"DETECT // file : %@", [file description]);
//
//    //NSData * data = [[NSData alloc] initWithContentsOfURL:file];
//
//    __block NSArray<NSDictionary*> *jsonData = [[NSArray alloc] init];
//
//
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//            // 작업이 오래 걸리는 API를 백그라운드 스레드에서 실행한다.
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DBData" ofType:@"json"];
//        NSLog(@"DETECT // file path : %@", filePath);
//        NSError *error = nil;
//
//
//
//        NSData * data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways | NSDataReadingMappedAlways error:&error];
//
//        if(error != nil){
//            NSLog(@"DETECT // error - file to data : %@",[error description]);
//            error = nil;
//        }
//
//
//        NSLog(@"DETECT // data : %@", [data description]);
//        NSArray<NSDictionary*> *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//
//        if(error != nil){
//            NSLog(@"DETECT // data to json : %@",[error description]);
//            error = nil;
//        }
//
//
//
//
//        NSLog(@"DETECT // json : %@",json);
//        jsonData = json;
//
//
//        });
//
//
////    YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:YAJLParserOptionsAllowComments];
////    parser.delegate = self;
////    [parser parse:data];
////    parser.delegate = nil;
////    if (parser.parserError) {
////      NSLog(@"DETECT // Error:\n%@", parser.parserError);
////    }
////
////    parser = nil;
////
////
////
//
//    for(NSDictionary<NSNumber *, NSString *>* object in jsonData){
//        NSLog(@"DETECT // in // object : %@",object);
//        [dbData addObject:object];
//    }
//
//    NSLog(@"DETECT // load json end");
//    [self printCurrentTime];
//
//    return dbData;
//}

//
//- (void)parserDidStartDictionary:(YAJLParser *)parser {
////    NSLog(@"DETECT // parserDidStartDictionary");
////    NSLog(@"DETECTG // parser : %@",[parser description]);
//}
//- (void)parserDidEndDictionary:(YAJLParser *)parser {
////    NSLog(@"DETECT // parserDidStartDictionary");
////    NSLog(@"DETECTG // parser : %@",[parser description]);
//}
//
//- (void)parserDidStartArray:(YAJLParser *)parser {
////    NSLog(@"DETECT // parserDidStartArray");
////    NSLog(@"DETECTG // parser : %@",[parser description]);
//}
//- (void)parserDidEndArray:(YAJLParser *)parser {
////    NSLog(@"DETECT // parserDidEndArray");
////    NSLog(@"DETECTG // parser : %@",[parser description]);
//}
//
//- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key {
////    NSLog(@"DETECT // didMapKey");
////    NSLog(@"DETECTG // parser : %@",[parser description]);
//}
//- (void)parser:(YAJLParser *)parser didAdd:(id)value {
////    NSLog(@"DETECT // didAdd");
////    NSLog(@"DETECTG // parser : %@",[parser description]);
//}



@end
