//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <drag_and_drop_windows/drag_and_drop_windows_plugin.h>
#include <dynamic_color/dynamic_color_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DragAndDropWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DragAndDropWindowsPlugin"));
  DynamicColorPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DynamicColorPluginCApi"));
}
