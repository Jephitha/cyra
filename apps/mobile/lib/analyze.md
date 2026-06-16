jotham Cyra/apps/mobile flutter analyze
Analyzing mobile...                                                     

warning • 'avoid_dynamic' isn't a recognized diagnostic code • analysis_options.yaml:18:5 • unrecognized_error_code
   info • The imported package 'timezone' isn't a dependency of the importing package. Try adding a dependency for 'timezone' in the 'pubspec.yaml' file • lib/app/bootstrap.dart:4:8 •
          depend_on_referenced_packages
warning • The type argument(s) of the function 'showDialog' can't be inferred. Use explicit type argument(s) for 'showDialog' • lib/app/main_shell.dart:125:9 •
       inference_failure_on_function_invocation
warning • The value of the local variable 'bgColor' isn't used. Try removing the variable or using it • lib/app/main_shell.dart:154:11 • unused_local_variable
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/app/main_shell.dart:459:46 • use_build_context_synchronously
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._iconSize') to initialize the field •
          lib/core/design/widgets/app_button.dart:33:9 • prefer_initializing_formals
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._variant') to initialize the field •
          lib/core/design/widgets/app_button.dart:34:9 • prefer_initializing_formals
   info • The 'child' argument should be last in widget constructor invocations. Try moving the argument to the end of the argument list • lib/core/design/widgets/app_card.dart:40:7 •
          sort_child_properties_last
   info • The 'child' argument should be last in widget constructor invocations. Try moving the argument to the end of the argument list • lib/core/design/widgets/app_card.dart:58:7 •
          sort_child_properties_last
   info • The 'child' argument should be last in widget constructor invocations. Try moving the argument to the end of the argument list • lib/core/design/widgets/app_card.dart:76:7 •
          sort_child_properties_last
   info • The 'child' argument should be last in widget constructor invocations. Try moving the argument to the end of the argument list • lib/core/design/widgets/app_card.dart:93:7 •
          sort_child_properties_last
warning • Unused import: 'package:cyra/core/design/tokens/app_radius.dart'. Try removing the import directive • lib/core/design/widgets/cycle_calendar.dart:4:8 • unused_import
warning • The value of the field '_hasAverageEntry' isn't used. Try removing the field, or using it • lib/core/design/widgets/cycle_overview_chart.dart:37:8 • unused_field
warning • Unused import: 'package:cyra/core/design/app_typography.dart'. Try removing the import directive • lib/core/design/widgets/cycle_phase_indicator.dart:3:8 • unused_import
warning • Unused import: 'package:cyra/core/design/tokens/app_radius.dart'. Try removing the import directive • lib/core/design/widgets/cycle_phase_indicator.dart:5:8 • unused_import
warning • Unused import: 'dart:math'. Try removing the import directive • lib/core/design/widgets/kick_counter.dart:2:8 • unused_import
warning • The import of 'package:flutter/services.dart' is unnecessary because all of the used elements are also provided by the import of 'package:flutter/material.dart'. Try removing
       the import directive • lib/core/design/widgets/symptom_selector.dart:2:8 • unnecessary_import
warning • The declaration 'defaultSymptoms' isn't referenced. Try removing the declaration of 'defaultSymptoms' • lib/core/design/widgets/symptom_selector.dart:299:30 • unused_element
warning • The value of the local variable 'oddsRatio' isn't used. Try removing the variable or using it • lib/core/ml/correlation_engine.dart:200:11 • unused_local_variable
warning • The value of the local variable 'ssResidual' isn't used. Try removing the variable or using it • lib/core/ml/correlation_engine.dart:363:12 • unused_local_variable
warning • The value of the local variable 'ssTotal' isn't used. Try removing the variable or using it • lib/core/ml/correlation_engine.dart:364:12 • unused_local_variable
warning • The value of the local variable 'windowEnd' isn't used. Try removing the variable or using it • lib/core/ml/explanation_engine.dart:70:11 • unused_local_variable
warning • The value of the local variable 'probabilities' isn't used. Try removing the variable or using it • lib/core/ml/health_insights_engine.dart:305:11 • unused_local_variable
warning • The declaration '_buildCycleSummary' isn't referenced. Try removing the declaration of '_buildCycleSummary' • lib/core/ml/health_insights_engine.dart:370:16 • unused_element
   info • 'anonKey' is deprecated and shouldn't be used. Use publishableKey instead. anonKey will be removed in a future major version. Try replacing the use of the deprecated member
          with the replacement • lib/core/networking/supabase_client.dart:19:7 • deprecated_member_use
warning • The value of the field '_database' isn't used. Try removing the field, or using it • lib/core/networking/sync_service.dart:33:24 • unused_field
warning • The type argument(s) of the constructor 'Future.delayed' can't be inferred. Use explicit type argument(s) for 'Future.delayed' • lib/core/networking/sync_service.dart:128:17 •
       inference_failure_on_instance_creation
warning • The value of the local variable 'totalDataPoints' isn't used. Try removing the variable or using it • lib/core/prediction/ovulation_detector.dart:63:15 • unused_local_variable
   info • Unnecessary braces in a string interpolation. Try removing the braces • lib/core/prediction/ovulation_detector.dart:84:16 • unnecessary_brace_in_string_interps
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/core/security/audit_service.dart:4:8 • unnecessary_import
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._secureStorage') to initialize the field •
          lib/core/security/audit_service.dart:95:9 • prefer_initializing_formals
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._retentionDays') to initialize the field •
          lib/core/security/audit_service.dart:96:9 • prefer_initializing_formals
