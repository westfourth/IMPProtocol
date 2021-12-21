//
//  NSModeling.h
//  Markdown
//
//  Created by xisi on 2021/12/19.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NSModeling <NSObject>

//! 模型 --> 字典
- (nullable NSDictionary *)toDict;

//! 字典 --> 模型
- (void)fromDict:(NSDictionary *)dict;

@end



//MARK: -   NSArray (NSModeling)

@interface NSArray (NSModeling)

//! 模型数组 --> 字典数组
- (nullable NSArray *)toArray:(Class)cls;

//! 字典数组 --> 模型数组
- (nullable NSArray *)fromArray:(Class)cls;

@end

NS_ASSUME_NONNULL_END
