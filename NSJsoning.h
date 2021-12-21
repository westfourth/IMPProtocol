//
//  NSJsoning.h
//  Markdown
//
//  Created by xisi on 2021/12/19.
//

#import <Foundation/Foundation.h>
#import "NSModeling.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NSJsoning <NSModeling>

- (nullable NSData *)toJsonData;

- (nullable NSString *)toJsonString;

- (void)fromJsonData:(NSData *)data;

- (void)fromJsonString:(NSString *)string;

- (void)fromJsonFile:(NSString *)filename inBundle:(nullable NSBundle *)bundle;

@end



//MARK: -   NSArray (NSJsoning)

@interface NSArray (NSJsoning)

- (nullable NSData *)toJsonData:(Class)cls;

- (nullable NSString *)toJsonString:(Class)cls;

- (nullable NSArray *)fromJsonData:(NSData *)data withClass:(Class)cls;

- (nullable NSArray *)fromJsonString:(NSString *)string withClass:(Class)cls;

- (nullable NSArray *)fromJsonFile:(NSString *)filename inBundle:(nullable NSBundle *)bundle withClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