warning • The declaration 'sorted' isn't referenced. Try removing the declaration of 'sorted' • lib/core/security/audit_service.dart:350:11 • unused_element
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/core/security/biometric_auth_service.dart:1:8 • unnecessary_import
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._localAuth') to initialize the field •
          lib/core/security/biometric_auth_service.dart:29:9 • prefer_initializing_formals
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._secureStorage') to initialize the field •
          lib/core/security/biometric_auth_service.dart:30:9 • prefer_initializing_formals
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._pinAuthService') to initialize the field •
          lib/core/security/biometric_auth_service.dart:31:9 • prefer_initializing_formals
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/core/security/data_export_service.dart:4:8 • unnecessary_import
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._authService') to initialize the field •
          lib/core/security/data_export_service.dart:54:9 • prefer_initializing_formals
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._auditService') to initialize the field •
          lib/core/security/data_export_service.dart:55:9 • prefer_initializing_formals
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/core/security/encryption_service.dart:8:8 • unnecessary_import
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/core/security/pin_auth_service.dart:6:8 • unnecessary_import
warning • The value of the local variable 'result' isn't used. Try removing the variable or using it • lib/core/security/pin_auth_service.dart:166:11 • unused_local_variable
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/core/security/privacy_service.dart:4:8 • unnecessary_import
warning • Unused import: 'package:flutter_local_notifications/flutter_local_notifications.dart'. Try removing the import directive • lib/core/security/privacy_service.dart:6:8 •
       unused_import
   info • Use an initializing formal to assign a parameter to a field. Try using an initialing formal ('this._secureStorage') to initialize the field •
          lib/core/security/privacy_service.dart:53:8 • prefer_initializing_formals
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/core/security/secure_storage_service.dart:3:8 • unnecessary_import
   info • The imported package 'timezone' isn't a dependency of the importing package. Try adding a dependency for 'timezone' in the 'pubspec.yaml' file •
          lib/core/utils/notification_helper.dart:4:8 • depend_on_referenced_packages
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/features/auth/providers/auth_providers.dart:1:8 • unnecessary_import
warning • The value of the field '_scaleAnimation' isn't used. Try removing the field, or using it • lib/features/auth/screens/emergency_lock_screen.dart:25:26 • unused_field
   info • The private field _calculating could be 'final'. Try making the field 'final' • lib/features/auth/screens/emergency_lock_screen.dart:28:8 • prefer_final_fields
warning • The value of the field '_calculating' isn't used. Try removing the field, or using it • lib/features/auth/screens/emergency_lock_screen.dart:28:8 • unused_field
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/auth/screens/emergency_lock_screen.dart:92:30 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/auth/screens/lock_screen.dart:155:28 • use_build_context_synchronously
warning • Unused import: 'package:cyra/core/design/tokens/app_radius.dart'. Try removing the import directive • lib/features/auth/screens/onboarding_screen.dart:6:8 • unused_import
warning • The value of the local variable 'isActive' isn't used. Try removing the variable or using it • lib/features/auth/screens/onboarding_screen.dart:261:11 • unused_local_variable
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/auth/screens/pin_setup_screen.dart:116:28 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/auth/screens/pin_setup_screen.dart:132:28 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps. Try rewriting the code to not use the 'BuildContext', or guard the use with a 'mounted' check •
          lib/features/auth/screens/pin_setup_screen.dart:202:9 • use_build_context_synchronously
warning • The value of the field '_pinSubmitted' isn't used. Try removing the field, or using it • lib/features/auth/screens/privacy_setup_screen.dart:33:8 • unused_field
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/auth/screens/privacy_setup_screen.dart:126:28 • use_build_context_synchronously
warning • The type argument(s) of the function 'rpc' can't be inferred. Use explicit type argument(s) for 'rpc' • lib/features/community/repositories/community_repository.dart:162:30 •
       inference_failure_on_function_invocation
warning • The type argument(s) of the function 'rpc' can't be inferred. Use explicit type argument(s) for 'rpc' • lib/features/community/repositories/community_repository.dart:198:32 •
       inference_failure_on_function_invocation
warning • The type argument(s) of the function 'rpc' can't be inferred. Use explicit type argument(s) for 'rpc' • lib/features/community/repositories/community_repository.dart:208:32 •
       inference_failure_on_function_invocation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/community/screens/community_hub_screen.dart:185:9 • inference_failure_on_instance_creation
warning • The value of the local variable 'highlightColor' isn't used. Try removing the variable or using it • lib/features/community/screens/community_hub_screen.dart:250:11 •
       unused_local_variable
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/community/screens/community_hub_screen.dart:362:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/community/screens/community_hub_screen.dart:421:13 • inference_failure_on_instance_creation
warning • The type argument(s) of the function 'showDialog' can't be inferred. Use explicit type argument(s) for 'showDialog' •
       lib/features/community/screens/community_hub_screen.dart:468:5 • inference_failure_on_function_invocation
   info • 'value' is deprecated and shouldn't be used. Use initialValue instead. This will set the initial value for the form field. This feature was deprecated after v3.33.0-1.0.pre.
          Try replacing the use of the deprecated member with the replacement • lib/features/community/screens/new_post_screen.dart:149:13 • deprecated_member_use
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/community/screens/new_post_screen.dart:290:11 • deprecated_member_use
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/community/screens/new_post_screen.dart:302:13 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/community/screens/post_detail_screen.dart:9:8 •
       unused_import
warning • The type argument(s) of the function 'showDialog' can't be inferred. Use explicit type argument(s) for 'showDialog' •
       lib/features/community/screens/post_detail_screen.dart:85:5 • inference_failure_on_function_invocation
warning • The value of 'refresh' should be used. Try using the result by invoking a member, passing it to a function, or returning it from this function •
       lib/features/community/screens/topic_screen.dart:54:17 • unused_result
