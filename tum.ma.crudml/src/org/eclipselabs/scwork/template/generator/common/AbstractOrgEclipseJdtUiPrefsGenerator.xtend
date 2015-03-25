package org.eclipselabs.scwork.template.generator.common

import org.eclipselabs.scwork.template.InputParam
import org.eclipselabs.scwork.template.generator.ITextFileGenerator

abstract class AbstractOrgEclipseJdtUiPrefsGenerator implements ITextFileGenerator {
	
	def subFilePath() {
		#[".settings", "org.eclipse.jdt.ui.prefs"]
	}
	
	override provideContent(InputParam param) 
'''
cleanup.add_default_serial_version_id=true
cleanup.add_generated_serial_version_id=false
cleanup.add_missing_annotations=true
cleanup.add_missing_deprecated_annotations=false
cleanup.add_missing_methods=false
cleanup.add_missing_nls_tags=false
cleanup.add_missing_override_annotations=true
cleanup.add_serial_version_id=false
cleanup.always_use_blocks=true
cleanup.always_use_parentheses_in_expressions=false
cleanup.always_use_this_for_non_static_field_access=false
cleanup.always_use_this_for_non_static_method_access=false
cleanup.convert_to_enhanced_for_loop=false
cleanup.correct_indentation=true
cleanup.format_source_code=true
cleanup.format_source_code_changes_only=false
cleanup.make_local_variable_final=true
cleanup.make_parameters_final=false
cleanup.make_private_fields_final=true
cleanup.make_type_abstract_if_missing_method=false
cleanup.make_variable_declarations_final=false
cleanup.never_use_blocks=false
cleanup.never_use_parentheses_in_expressions=true
cleanup.organize_imports=true
cleanup.qualify_static_field_accesses_with_declaring_class=false
cleanup.qualify_static_member_accesses_through_instances_with_declaring_class=true
cleanup.qualify_static_member_accesses_through_subtypes_with_declaring_class=false
cleanup.qualify_static_member_accesses_with_declaring_class=false
cleanup.qualify_static_method_accesses_with_declaring_class=false
cleanup.remove_private_constructors=false
cleanup.remove_trailing_whitespaces=true
cleanup.remove_trailing_whitespaces_all=true
cleanup.remove_trailing_whitespaces_ignore_empty=false
cleanup.remove_unnecessary_casts=false
cleanup.remove_unnecessary_nls_tags=false
cleanup.remove_unused_imports=true
cleanup.remove_unused_local_variables=false
cleanup.remove_unused_private_fields=true
cleanup.remove_unused_private_members=false
cleanup.remove_unused_private_methods=true
cleanup.remove_unused_private_types=true
cleanup.sort_members=false
cleanup.sort_members_all=false
cleanup.use_blocks=false
cleanup.use_blocks_only_for_return_and_throw=false
cleanup.use_parentheses_in_expressions=false
cleanup.use_this_for_non_static_field_access=false
cleanup.use_this_for_non_static_field_access_only_if_necessary=true
cleanup.use_this_for_non_static_method_access=false
cleanup.use_this_for_non_static_method_access_only_if_necessary=true
cleanup_settings_version=2
eclipse.preferences.version=1
editor_save_participant_org.eclipse.jdt.ui.postsavelistener.cleanup=true
org.eclipse.jdt.ui.exception.name=e
org.eclipse.jdt.ui.gettersetter.use.is=true
org.eclipse.jdt.ui.javadoc=true
org.eclipse.jdt.ui.keywordthis=false
org.eclipse.jdt.ui.overrideannotation=true
sp_cleanup.add_default_serial_version_id=true
sp_cleanup.add_generated_serial_version_id=false
sp_cleanup.add_missing_annotations=false
sp_cleanup.add_missing_deprecated_annotations=false
sp_cleanup.add_missing_methods=false
sp_cleanup.add_missing_nls_tags=false
sp_cleanup.add_missing_override_annotations=false
sp_cleanup.add_missing_override_annotations_interface_methods=true
sp_cleanup.add_serial_version_id=false
sp_cleanup.always_use_blocks=false
sp_cleanup.always_use_parentheses_in_expressions=false
sp_cleanup.always_use_this_for_non_static_field_access=false
sp_cleanup.always_use_this_for_non_static_method_access=false
sp_cleanup.convert_to_enhanced_for_loop=false
sp_cleanup.correct_indentation=true
sp_cleanup.format_source_code=true
sp_cleanup.format_source_code_changes_only=false
sp_cleanup.make_local_variable_final=false
sp_cleanup.make_parameters_final=false
sp_cleanup.make_private_fields_final=true
sp_cleanup.make_type_abstract_if_missing_method=false
sp_cleanup.make_variable_declarations_final=false
sp_cleanup.never_use_blocks=false
sp_cleanup.never_use_parentheses_in_expressions=true
sp_cleanup.on_save_use_additional_actions=true
sp_cleanup.organize_imports=true
sp_cleanup.qualify_static_field_accesses_with_declaring_class=false
sp_cleanup.qualify_static_member_accesses_through_instances_with_declaring_class=true
sp_cleanup.qualify_static_member_accesses_through_subtypes_with_declaring_class=true
sp_cleanup.qualify_static_member_accesses_with_declaring_class=false
sp_cleanup.qualify_static_method_accesses_with_declaring_class=false
sp_cleanup.remove_private_constructors=true
sp_cleanup.remove_trailing_whitespaces=true
sp_cleanup.remove_trailing_whitespaces_all=true
sp_cleanup.remove_trailing_whitespaces_ignore_empty=false
sp_cleanup.remove_unnecessary_casts=false
sp_cleanup.remove_unnecessary_nls_tags=true
sp_cleanup.remove_unused_imports=true
sp_cleanup.remove_unused_local_variables=false
sp_cleanup.remove_unused_private_fields=true
sp_cleanup.remove_unused_private_members=false
sp_cleanup.remove_unused_private_methods=true
sp_cleanup.remove_unused_private_types=true
sp_cleanup.sort_members=false
sp_cleanup.sort_members_all=false
sp_cleanup.use_blocks=false
sp_cleanup.use_blocks_only_for_return_and_throw=true
sp_cleanup.use_parentheses_in_expressions=false
sp_cleanup.use_this_for_non_static_field_access=false
sp_cleanup.use_this_for_non_static_field_access_only_if_necessary=true
sp_cleanup.use_this_for_non_static_method_access=false
sp_cleanup.use_this_for_non_static_method_access_only_if_necessary=true
'''
}
