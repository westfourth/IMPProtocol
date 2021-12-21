//
//  NSJsoning.m
//  Markdown
//
//  Created by xisi on 2021/12/19.
//

#import "NSJsoning.h"
#import "IMPProtocol.h"

//MARK: -   NSJsoning

@impprotocol(NSJsoning)

- (nullable NSData *)toJsonData {
    NSDictionary *dict = [self toDict];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    return data;
}

- (nullable NSString *)toJsonString {
    NSData *data = [self toJsonData];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (void)fromJsonData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    [self fromDict:dict];
}

- (void)fromJsonString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self fromJsonData:data];
}

- (void)fromJsonFile:(NSString *)filename inBundle:(nullable NSBundle *)bundle {
    bundle = bundle ? bundle : [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:filename ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self fromJsonData:data];
}

@end



//MARK: -   NSArray (NSJsoning)

@implementation NSArray (NSJsoning)

- (nullable NSData *)toJsonData:(Class)cls {
    NSArray *array = [self toArray:cls];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    return data;
}

- (nullable NSString *)toJsonString:(Class)cls {
    NSData *data = [self toJsonData:cls];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (nullable NSArray *)fromJsonData:(NSData *)data withClass:(Class)cls {
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSArray *models = [array fromArray:cls];
    return models;
}

- (nullable NSArray *)fromJsonString:(NSString *)string withClass:(Class)cls {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *models = [self fromJsonData:data withClass:cls];
    return models;
}

- (nullable NSArray *)fromJsonFile:(NSString *)filename inBundle:(nullable NSBundle *)bundle withClass:(Class)cls {
    bundle = bundle ? bundle : [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:filename ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *models = [self fromJsonData:data withClass:cls];
    return models;
}

@end
