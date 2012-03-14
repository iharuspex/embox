# Generated by Xpand using M2Make template.

# Meta model for 'myFile' package.

ifndef __mybuild_myfile_metamodel_mk
__mybuild_myfile_metamodel_mk := 1

include mk/model/metamodel_impl.mk

# Create meta objects.
MyFile := \
	$(call eMetaModelCreate,MyFile)

MyFile_FileContentRoot := \
	$(call eMetaClassCreate,$(MyFile),MyFile_FileContentRoot)
MyFile_FileContentRoot_types := \
	$(call eMetaReferenceCreate,$(MyFile_FileContentRoot),MyFile_FileContentRoot_types)
MyFile_FileContentRoot_imports := \
	$(call eMetaAttributeCreate,$(MyFile_FileContentRoot),MyFile_FileContentRoot_imports)

MyFile_Type := \
	$(call eMetaClassCreate,$(MyFile),MyFile_Type)
MyFile_Type_fileContentRoot := \
	$(call eMetaReferenceCreate,$(MyFile_Type),MyFile_Type_fileContentRoot)

MyFile_AnnotationType := \
	$(call eMetaClassCreate,$(MyFile),MyFile_AnnotationType)
MyFile_AnnotationType_options := \
	$(call eMetaReferenceCreate,$(MyFile_AnnotationType),MyFile_AnnotationType_options)

MyFile_Annotation := \
	$(call eMetaClassCreate,$(MyFile),MyFile_Annotation)
MyFile_Annotation_type := \
	$(call eMetaReferenceCreate,$(MyFile_Annotation),MyFile_Annotation_type)
MyFile_Annotation_target := \
	$(call eMetaReferenceCreate,$(MyFile_Annotation),MyFile_Annotation_target)

MyFile_AnnotationTarget := \
	$(call eMetaClassCreate,$(MyFile),MyFile_AnnotationTarget)
MyFile_AnnotationTarget_annotations := \
	$(call eMetaReferenceCreate,$(MyFile_AnnotationTarget),MyFile_AnnotationTarget_annotations)

MyFile_Interface := \
	$(call eMetaClassCreate,$(MyFile),MyFile_Interface)
MyFile_Interface_features := \
	$(call eMetaReferenceCreate,$(MyFile_Interface),MyFile_Interface_features)

MyFile_Feature := \
	$(call eMetaClassCreate,$(MyFile),MyFile_Feature)
MyFile_Feature_interface := \
	$(call eMetaReferenceCreate,$(MyFile_Feature),MyFile_Feature_interface)
MyFile_Feature_providedBy := \
	$(call eMetaReferenceCreate,$(MyFile_Feature),MyFile_Feature_providedBy)
MyFile_Feature_requiredBy := \
	$(call eMetaReferenceCreate,$(MyFile_Feature),MyFile_Feature_requiredBy)

MyFile_Module := \
	$(call eMetaClassCreate,$(MyFile),MyFile_Module)
MyFile_Module_modifiers := \
	$(call eMetaAttributeCreate,$(MyFile_Module),MyFile_Module_modifiers)
MyFile_Module_isStatic := \
	$(call eMetaAttributeCreate,$(MyFile_Module),MyFile_Module_isStatic)
MyFile_Module_isAbstract := \
	$(call eMetaAttributeCreate,$(MyFile_Module),MyFile_Module_isAbstract)
MyFile_Module_depends := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_depends)
MyFile_Module_dependent := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_dependent)
MyFile_Module_provides := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_provides)
MyFile_Module_requires := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_requires)
MyFile_Module_sources := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_sources)
MyFile_Module_objects := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_objects)
MyFile_Module_options := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_options)
MyFile_Module_subTypes := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_subTypes)
MyFile_Module_superType := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_superType)
MyFile_Module_allSubTypes := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_allSubTypes)
MyFile_Module_allSuperTypes := \
	$(call eMetaReferenceCreate,$(MyFile_Module),MyFile_Module_allSuperTypes)

