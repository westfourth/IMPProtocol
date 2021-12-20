//
//  IMPProtocol.m
//  Markdown
//
//  Created by xisi on 2021/12/19.
//

#import "IMPProtocol.h"

void protocol_add_default_method(Protocol *proto, Class protoCls, Class cls) {
    unsigned int count = 0;
    struct objc_method_description *descs = protocol_copyMethodDescriptionList(proto, YES, YES, &count);
    for (int j = 0; j < count; j++) {
        struct objc_method_description desc = descs[j];
        Method m = class_getInstanceMethod(protoCls, desc.name);
        IMP imp = method_getImplementation(m);
        class_addMethod(cls, desc.name, imp, desc.types);
    }
    free(descs);
}

/**
    时间代价：0.0035s / 万个class
 */
void protocol_find_conformed_class(Protocol *proto, Class protoCls) {
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (int i = 0; i < count; i++) {
        Class cls = classes[i];
        if (cls == protoCls) {
            continue;
        }
        if (class_conformsToProtocol(cls, proto)) {
            protocol_add_default_method(proto, protoCls, cls);
        }
    }
    free(classes);
}


/**
    判断property是否只读
 */
BOOL property_is_readonly(objc_property_t prop) {
    BOOL readonly = NO;
    unsigned int num = 0;
    objc_property_attribute_t *attrs = property_copyAttributeList(prop, &num);
    for (int j = 0; j < num; j++) {
        objc_property_attribute_t attr = attrs[j];
        if (strcmp(attr.name, "R") == 0) {
            readonly = YES;
            break;
        }
    }
    free(attrs);
    return readonly;
}
