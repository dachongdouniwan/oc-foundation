//
//  _annotation.h
//  kata
//
//  Created by fallen.ink on 12/03/2017.
//  Copyright © 2017 fallenink. All rights reserved.
//

#import "_precompile.h"

// ----------------------------------
// Macro code
// ----------------------------------

#undef  annotation_sectioname
#define annotation_sectioname "annotation.section"

#undef  meta_annotation_attr
#define meta_annotation_attr( _section_name_ ) __attribute((used, section("__DATA,"#_section_name_" ")))

#undef  meta_annotation
#define meta_annotation( _section_name_, _obj_name_) \
        char * _obj_name_##_obj meta_annotation_attr( _section_name_ ) = ""#_obj_name_;

#undef  meta_annotation_bind
#define meta_annotation_bind( _section_name_, _intf_name_, _impl_name_ ) \
        char * _intf_name_##_ meta_annotation_attr( _section_name_ ) = "{ \""#_intf_name_"\" : \""#_impl_name_"\"}";

#undef  annotation
#define annotation( _name_ ) meta_annotation( annotation_sectioname, _name_ )

#undef  annotation_bind
#define annotation_bind( _intf_name_, _impl_name_ ) \
        meta_annotation_bind(, _intf_name_, _impl_name_ )

// ----------------------------------
// Class code
// ----------------------------------

@interface _Annotation : NSObject

+ (NSArray <NSString *> *)annotationObjects; // Objects at section ##annotation_sectioname
+ (NSArray <NSString *> *)annotationBindings; // Bindings at section ##annotation_sectioname

+ (NSArray <NSString *> *)annotationObjectsForSectioname:(NSString *)sectioname;
+ (NSArray <NSString *> *)annotationBindingsForSectioname:(NSString *)sectioname;

@end
