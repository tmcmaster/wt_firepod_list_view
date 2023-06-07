//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import cloud_functions
import firebase_auth
import firebase_core
import firebase_database
import firebase_remote_config
import shared_preferences_foundation
import sign_in_with_apple

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FLTFirebaseFunctionsPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseFunctionsPlugin"))
  FLTFirebaseAuthPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseAuthPlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  FLTFirebaseDatabasePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseDatabasePlugin"))
  FLTFirebaseRemoteConfigPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseRemoteConfigPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SignInWithApplePlugin.register(with: registry.registrar(forPlugin: "SignInWithApplePlugin"))
}
