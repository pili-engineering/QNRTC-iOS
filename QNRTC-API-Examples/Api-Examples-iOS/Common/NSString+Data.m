//
//  NSString+Data.m
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/26.
//

#import "NSString+Data.h"

@implementation NSString (Data)

+ (NSString *)base64DecodingString:(NSString *)string {
    NSInteger remainder = string.length % 4;
    NSMutableString *tmpString = [[NSMutableString alloc] initWithString:string];
    if (remainder > 0) {
        for (; remainder < 4; remainder++) {
            [tmpString appendString:@"="];
        }
    }
    NSData *data = [[NSData alloc]initWithBase64EncodedString:tmpString options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json string 解析失败：%@", err);
        return nil;
    }
    return dic;
}

@end
