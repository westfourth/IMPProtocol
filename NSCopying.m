//
//  NSCopying.m
//  Markdown
//
//  Created by xisi on 2021/12/20.
//

#import "NSCopying.h"
#import "IMPProtocol.h"

@impprotocol(NSCopying)

- (id)copyWithZone:(NSZone *)zone {
    id instance = [[[self class] allocWithZone:zone] init];
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
        if ([value conformsToProtocol:@protocol(NSCopying)]) {
            if ([value isKindOfClass:[NSArray class]]) {
                value = [[NSMutableArray alloc] initWithArray:(NSArray *)value copyItems:YES];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                value = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)value copyItems:YES];
            } else {
                value = [value copy];
            }
        }
        [instance setValue:value forKey:key];
    }
    free(props);
    return instance;
}

@end