MyFile_File := \
	$(call eMetaClassCreate,$(MyFile),MyFile_File)
MyFile_File_fileName := \
	$(call eMetaAttributeCreate,$(MyFile_File),MyFile_File_fileName)
MyFile_File_fileFullName := \
	$(call eMetaAttributeCreate,$(MyFile_File),MyFile_File_fileFullName)

MyFile_Option := \
	$(call eMetaClassCreate,$(MyFile),MyFile_Option)
MyFile_Option_defaultValue := \
	$(call eMetaReferenceCreate,$(MyFile_Option),MyFile_Option_defaultValue)

MyFile_StringOption := \
	$(call eMetaClassCreate,$(MyFile),MyFile_StringOption)

MyFile_NumberOption := \
	$(call eMetaClassCreate,$(MyFile),MyFile_NumberOption)

MyFile_OptionValue := \
	$(call eMetaClassCreate,$(MyFile),MyFile_OptionValue)
MyFile_OptionValue_value := \
	$(call eMetaAttributeCreate,$(MyFile_OptionValue),MyFile_OptionValue_value)

MyFile_StringOptionValue := \
	$(call eMetaClassCreate,$(MyFile),MyFile_StringOptionValue)

MyFile_NumberOptionValue := \
	$(call eMetaClassCreate,$(MyFile),MyFile_NumberOptionValue)