warning • The value of 'refresh' should be used. Try using the result by invoking a member, passing it to a function, or returning it from this function •
       lib/features/community/screens/topic_screen.dart:65:15 • unused_result
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/community/screens/topic_screen.dart:88:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/community/screens/topic_screen.dart:188:9 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/community/screens/topic_screen.dart:264:15 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/community/screens/topic_screen.dart:280:17 • inference_failure_on_instance_creation
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/community/screens/topic_screen.dart:414:5 • inference_failure_on_function_invocation
warning • The type argument(s) of the function 'showDialog' can't be inferred. Use explicit type argument(s) for 'showDialog' • lib/features/community/screens/topic_screen.dart:444:5 •
       inference_failure_on_function_invocation
warning • The type argument(s) of 'List' can't be inferred. Use explicit type argument(s) for 'List' • lib/features/conditions/repositories/condition_repository.dart:125:29 •
       inference_failure_on_collection_literal
warning • The type argument(s) of 'List' can't be inferred. Use explicit type argument(s) for 'List' • lib/features/conditions/repositories/condition_repository.dart:125:45 •
       inference_failure_on_collection_literal
warning • The value of the local variable 'labels' isn't used. Try removing the variable or using it • lib/features/conditions/screens/condition_detail_screen.dart:467:13 •
       unused_local_variable
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/conditions/screens/condition_detail_screen.dart:656:7 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/features/conditions/providers/condition_providers.dart'. Try removing the import directive •
       lib/features/conditions/screens/condition_tracking_screen.dart:14:8 • unused_import
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/conditions/screens/condition_tracking_screen.dart:627:9 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/conditions/screens/condition_tracking_screen.dart:628:22 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/conditions/screens/condition_tracking_screen.dart:632:9 • use_build_context_synchronously
warning • The type argument(s) of the function 'showDialog' can't be inferred. Use explicit type argument(s) for 'showDialog' •
       lib/features/conditions/screens/condition_tracking_screen.dart:642:5 • inference_failure_on_function_invocation
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of the deprecated
          member with the replacement • lib/features/conditions/screens/conditions_hub_screen.dart:335:15 • deprecated_member_use
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/conditions/screens/conditions_hub_screen.dart:519:7 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/features/cycle/models/cycle.dart'. Try removing the import directive • lib/features/cycle/screens/calendar_screen.dart:13:8 • unused_import
warning • The declaration '_stringToStatus' isn't referenced. Try removing the declaration of '_stringToStatus' • lib/features/cycle/screens/calendar_screen.dart:32:18 • unused_element
warning • The value of the local variable 'formattedDate' isn't used. Try removing the variable or using it • lib/features/cycle/screens/calendar_screen.dart:270:11 •
       unused_local_variable
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/calendar_screen.dart:428:15 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/calendar_screen.dart:479:17 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/cycle/screens/cycle_detail_screen.dart:8:8 • unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/cycle/screens/cycle_detail_screen.dart:13:8 • unused_import
warning • Unused import: 'package:cyra/features/cycle/models/cycle.dart'. Try removing the import directive • lib/features/cycle/screens/cycle_detail_screen.dart:14:8 • unused_import
warning • Unused import: 'package:cyra/core/constants/cycle_constants.dart'. Try removing the import directive • lib/features/cycle/screens/cycle_history_screen.dart:10:8 • unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/cycle/screens/cycle_history_screen.dart:11:8 • unused_import
warning • The type argument(s) of the constructor 'Future.delayed' can't be inferred. Use explicit type argument(s) for 'Future.delayed' •
       lib/features/cycle/screens/cycle_history_screen.dart:60:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/cycle_history_screen.dart:105:15 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/cycle_history_screen.dart:185:9 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/cycle_history_screen.dart:322:17 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/core/design/widgets/symptom_selector.dart'. Try removing the import directive • lib/features/cycle/screens/dashboard_screen.dart:15:8 •
       unused_import
warning • The type argument(s) of the constructor 'Future.delayed' can't be inferred. Use explicit type argument(s) for 'Future.delayed' •
       lib/features/cycle/screens/dashboard_screen.dart:116:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/dashboard_screen.dart:289:9 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/dashboard_screen.dart:578:17 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/dashboard_screen.dart:668:21 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/cycle/screens/dashboard_screen.dart:678:21 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/cycle/screens/log_period_screen.dart:11:8 • unused_import
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/cycle/screens/prediction_detail_screen.dart:9:8 •
       unused_import
warning • Unused import: 'package:cyra/core/design/widgets/cycle_phase_indicator.dart'. Try removing the import directive • lib/features/cycle/screens/prediction_detail_screen.dart:11:8
       • unused_import
warning • Unused import: 'package:cyra/core/constants/cycle_constants.dart'. Try removing the import directive • lib/features/cycle/screens/prediction_detail_screen.dart:13:8 •
       unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/cycle/screens/prediction_detail_screen.dart:14:8 • unused_import
   info • Unnecessary escape in string literal. Remove the '\' escape • lib/features/education/data/education_content.dart:129:136 • unnecessary_string_escapes
   info • Unnecessary escape in string literal. Remove the '\' escape • lib/features/education/data/education_content.dart:129:287 • unnecessary_string_escapes
   info • Unnecessary escape in string literal. Remove the '\' escape • lib/features/education/data/education_content.dart:228:183 • unnecessary_string_escapes
   info • Unnecessary escape in string literal. Remove the '\' escape • lib/features/education/data/education_content.dart:467:529 • unnecessary_string_escapes
