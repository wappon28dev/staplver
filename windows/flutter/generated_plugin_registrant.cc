//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <drag_and_drop_windows/drag_and_drop_windows_plugin.h>
#include <dynamic_color/dynamic_color_plugin_c_api.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>
#include <window_manager/window_manager_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DragAndDropWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DragAndDropWindowsPlugin"));
  DynamicColorPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DynamicColorPluginCApi"));
  ScreenRetrieverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