# Initializes the objects and relations between them.
define __myFile_init
	$(call eMetaModelInit,$(MyFile),myFile,my)

	$(call eMetaClassInit,$(MyFile_FileContentRoot),FileContentRoot,$(EModel_ENamedObject),)
	$(call eMetaReferenceInit,$(MyFile_FileContentRoot_types),types,$(MyFile_Type),$(MyFile_Type_fileContentRoot),changeable many containment)
	$(call eMetaAttributeInit,$(MyFile_FileContentRoot_imports),imports,changeable many)

	$(call eMetaClassInit,$(MyFile_Type),Type,$(EModel_ENamedObject) $(MyFile_AnnotationTarget),abstract)
	$(call eMetaReferenceInit,$(MyFile_Type_fileContentRoot),fileContentRoot,$(MyFile_FileContentRoot),$(MyFile_FileContentRoot_types),changeable container)

	$(call eMetaClassInit,$(MyFile_AnnotationType),AnnotationType,$(MyFile_Type),)
	$(call eMetaReferenceInit,$(MyFile_AnnotationType_options),options,$(MyFile_Option),,changeable many containment)

	$(call eMetaClassInit,$(MyFile_Annotation),Annotation,,)
	$(call eMetaReferenceInit,$(MyFile_Annotation_type),type,$(MyFile_AnnotationType),,changeable linkable)
	$(call eMetaReferenceInit,$(MyFile_Annotation_target),target,$(MyFile_AnnotationTarget),$(MyFile_AnnotationTarget_annotations),changeable container)

	$(call eMetaClassInit,$(MyFile_AnnotationTarget),AnnotationTarget,,abstract)
	$(call eMetaReferenceInit,$(MyFile_AnnotationTarget_annotations),annotations,$(MyFile_Annotation),$(MyFile_Annotation_target),changeable many containment)

	$(call eMetaClassInit,$(MyFile_Interface),Interface,$(MyFile_Type),)
	$(call eMetaReferenceInit,$(MyFile_Interface_features),features,$(MyFile_Feature),$(MyFile_Feature_interface),changeable many containment)

	$(call eMetaClassInit,$(MyFile_Feature),Feature,$(EModel_ENamedObject),)
	$(call eMetaReferenceInit,$(MyFile_Feature_interface),interface,$(MyFile_Interface),$(MyFile_Interface_features),changeable container)
	$(call eMetaReferenceInit,$(MyFile_Feature_providedBy),providedBy,$(MyFile_Module),$(MyFile_Module_provides),changeable many linkable)
	$(call eMetaReferenceInit,$(MyFile_Feature_requiredBy),requiredBy,$(MyFile_Module),$(MyFile_Module_requires),changeable many linkable)

	$(call eMetaClassInit,$(MyFile_Module),Module,$(MyFile_Type),)
	$(call eMetaAttributeInit,$(MyFile_Module_modifiers),modifiers,changeable)
	$(call eMetaAttributeInit,$(MyFile_Module_isStatic),static,changeable derived)
	$(call eMetaAttributeInit,$(MyFile_Module_isAbstract),abstract,changeable derived)
	$(call eMetaReferenceInit,$(MyFile_Module_depends),depends,$(MyFile_Module),$(MyFile_Module_dependent),changeable many linkable)
	$(call eMetaReferenceInit,$(MyFile_Module_dependent),dependent,$(MyFile_Module),$(MyFile_Module_depends),changeable many linkable)
	$(call eMetaReferenceInit,$(MyFile_Module_provides),provides,$(MyFile_Feature),$(MyFile_Feature_providedBy),changeable many linkable)
	$(call eMetaReferenceInit,$(MyFile_Module_requires),requires,$(MyFile_Feature),$(MyFile_Feature_requiredBy),changeable many linkable)
	$(call eMetaReferenceInit,$(MyFile_Module_sources),sources,$(MyFile_File),,changeable many containment)
	$(call eMetaReferenceInit,$(MyFile_Module_objects),objects,$(MyFile_File),,changeable many containment)
	$(call eMetaReferenceInit,$(MyFile_Module_options),options,$(MyFile_Option),,changeable many containment)
	$(call eMetaReferenceInit,$(MyFile_Module_subTypes),subTypes,$(MyFile_Module),$(MyFile_Module_superType),changeable many linkable)
	$(call eMetaReferenceInit,$(MyFile_Module_superType),superType,$(MyFile_Module),$(MyFile_Module_subTypes),changeable linkable)
	$(call eMetaReferenceInit,$(MyFile_Module_allSubTypes),allSubTypes,$(MyFile_Module),$(MyFile_Module_allSuperTypes),derived many)
	$(call eMetaReferenceInit,$(MyFile_Module_allSuperTypes),allSuperTypes,$(MyFile_Module),$(MyFile_Module_allSubTypes),derived many)

	$(call eMetaClassInit,$(MyFile_File),File,,)
	$(call eMetaAttributeInit,$(MyFile_File_fileName),fileName,changeable)
	$(call eMetaAttributeInit,$(MyFile_File_fileFullName),fileFullName,derived)

	$(call eMetaClassInit,$(MyFile_Option),Option,$(EModel_ENamedObject),abstract)
	$(call eMetaReferenceInit,$(MyFile_Option_defaultValue),defaultValue,$(MyFile_OptionValue),,changeable containment)

	$(call eMetaClassInit,$(MyFile_StringOption),StringOption,$(MyFile_Option),)

	$(call eMetaClassInit,$(MyFile_NumberOption),NumberOption,$(MyFile_Option),)

	$(call eMetaClassInit,$(MyFile_OptionValue),OptionValue,,abstract)
	$(call eMetaAttributeInit,$(MyFile_OptionValue_value),value,changeable)

	$(call eMetaClassInit,$(MyFile_StringOptionValue),StringOptionValue,$(MyFile_OptionValue),)

	$(call eMetaClassInit,$(MyFile_NumberOptionValue),NumberOptionValue,$(MyFile_OptionValue),)

endef # __myFile_init