warning • The import of 'package:flutter_riverpod/flutter_riverpod.dart' is unnecessary because all of the used elements are also provided by the import of
       'package:riverpod_annotation/riverpod_annotation.dart'. Try removing the import directive • lib/features/education/providers/education_providers.dart:1:8 • unnecessary_import
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/education/screens/article_list_screen.dart:304:9 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/education/screens/article_reader_screen.dart:544:15 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/education/screens/education_hub_screen.dart:229:9 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/education/screens/education_hub_screen.dart:334:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/education/screens/education_hub_screen.dart:477:9 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/education/screens/education_hub_screen.dart:569:11 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/features/ovulation/models/ovulation_models.dart'. Try removing the import directive •
       lib/features/fertility/repositories/fertility_repository.dart:8:8 • unused_import
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/fertility/screens/avoid_pregnancy_screen.dart:7:8 •
       unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/fertility/screens/avoid_pregnancy_screen.dart:9:8 • unused_import
warning • Unused import: 'package:cyra/core/design/widgets/app_card.dart'. Try removing the import directive • lib/features/fertility/screens/log_intercourse_screen.dart:6:8 •
       unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/fertility/screens/log_intercourse_screen.dart:8:8 • unused_import
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of the deprecated
          member with the replacement • lib/features/fertility/screens/log_intercourse_screen.dart:318:13 • deprecated_member_use
warning • Unused import: 'package:cyra/core/design/widgets/fertility_widget.dart'. Try removing the import directive • lib/features/fertility/screens/ttc_dashboard_screen.dart:10:8 •
       unused_import
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/fertility/screens/ttc_dashboard_screen.dart:480:19 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/features/symptoms/models/symptom_models.dart'. Try removing the import directive • lib/features/insights/providers/insight_providers.dart:11:8 •
       unused_import
   info • 'WillPopScope' is deprecated and shouldn't be used. Use PopScope instead. The Android predictive back feature will not work with WillPopScope. This feature was deprecated after
          v3.12.0-1.0.pre. Try replacing the use of the deprecated member with the replacement • lib/features/insights/screens/ai_disclaimer_screen.dart:18:12 • deprecated_member_use
warning • A value for optional parameter 'isRead' isn't ever given. Try removing the unused parameter • lib/features/insights/screens/health_tips_screen.dart:34:41 •
       unused_element_parameter
warning • A value for optional parameter 'isExpanded' isn't ever given. Try removing the unused parameter • lib/features/insights/screens/health_tips_screen.dart:34:62 •
       unused_element_parameter
   info • Unnecessary braces in a string interpolation. Try removing the braces • lib/features/insights/screens/health_tips_screen.dart:208:12 • unnecessary_brace_in_string_interps
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/insights/screens/insight_detail_card.dart:91:9 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/core/design/widgets/symptom_bar_chart.dart'. Try removing the import directive • lib/features/insights/screens/insights_hub_screen.dart:13:8 •
       unused_import
warning • Unused import: 'package:cyra/core/design/widgets/health_timeline.dart'. Try removing the import directive • lib/features/insights/screens/insights_hub_screen.dart:14:8 •
       unused_import
warning • Unused import: 'package:cyra/core/constants/app_constants.dart'. Try removing the import directive • lib/features/insights/screens/insights_hub_screen.dart:15:8 • unused_import
warning • Unused import: 'package:cyra/features/symptoms/models/symptom_models.dart'. Try removing the import directive • lib/features/insights/screens/insights_hub_screen.dart:18:8 •
       unused_import
warning • Unused import: 'package:cyra/features/insights/screens/cycle_education_screen.dart'. Try removing the import directive •
       lib/features/insights/screens/insights_hub_screen.dart:21:8 • unused_import
warning • Unused import: 'package:cyra/features/insights/screens/insight_detail_card.dart'. Try removing the import directive •
       lib/features/insights/screens/insights_hub_screen.dart:23:8 • unused_import
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/insights/screens/insights_hub_screen.dart:178:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/insights/screens/insights_hub_screen.dart:478:17 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/insights/screens/insights_hub_screen.dart:585:17 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/insights/screens/insights_hub_screen.dart:628:13 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/insights/screens/topic_detail_screen.dart:8:8 •
       unused_import
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/insights/screens/topic_detail_screen.dart:688:17 • inference_failure_on_instance_creation
   info • Unnecessary braces in a string interpolation. Try removing the braces • lib/features/journal/repositories/journal_repository.dart:169:28 • unnecessary_brace_in_string_interps
   info • Unnecessary braces in a string interpolation. Try removing the braces • lib/features/journal/repositories/journal_repository.dart:197:28 • unnecessary_brace_in_string_interps
warning • The declaration '_toCompanion' isn't referenced. Try removing the declaration of '_toCompanion' • lib/features/journal/repositories/journal_repository.dart:252:30 •
       unused_element
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/journal/screens/journal_entry_screen.dart:15:8 •
       unused_import
warning • Unused import: 'package:cyra/features/journal/models/journal_models.dart'. Try removing the import directive • lib/features/journal/screens/journal_entry_screen.dart:16:8 •
       unused_import
warning • The value of the field '_recordingPath' isn't used. Try removing the field, or using it • lib/features/journal/screens/journal_entry_screen.dart:40:11 • unused_field
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/journal/screens/journal_entry_screen.dart:229:9 • inference_failure_on_instance_creation
warning • The value of the local variable 'file' isn't used. Try removing the variable or using it • lib/features/journal/screens/journal_entry_screen.dart:318:13 • unused_local_variable
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/journal/screens/journal_list_screen.dart:239:5 • inference_failure_on_function_invocation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/journal/screens/journal_list_screen.dart:268:7 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/journal/screens/journal_list_screen.dart:274:7 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/journal/screens/new_journal_entry_screen.dart:15:8 •
       unused_import
   info • The private field _photoPaths could be 'final'. Try making the field 'final' • lib/features/journal/screens/new_journal_entry_screen.dart:39:16 • prefer_final_fields
   info • The private field _voiceNotePaths could be 'final'. Try making the field 'final' • lib/features/journal/screens/new_journal_entry_screen.dart:40:16 • prefer_final_fields
