//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <master_validator/master_validator_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) master_validator_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MasterValidatorPlugin");
  master_validator_plugin_register_with_registrar(master_validator_registrar);
}
