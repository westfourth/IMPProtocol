//
//  NSJsoning.h
//  Markdown
//
//  Created by xisi on 2021/12/19.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NSJsoning <NSObject>

- (nullable NSDictionary *)toDict;

- (void)fromDict:(NSDictionary *)dict;

- (nullable NSData *)toJSONData;

- (void)fromJSONData:(NSData *)data;

- (nullable NSString *)toJSONString;

- (void)fromJSONString:(NSString *)string;

@end



//MARK: -   NSArray (NSJsoning)

@interface NSArray (NSJsoning)

- (nullable NSArray *)modelsToArray:(Class)cls;

- (nullable NSArray *)arrayToModels:(Class)cls;

@end

NS_ASSUME_NONNULL_END