warning • The value of the field '_recordingPath' isn't used. Try removing the field, or using it • lib/features/journal/screens/new_journal_entry_screen.dart:46:11 • unused_field
   info • The private field _isAudioPlaying could be 'final'. Try making the field 'final' • lib/features/journal/screens/new_journal_entry_screen.dart:47:8 • prefer_final_fields
warning • The value of the field '_isAudioPlaying' isn't used. Try removing the field, or using it • lib/features/journal/screens/new_journal_entry_screen.dart:47:8 • unused_field
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/ovulation/screens/fertility_chart_screen.dart:7:8 •
       unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/ovulation/screens/fertility_chart_screen.dart:9:8 • unused_import
   info • The private field _ovulationDate could be 'final'. Try making the field 'final' • lib/features/ovulation/screens/fertility_chart_screen.dart:56:13 • prefer_final_fields
   info • The private field _coverLine could be 'final'. Try making the field 'final' • lib/features/ovulation/screens/fertility_chart_screen.dart:57:11 • prefer_final_fields
warning • The import of 'package:flutter/services.dart' is unnecessary because all of the used elements are also provided by the import of 'package:flutter/material.dart'. Try removing
       the import directive • lib/features/ovulation/screens/log_bbt_screen.dart:2:8 • unnecessary_import
warning • Unused import: 'package:intl/intl.dart'. Try removing the import directive • lib/features/ovulation/screens/log_bbt_screen.dart:3:8 • unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/ovulation/screens/log_bbt_screen.dart:10:8 • unused_import
   info • The private field _isEditing could be 'final'. Try making the field 'final' • lib/features/ovulation/screens/log_bbt_screen.dart:21:8 • prefer_final_fields
warning • The value of the field '_isEditing' isn't used. Try removing the field, or using it • lib/features/ovulation/screens/log_bbt_screen.dart:21:8 • unused_field
warning • Unused import: 'package:cyra/core/design/widgets/app_card.dart'. Try removing the import directive • lib/features/ovulation/screens/log_mucus_screen.dart:5:8 • unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/ovulation/screens/log_mucus_screen.dart:7:8 • unused_import
warning • Unused import: 'package:intl/intl.dart'. Try removing the import directive • lib/features/ovulation/screens/log_opk_screen.dart:2:8 • unused_import
warning • Unused import: 'package:cyra/core/design/widgets/app_card.dart'. Try removing the import directive • lib/features/ovulation/screens/log_opk_screen.dart:6:8 • unused_import
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/ovulation/screens/log_opk_screen.dart:8:8 • unused_import
warning • The declaration '_resultIcon' isn't referenced. Try removing the declaration of '_resultIcon' • lib/features/ovulation/screens/log_opk_screen.dart:49:10 • unused_element
   info • 'value' is deprecated and shouldn't be used. Use initialValue instead. This will set the initial value for the form field. This feature was deprecated after v3.33.0-1.0.pre.
          Try replacing the use of the deprecated member with the replacement • lib/features/ovulation/screens/log_opk_screen.dart:296:11 • deprecated_member_use
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/ovulation/screens/ovulation_calendar_screen.dart:7:8 •
       unused_import
warning • Unused import: 'package:cyra/core/design/widgets/health_stat_card.dart'. Try removing the import directive • lib/features/ovulation/screens/ovulation_dashboard_screen.dart:11:8
       • unused_import
warning • The value of the local variable 'daysSinceOvulation' isn't used. Try removing the variable or using it • lib/features/ovulation/screens/ovulation_dashboard_screen.dart:228:11 •
       unused_local_variable
warning • The value of the local variable 'daysUntilOvulation' isn't used. Try removing the variable or using it • lib/features/ovulation/screens/ovulation_dashboard_screen.dart:231:11 •
       unused_local_variable
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/ovulation/screens/ovulation_dashboard_screen.dart:291:19 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/ovulation/screens/ovulation_dashboard_screen.dart:343:19 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/ovulation/screens/ovulation_dashboard_screen.dart:483:19 • inference_failure_on_instance_creation
warning • The value of the local variable 'statusIcon' isn't used. Try removing the variable or using it • lib/features/ovulation/screens/ovulation_dashboard_screen.dart:661:12 •
       unused_local_variable
warning • Unused import: 'dart:math'. Try removing the import directive • lib/features/pregnancy/repositories/pregnancy_repository.dart:2:8 • unused_import
   info • Use 'isNotEmpty' instead of 'length' to test whether the collection is empty. Try rewriting the expression to use 'isNotEmpty' •
          lib/features/pregnancy/screens/contraction_timer_screen.dart:122:15 • prefer_is_empty
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/pregnancy/screens/contraction_timer_screen.dart:570:5 • inference_failure_on_function_invocation
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of the deprecated
          member with the replacement • lib/features/pregnancy/screens/log_vitals_screen.dart:617:17 • deprecated_member_use
warning • Unused import: 'package:cyra/core/utils/extensions.dart'. Try removing the import directive • lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:11:8 •
       unused_import
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:224:21 • inference_failure_on_instance_creation
warning • The value of the local variable 'weeksRemaining' isn't used. Try removing the variable or using it • lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:244:11 •
       unused_local_variable
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:409:21 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:430:21 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:458:21 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:492:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:568:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:649:11 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:731:19 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/pregnancy_dashboard_screen.dart:795:21 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/week_detail_screen.dart:420:19 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/week_detail_screen.dart:436:19 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/pregnancy/screens/week_detail_screen.dart:465:15 • inference_failure_on_instance_creation
warning • Unused import: 'package:cyra/core/providers/settings_providers.dart'. Try removing the import directive • lib/features/privacy/screens/data_controls_screen.dart:11:8 •
       unused_import
