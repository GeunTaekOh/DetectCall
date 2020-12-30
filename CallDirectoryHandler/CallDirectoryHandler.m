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
    
    numberOfReadLines = 5000;

    NSLog(@"DETECT // [begin Request With Extension Context]]");

    [self printCurrentTime];
    
    [self addAllIdentificationPhoneNumbersToContext:context];

    [context completeRequestWithCompletionHandler:nil];
    
    NSLog(@"DETECT // beginRequestWithExtensionContext end");
    [self printCurrentTime];
    
}


- (void)addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {

    NSLog(@"DETECT // [add All Identification PhoneNumbers To Context]");

    innerContext = context;
    
    if(!isOpenBefore){
        NSLog(@"DETECT // now first open");
        isOpenBefore = true;
        
        
        
        filePath = [[NSBundle mainBundle] pathForResource:@"DBData" ofType:@"json"];
        numberOfTotalLines = [self countFileTotalLines:filePath];
        
        NSLog(@"DETECT // total line : %d",numberOfTotalLines);
        
        [self addAllIdentificationPhoneNumbersToContext:context];
        
    }else{
        
        NSLog(@"DETECT // more than second loop");
        
        FILE *file = fopen([filePath UTF8String], "r");
        
        char buffer[256];
        int iter = 0;
        
        NSString * string = [[NSString alloc] init];
        id json = nil;
        NSString * name = [[NSString alloc] init];
        NSString * num = [[NSString alloc] init];
        NSNumber * myNumber = [[NSNumber alloc] init];
        
        @try{
            while ((fgets(buffer, 256, file) != NULL) && currentPos < numberOfReadLines){
        
                if(iter < currentPos){    //iter 는 cursor 느낌. currentpos 는 지금까지 읽은 데이터.
                    iter +=1 ;
                    //NSLog(@"DETECT // ==== empty : %d ====== ", iter);
                    continue;
                }else{
                    
                    if(iter > 4950 || currentPos > 4950){
                        NSLog(@"DETECT // current pos : %d",currentPos );
                        NSLog(@"DETECT // iter : %d",iter );
                        NSLog(@"DETECT // numberOfReadLines : %d", numberOfReadLines);
                    }
                    
                    iter += 1;
                    currentPos += 1;

                    string = [NSString stringWithUTF8String:buffer];
                    string = [self parseString:string];
            
                    json = [self stringToJson:string];
            
                    name = [json objectForKey:@"name"];
                    num = [json objectForKey:@"phoneNumber"];
            
                    myNumber = [self stringToNumber:num];
            
                    if(iter % 100 == 0){
                        NSLog(@"DETECT // number : %@ // label : %@ // ", [myNumber stringValue], name);
                    }
                        // 실제 값을 확장된 전화번호에 입력
                    [innerContext addIdentificationEntryWithNextSequentialPhoneNumber:(CXCallDirectoryPhoneNumber)[myNumber  unsignedLongLongValue] label:name];
            
                    string = @"";
                    name = @"";
                    num = @"";
                    myNumber = [[NSNumber alloc] init];
            
                    
                }
            }
            
            numberOfReadLines *= 2;
            
            if(currentPos < numberOfTotalLines){
                //[self logic];
                //addAllIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
                [self addAllIdentificationPhoneNumbersToContext:context];
            }
            
        }@catch(NSException * e){
            NSLog(@"DETECT // error - try - catch : %@ // %@ ", [e name], [e reason]);
        }@finally{
            NSLog(@"DETECT // finally ");
        }
    }
    
    
    
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

- (int) countFileTotalLines:(NSString *)filePath{
    
    FILE *file = fopen([filePath UTF8String], "r");

    char buffer[256];
    int count = 0;
    
    while (fgets(buffer, 256, file) != NULL){
        count+=1;
    }
    
    return count;
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