# Binds objects to instance classes and features to properties.
define __myFile_bind
	$(call eMetaClassBind,$(MyFile_FileContentRoot),MyFileContentRoot)
	$(call eMetaFeatureBind,$(MyFile_FileContentRoot_types),types)
	$(call eMetaFeatureBind,$(MyFile_FileContentRoot_imports),imports)

	$(call eMetaClassBind,$(MyFile_Type),MyType)
	$(call eMetaFeatureBind,$(MyFile_Type_fileContentRoot),fileContentRoot)

	$(call eMetaClassBind,$(MyFile_AnnotationType),MyAnnotationType)
	$(call eMetaFeatureBind,$(MyFile_AnnotationType_options),options)

	$(call eMetaClassBind,$(MyFile_Annotation),MyAnnotation)
	$(call eMetaFeatureBind,$(MyFile_Annotation_type),type)
	$(call eMetaFeatureBind,$(MyFile_Annotation_target),target)

	$(call eMetaClassBind,$(MyFile_AnnotationTarget),MyAnnotationTarget)
	$(call eMetaFeatureBind,$(MyFile_AnnotationTarget_annotations),annotations)

	$(call eMetaClassBind,$(MyFile_Interface),MyInterface)
	$(call eMetaFeatureBind,$(MyFile_Interface_features),features)

	$(call eMetaClassBind,$(MyFile_Feature),MyFeature)
	$(call eMetaFeatureBind,$(MyFile_Feature_interface),interface)
	$(call eMetaFeatureBind,$(MyFile_Feature_providedBy),providedBy)
	$(call eMetaFeatureBind,$(MyFile_Feature_requiredBy),requiredBy)

	$(call eMetaClassBind,$(MyFile_Module),MyModule)
	$(call eMetaFeatureBind,$(MyFile_Module_modifiers),modifiers)
	$(call eMetaFeatureBind,$(MyFile_Module_isStatic),isStatic)
	$(call eMetaFeatureBind,$(MyFile_Module_isAbstract),isAbstract)
	$(call eMetaFeatureBind,$(MyFile_Module_depends),depends)
	$(call eMetaFeatureBind,$(MyFile_Module_dependent),dependent)
	$(call eMetaFeatureBind,$(MyFile_Module_provides),provides)
	$(call eMetaFeatureBind,$(MyFile_Module_requires),requires)
	$(call eMetaFeatureBind,$(MyFile_Module_sources),sources)
	$(call eMetaFeatureBind,$(MyFile_Module_objects),objects)
	$(call eMetaFeatureBind,$(MyFile_Module_options),options)
	$(call eMetaFeatureBind,$(MyFile_Module_subTypes),subTypes)
	$(call eMetaFeatureBind,$(MyFile_Module_superType),superType)
	$(call eMetaFeatureBind,$(MyFile_Module_allSubTypes),allSubTypes)
	$(call eMetaFeatureBind,$(MyFile_Module_allSuperTypes),allSuperTypes)

	$(call eMetaClassBind,$(MyFile_File),MyFile)
	$(call eMetaFeatureBind,$(MyFile_File_fileName),fileName)
	$(call eMetaFeatureBind,$(MyFile_File_fileFullName),fileFullName)

	$(call eMetaClassBind,$(MyFile_Option),MyOption)
	$(call eMetaFeatureBind,$(MyFile_Option_defaultValue),defaultValue)

	$(call eMetaClassBind,$(MyFile_StringOption),MyStringOption)

	$(call eMetaClassBind,$(MyFile_NumberOption),MyNumberOption)

	$(call eMetaClassBind,$(MyFile_OptionValue),MyOptionValue)
	$(call eMetaFeatureBind,$(MyFile_OptionValue_value),value)

	$(call eMetaClassBind,$(MyFile_StringOptionValue),MyStringOptionValue)

	$(call eMetaClassBind,$(MyFile_NumberOptionValue),MyNumberOptionValue)

endef # __myFile_bind

$(def_all)

$(call __myFile_init)
$(call __myFile_bind)

$(call eMetaModelFreeze,$(MyFile))

endif # __mybuild_myfile_metamodel_mk