warning • The value of the local variable 'isDark' isn't used. Try removing the variable or using it • lib/features/privacy/screens/data_controls_screen.dart:34:11 •
       unused_local_variable
warning • The value of the local variable 'bgColor' isn't used. Try removing the variable or using it • lib/features/privacy/screens/emergency_setup_screen.dart:55:11 •
       unused_local_variable
   info • 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead. This feature was deprecated after v3.32.0-0.0.pre. Try replacing the
          use of the deprecated member with the replacement • lib/features/privacy/screens/emergency_setup_screen.dart:200:27 • deprecated_member_use
   info • 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature was deprecated after v3.32.0-0.0.pre. Try replacing the use of the
          deprecated member with the replacement • lib/features/privacy/screens/emergency_setup_screen.dart:202:27 • deprecated_member_use
warning • Unused import: 'package:cyra/core/design/tokens/app_radius.dart'. Try removing the import directive • lib/features/privacy/screens/privacy_controls_screen.dart:8:8 •
       unused_import
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/privacy/screens/privacy_controls_screen.dart:10:8 •
       unused_import
warning • The value of the local variable 'bgColor' isn't used. Try removing the variable or using it • lib/features/privacy/screens/privacy_controls_screen.dart:29:11 •
       unused_local_variable
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/privacy/screens/privacy_controls_screen.dart:94:13 • deprecated_member_use
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/privacy/screens/privacy_controls_screen.dart:153:17 • deprecated_member_use
   info • Don't use 'BuildContext's across async gaps. Try rewriting the code to not use the 'BuildContext', or guard the use with a 'mounted' check •
          lib/features/privacy/screens/privacy_controls_screen.dart:170:23 • use_build_context_synchronously
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/privacy/screens/privacy_controls_screen.dart:228:9 • deprecated_member_use
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/privacy/screens/privacy_controls_screen.dart:251:9 • deprecated_member_use
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/privacy/screens/privacy_controls_screen.dart:266:9 • inference_failure_on_instance_creation
   info • Don't use 'BuildContext's across async gaps. Try rewriting the code to not use the 'BuildContext', or guard the use with a 'mounted' check •
          lib/features/privacy/screens/privacy_controls_screen.dart:390:7 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:406:22 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:414:9 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:418:9 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps. Try rewriting the code to not use the 'BuildContext', or guard the use with a 'mounted' check •
          lib/features/privacy/screens/privacy_controls_screen.dart:435:7 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:449:22 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:457:9 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:461:9 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:478:20 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:482:33 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:788:41 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check. Guard a 'State.context' use with a 'mounted' check on the State, and other BuildContext
          use with a 'mounted' check on the BuildContext • lib/features/privacy/screens/privacy_controls_screen.dart:791:38 • use_build_context_synchronously
   info • Unnecessary use of string interpolation. Try replacing the string literal with the variable name • lib/features/reports/repositories/report_repository.dart:44:15 •
          unnecessary_string_interpolations
   info • Unnecessary use of string interpolation. Try replacing the string literal with the variable name • lib/features/reports/repositories/report_repository.dart:90:15 •
          unnecessary_string_interpolations
   info • Unnecessary use of string interpolation. Try replacing the string literal with the variable name • lib/features/reports/repositories/report_repository.dart:254:13 •
          unnecessary_string_interpolations
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/reports/screens/reports_list_screen.dart:264:7 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/reports/screens/reports_list_screen.dart:271:7 • inference_failure_on_instance_creation
warning • The value of the local variable 'bgColor' isn't used. Try removing the variable or using it • lib/features/settings/screens/appearance_screen.dart:67:11 • unused_local_variable
   info • 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead. This feature was deprecated after v3.32.0-0.0.pre. Try replacing the
          use of the deprecated member with the replacement • lib/features/settings/screens/appearance_screen.dart:317:19 • deprecated_member_use
   info • 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature was deprecated after v3.32.0-0.0.pre. Try replacing the use of the
          deprecated member with the replacement • lib/features/settings/screens/appearance_screen.dart:322:19 • deprecated_member_use
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/settings/screens/appearance_screen.dart:489:13 • deprecated_member_use
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/settings/screens/notifications_screen.dart:8:8 •
       unused_import
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/settings/screens/notifications_screen.dart:119:19 • deprecated_member_use
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/settings/screens/notifications_screen.dart:324:17 • deprecated_member_use
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/settings/screens/notifications_screen.dart:433:5 • inference_failure_on_function_invocation
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/settings/screens/notifications_screen.dart:471:5 • inference_failure_on_function_invocation
warning • Unused import: 'package:cyra/core/design/tokens/app_radius.dart'. Try removing the import directive • lib/features/settings/screens/settings_screen.dart:7:8 • unused_import
warning • Unused import: 'package:cyra/core/design/widgets/app_button.dart'. Try removing the import directive • lib/features/settings/screens/settings_screen.dart:9:8 • unused_import
warning • The value of the local variable 'bgColor' isn't used. Try removing the variable or using it • lib/features/settings/screens/settings_screen.dart:21:11 • unused_local_variable
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/settings/screens/settings_screen.dart:123:15 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/settings/screens/settings_screen.dart:141:15 • inference_failure_on_instance_creation
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/settings/screens/settings_screen.dart:161:15 • inference_failure_on_instance_creation
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/settings/screens/settings_screen.dart:173:19 • deprecated_member_use
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor or activeTrackColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of
          the deprecated member with the replacement • lib/features/settings/screens/settings_screen.dart:232:19 • deprecated_member_use
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/settings/screens/settings_screen.dart:358:5 • inference_failure_on_function_invocation
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/settings/screens/settings_screen.dart:392:5 • inference_failure_on_function_invocation
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/settings/screens/settings_screen.dart:424:5 • inference_failure_on_function_invocation
warning • The value of the local variable 'now' isn't used. Try removing the variable or using it • lib/features/symptoms/repositories/symptom_repository.dart:43:11 •
       unused_local_variable
