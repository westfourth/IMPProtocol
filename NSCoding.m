//
//  NSCoding.m
//  Markdown
//
//  Created by xisi on 2021/12/20.
//

#import "NSCoding.h"
#import "IMPProtocol.h"

@impprotocol(NSCoding)

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
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
            NSObject *value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(props);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
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
        [coder encodeObject:value forKey:key];
    }
    free(props);
}

@end
