//
//  NSString+Data.h
//  Api-Examples-iOS
//
//  Created by 冯文秀 on 2022/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Data)
+ (NSString *)base64DecodingString:(NSString *)string;
+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