warning • The value of the local variable 'cycleDays' isn't used. Try removing the variable or using it • lib/features/symptoms/repositories/symptom_repository.dart:113:11 •
       unused_local_variable
warning • The declaration '_buildDayRanges' isn't referenced. Try removing the declaration of '_buildDayRanges' • lib/features/symptoms/repositories/symptom_repository.dart:415:10 •
       unused_element
warning • Unused import: 'package:intl/intl.dart'. Try removing the import directive • lib/features/symptoms/screens/quick_log_screen.dart:3:8 • unused_import
warning • The value of the local variable 'current' isn't used. Try removing the variable or using it • lib/features/symptoms/screens/quick_log_screen.dart:57:11 • unused_local_variable
warning • The type argument(s) of the function 'showModalBottomSheet' can't be inferred. Use explicit type argument(s) for 'showModalBottomSheet' •
       lib/features/symptoms/screens/quick_log_screen.dart:58:5 • inference_failure_on_function_invocation
warning • The value of the local variable 'isSelected' isn't used. Try removing the variable or using it • lib/features/symptoms/screens/quick_log_screen.dart:102:11 •
       unused_local_variable
   info • 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead. This feature was deprecated after v3.32.0-0.0.pre. Try replacing the
          use of the deprecated member with the replacement • lib/features/symptoms/screens/quick_log_screen.dart:106:9 • deprecated_member_use
   info • 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature was deprecated after v3.32.0-0.0.pre. Try replacing the use of the
          deprecated member with the replacement • lib/features/symptoms/screens/quick_log_screen.dart:108:9 • deprecated_member_use
warning • Unused import: 'package:cyra/core/design/app_typography.dart'. Try removing the import directive • lib/features/wearables/screens/device_detail_screen.dart:6:8 • unused_import
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of the deprecated
          member with the replacement • lib/features/wearables/screens/device_detail_screen.dart:260:13 • deprecated_member_use
   info • 'activeColor' is deprecated and shouldn't be used. Use activeThumbColor instead. This feature was deprecated after v3.31.0-2.0.pre. Try replacing the use of the deprecated
          member with the replacement • lib/features/wearables/screens/wearables_hub_screen.dart:465:13 • deprecated_member_use
warning • The type argument(s) of the constructor 'MaterialPageRoute' can't be inferred. Use explicit type argument(s) for 'MaterialPageRoute' •
       lib/features/wearables/screens/wearables_hub_screen.dart:579:7 • inference_failure_on_instance_creation
warning • The local variable '_createRecords' starts with an underscore. Try renaming the variable to not start with an underscore •
       test/core/prediction/ovulation_detector_test.dart:16:21 • no_leading_underscores_for_local_identifiers
warning • The local variable '_createSurgePattern' starts with an underscore. Try renaming the variable to not start with an underscore •
       test/core/prediction/ovulation_detector_test.dart:136:25 • no_leading_underscores_for_local_identifiers
warning • The local variable '_bbt' starts with an underscore. Try renaming the variable to not start with an underscore • test/core/prediction/ovulation_detector_test.dart:348:15 •
       no_leading_underscores_for_local_identifiers
warning • The local variable '_opk' starts with an underscore. Try renaming the variable to not start with an underscore • test/core/prediction/ovulation_detector_test.dart:352:19 •
       no_leading_underscores_for_local_identifiers
warning • The local variable '_mucus' starts with an underscore. Try renaming the variable to not start with an underscore • test/core/prediction/ovulation_detector_test.dart:356:22 •
       no_leading_underscores_for_local_identifiers
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:17:35 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:18:36 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:18:41 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:19:34 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:47:36 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:48:37 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:48:42 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:49:35 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:72:36 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:73:37 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:73:42 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:74:35 • argument_type_not_assignable
  error • Undefined name 'Directory'. Try correcting the name to one that is defined, or defining the name • test/core/security/encryption_service_test.dart:108:29 • undefined_identifier
  error • The function 'File' isn't defined. Try importing the library that defines 'File', correcting the name to the name of an existing function, or defining a function named 'File' •
         test/core/security/encryption_service_test.dart:110:27 • undefined_function
  error • The function 'File' isn't defined. Try importing the library that defines 'File', correcting the name to the name of an existing function, or defining a function named 'File' •
         test/core/security/encryption_service_test.dart:111:31 • undefined_function
  error • The function 'File' isn't defined. Try importing the library that defines 'File', correcting the name to the name of an existing function, or defining a function named 'File' •
         test/core/security/encryption_service_test.dart:112:31 • undefined_function
  error • The function 'File' isn't defined. Try importing the library that defines 'File', correcting the name to the name of an existing function, or defining a function named 'File' •
         test/core/security/encryption_service_test.dart:129:25 • undefined_function
  error • The function 'File' isn't defined. Try importing the library that defines 'File', correcting the name to the name of an existing function, or defining a function named 'File' •
         test/core/security/encryption_service_test.dart:130:26 • undefined_function
  error • Undefined name 'Directory'. Try correcting the name to one that is defined, or defining the name • test/core/security/encryption_service_test.dart:139:29 • undefined_identifier
  error • The function 'File' isn't defined. Try importing the library that defines 'File', correcting the name to the name of an existing function, or defining a function named 'File' •
         test/core/security/encryption_service_test.dart:141:25 • undefined_function
  error • The function 'File' isn't defined. Try importing the library that defines 'File', correcting the name to the name of an existing function, or defining a function named 'File' •
         test/core/security/encryption_service_test.dart:144:24 • undefined_function
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:157:43 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:158:44 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:158:49 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:159:42 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:169:36 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/core/security/encryption_service_test.dart:169:41 • argument_type_not_assignable
warning • Unused import: 'package:cyra/core/prediction/cycle_predictor.dart'. Try removing the import directive • test/features/cycle/cycle_repository_test.dart:7:8 • unused_import
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/features/cycle/cycle_repository_test.dart:23:41 • argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/features/cycle/cycle_repository_test.dart:26:41 • argument_type_not_assignable
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:74:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:74:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:74:45 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:84:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:84:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:84:45 •
         argument_type_not_assignable
