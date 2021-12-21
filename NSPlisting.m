//
//  NSPlisting.m
//  Markdown
//
//  Created by xisi on 2021/12/19.
//

#import "NSPlisting.h"
#import "IMPProtocol.h"

//MARK: -   NSPlisting

@impprotocol(NSPlisting)

- (void)fromPListFile:(NSString *)filename inBundle:(nullable NSBundle *)bundle {
    bundle = bundle ? bundle : [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:filename ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    [self fromDict:dict];
}

@end


//MARK: -   NSArray (NSPlisting)

@implementation NSArray (NSPlisting)

- (nullable NSArray *)fromPListFile:(NSString *)filename inBundle:(nullable NSBundle *)bundle withClass:(Class)cls; {
    bundle = bundle ? bundle : [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:filename ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSArray *models = [array fromArray:cls];
    return models;
}

@end
