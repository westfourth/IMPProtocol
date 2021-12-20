//
//  NSJsoning.m
//  Markdown
//
//  Created by xisi on 2021/12/19.
//

#import "NSJsoning.h"
#import "IMPProtocol.h"

Class property_get_array_class(objc_property_t prop);
Class property_get_object_class(objc_property_t prop);
char *strsub(const char *s, char start, char end);


//MARK: -   NSJsoning

@impprotocol(NSJsoning)

- (nullable NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int count = 0;
    objc_property_t *props = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t prop = props[i];
        //  忽略readonly属性
        if (property_is_readonly(prop)) {
            continue;
        }

        const char *name = property_getName(prop);
        NSString *key = [NSString stringWithUTF8String:name];
        NSObject *value = [self valueForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            Class cls = property_get_array_class(prop);
            value = [(NSArray *)value modelsToArray:cls];
        } else if ([value conformsToProtocol:@protocol(NSJsoning)]) {
            value = [(id<NSJsoning>)value toDict];
        }
        dict[key] = value;
    }
    free(props);
    return dict;
}

- (void)fromDict:(NSDictionary *)dict {
    unsigned int count = 0;
    objc_property_t *props = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t prop = props[i];
        //  忽略readonly属性
        if (property_is_readonly(prop)) {
            continue;
        }

        const char *name = property_getName(prop);
        NSString *key = [NSString stringWithUTF8String:name];
        NSObject *value = dict[key];
        if ([value isKindOfClass:[NSArray class]]) {
            Class cls = property_get_array_class(prop);
            value = [(NSArray *)value arrayToModels:cls];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            Class cls = property_get_object_class(prop);
            if (class_conformsToProtocol(cls, @protocol(NSJsoning))) {
                id instance = [cls new];
                [instance fromDict:(NSDictionary *)value];
                value = instance;
            }
        }
        [self setValue:value forKey:key];
    }
    free(props);
}

- (nullable NSData *)toJSONData {
    NSDictionary *dict = [self toDict];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    return data;
}

- (void)fromJSONData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    [self fromDict:dict];
}

- (nullable NSString *)toJSONString {
    NSData *data = [self toJSONData];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (void)fromJSONString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self fromJSONData:data];
}

@end



//MARK: -   NSArray (NSJsoning)

@implementation NSArray (NSJsoning)

- (nullable NSArray *)modelsToArray:(Class)cls {
    NSMutableArray *array =  [NSMutableArray new];
    for (int i = 0; i < self.count; i++) {
        id value = self[i];
        if ([value conformsToProtocol:@protocol(NSJsoning)]) {
            value = [(id<NSJsoning>)value toDict];
        }
        [array addObject:value];
    }
    return array;
}

- (nullable NSArray *)arrayToModels:(Class)cls {
    NSMutableArray *array =  [NSMutableArray new];
    for (int i = 0; i < self.count; i++) {
        id object = [cls new];
        if (class_conformsToProtocol(cls, @protocol(NSJsoning))) {
            [object fromDict:(NSDictionary *)self[i]];
        }
        [array addObject:object];
    }
    return array;
}

@end



//MARK: -   基础函数

/**
    获取 @property (nonatomic) NSArray<SubTestObject *> <SubTestObject> *list; 结果为：<SubTestObject>中的 \c SubTestObject
 */
Class property_get_array_class(objc_property_t prop) {
    const char *v = property_copyAttributeValue(prop, "T");
    char *sub = strsub(v, '<', '>');
    Class cls = objc_getClass(sub);
    free(sub);
    return cls;
}

/**
    获取 @property (nonatomic) SubTestObject *sub 结果为：\c SubTestObject
 */
Class property_get_object_class(objc_property_t prop) {
    const char *v = property_copyAttributeValue(prop, "T");
    char *sub = strsub(v, '"', '"');
    Class cls = objc_getClass(sub);
    free(sub);
    return cls;
}

/**
    字符串截取，使用free()释放
    
    @param  start       顺序匹配上的第一个字符
    @param  end           倒序匹配上的第一个字符
    @return 子串为排除start、end字符的字符串
 */
char *strsub(const char *s, char start, char end) {
    int from = 0, to = 0;
    for (int i = 0; i < strlen(s); i++) {
        if (start == s[i]) {
            from = i;
            break;
        }
    }
    for (int i = (int)strlen(s) - 1; i >= 0; i--) {
        if (end == s[i]) {
            to = i;
            break;
        }
    }
    
    int len = to - from;
    if (len <= 0) {
        return NULL;
    }
    char *sub = malloc(sizeof(char) * len);
    for (int i = from + 1; i < to; i++) {
        sub[i - (from + 1)] = s[i];
    }
    sub[len - 1] = '\0';
    return sub;
}