warning • The type argument(s) of 'List' can't be inferred. Use explicit type argument(s) for 'List' • test/features/cycle/cycle_repository_test.dart:84:63 •
       inference_failure_on_collection_literal
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:94:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:94:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:94:45 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:104:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:104:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:104:45 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:114:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:114:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:114:45 •
         argument_type_not_assignable
warning • The type argument(s) of 'List' can't be inferred. Use explicit type argument(s) for 'List' • test/features/cycle/cycle_repository_test.dart:114:63 •
       inference_failure_on_collection_literal
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:127:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:127:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:127:45 •
         argument_type_not_assignable
warning • The type argument(s) of 'List' can't be inferred. Use explicit type argument(s) for 'List' • test/features/cycle/cycle_repository_test.dart:127:63 •
       inference_failure_on_collection_literal
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:137:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:137:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:137:45 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'into' can't be inferred. Use explicit type argument(s) for 'into' • test/features/cycle/cycle_repository_test.dart:138:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'TableInfo<Table, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:138:26 •
         argument_type_not_assignable
  error • The returned type '_MockInto' isn't returnable from a 'InsertStatement<Table, dynamic>' function, as required by the closure's context •
         test/features/cycle/cycle_repository_test.dart:138:50 • return_of_invalid_type_from_closure
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:154:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:154:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:154:45 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'into' can't be inferred. Use explicit type argument(s) for 'into' • test/features/cycle/cycle_repository_test.dart:155:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'TableInfo<Table, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:155:26 •
         argument_type_not_assignable
  error • The returned type '_MockInto' isn't returnable from a 'InsertStatement<Table, dynamic>' function, as required by the closure's context •
         test/features/cycle/cycle_repository_test.dart:155:50 • return_of_invalid_type_from_closure
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:172:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:172:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:172:45 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:182:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:182:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:182:45 •
         argument_type_not_assignable
warning • The type argument(s) of 'List' can't be inferred. Use explicit type argument(s) for 'List' • test/features/cycle/cycle_repository_test.dart:182:63 •
       inference_failure_on_collection_literal
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:198:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:198:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:198:45 •
         argument_type_not_assignable
warning • The type argument(s) of 'List' can't be inferred. Use explicit type argument(s) for 'List' • test/features/cycle/cycle_repository_test.dart:198:63 •
       inference_failure_on_collection_literal
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:211:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:211:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:211:45 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'into' can't be inferred. Use explicit type argument(s) for 'into' • test/features/cycle/cycle_repository_test.dart:212:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'TableInfo<Table, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:212:26 •
         argument_type_not_assignable
  error • The returned type '_MockInto' isn't returnable from a 'InsertStatement<Table, dynamic>' function, as required by the closure's context •
         test/features/cycle/cycle_repository_test.dart:212:50 • return_of_invalid_type_from_closure
warning • The type argument(s) of the function 'into' can't be inferred. Use explicit type argument(s) for 'into' • test/features/cycle/cycle_repository_test.dart:216:23 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'TableInfo<Table, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:216:28 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:220:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:220:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:220:45 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'into' can't be inferred. Use explicit type argument(s) for 'into' • test/features/cycle/cycle_repository_test.dart:221:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'TableInfo<Table, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:221:26 •
         argument_type_not_assignable
  error • The returned type '_MockInto' isn't returnable from a 'InsertStatement<Table, dynamic>' function, as required by the closure's context •
         test/features/cycle/cycle_repository_test.dart:221:50 • return_of_invalid_type_from_closure
warning • The type argument(s) of the function 'into' can't be inferred. Use explicit type argument(s) for 'into' • test/features/cycle/cycle_repository_test.dart:225:23 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'TableInfo<Table, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:225:28 •
         argument_type_not_assignable
warning • The type argument(s) of the function 'select' can't be inferred. Use explicit type argument(s) for 'select' • test/features/cycle/cycle_repository_test.dart:231:21 •
       inference_failure_on_function_invocation
  error • The argument type 'Null' can't be assigned to the parameter type 'ResultSetImplementation<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:231:28 •
         argument_type_not_assignable
  error • The argument type 'dynamic' can't be assigned to the parameter type 'SimpleSelectStatement<HasResultSet, dynamic>'.  • test/features/cycle/cycle_repository_test.dart:231:45 •
         argument_type_not_assignable
  error • The argument type 'Null' can't be assigned to the parameter type 'String'.  • test/features/cycle/cycle_repository_test.dart:265:45 • argument_type_not_assignable
warning • The return type of '_mockSelect' can't be inferred. Declare the return type of '_mockSelect' • test/features/cycle/cycle_repository_test.dart:272:1 •
       inference_failure_on_function_return_type
  error • The returned type 'T & List<dynamic>' isn't returnable from a 'Future<List<T>>' function, as required by the closure's context •
         test/features/cycle/cycle_repository_test.dart:279:27 • return_of_invalid_type_from_closure
  error • The name 'MyApp' isn't a class. Try correcting the name to match an existing class • test/widget_test.dart:16:35 • creation_with_non_type

380 issues found. (ran in 3.3s)