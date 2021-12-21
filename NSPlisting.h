//
//  NSPlisting.h
//  Markdown
//
//  Created by xisi on 2021/12/19.
//

#import <Foundation/Foundation.h>
#import "NSModeling.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NSPlisting <NSModeling>

- (void)fromPListFile:(NSString *)filename inBundle:(nullable NSBundle *)bundle;

@end



//MARK: -   NSArray (NSPlisting)

@interface NSArray (NSPlisting)

- (nullable NSArray *)fromPListFile:(NSString *)filename inBundle:(nullable NSBundle *)bundle withClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
