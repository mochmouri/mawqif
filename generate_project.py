#!/usr/bin/env python3
"""
Generates Mawqif.xcodeproj/project.pbxproj
Run from: /Users/omar/Desktop/Mostapha Coding/parkingreminder/
"""

import itertools

# ── UUID factory (deterministic, 24-char hex) ──────────────────────────────
counter = itertools.count(1)
def U(tag=""):
    n = next(counter)
    return f"{n:024X}"

# ── Assign UUIDs ─────────────────────────────────────────────────────────────
ID = {}
for key in [
    # Project-level
    "project", "main_group", "products_group",
    # Groups
    "grp_models", "grp_managers", "grp_views", "grp_components", "grp_utilities", "grp_resources",
    # Target
    "app_target", "app_product",
    # Build phases
    "phase_sources", "phase_resources", "phase_frameworks",
    # Configurations
    "proj_config_list", "proj_debug", "proj_release",
    "tgt_config_list",  "tgt_debug",  "tgt_release",
    # Source file refs
    "ref_MawqifApp",
    "ref_ContentView",
    "ref_ParkingZone",
    "ref_ParkingSession",
    "ref_ZoneDatabase",
    "ref_NotificationManager",
    "ref_LocationManager",
    "ref_Strings",
    "ref_StatusRingView",
    "ref_GraceProgressView",
    "ref_PermissionView",
    "ref_MainView",
    # Resource file refs
    "ref_Assets",
    "ref_parking_json",
    "ref_InfoPlist",
    # Build file refs (Sources)
    "bf_MawqifApp",
    "bf_ContentView",
    "bf_ParkingZone",
    "bf_ParkingSession",
    "bf_ZoneDatabase",
    "bf_NotificationManager",
    "bf_LocationManager",
    "bf_Strings",
    "bf_StatusRingView",
    "bf_GraceProgressView",
    "bf_PermissionView",
    "bf_MainView",
    # Build file refs (Resources)
    "bf_Assets",
    "bf_parking_json",
]:
    ID[key] = U(key)

BUNDLE_ID = "sa.mawqif.app"
PRODUCT_NAME = "Mawqif"
SWIFT_VERSION = "5.9"
IPHONEOS_DEPLOYMENT_TARGET = "17.0"

# ── Build settings ─────────────────────────────────────────────────────────────
COMMON_SETTINGS = """
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = {depl};
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
""".format(depl=IPHONEOS_DEPLOYMENT_TARGET)

TARGET_SETTINGS = """
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Mawqif/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = {bid};
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = {sv};
				TARGETED_DEVICE_FAMILY = 1;
""".format(bid=BUNDLE_ID, sv=SWIFT_VERSION)

pbxproj = f"""// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{
	}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */
		{ID['bf_MawqifApp']} /* MawqifApp.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_MawqifApp']} /* MawqifApp.swift */; }};
		{ID['bf_ContentView']} /* ContentView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_ContentView']} /* ContentView.swift */; }};
		{ID['bf_ParkingZone']} /* ParkingZone.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_ParkingZone']} /* ParkingZone.swift */; }};
		{ID['bf_ParkingSession']} /* ParkingSession.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_ParkingSession']} /* ParkingSession.swift */; }};
		{ID['bf_ZoneDatabase']} /* ZoneDatabase.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_ZoneDatabase']} /* ZoneDatabase.swift */; }};
		{ID['bf_NotificationManager']} /* NotificationManager.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_NotificationManager']} /* NotificationManager.swift */; }};
		{ID['bf_LocationManager']} /* LocationManager.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_LocationManager']} /* LocationManager.swift */; }};
		{ID['bf_Strings']} /* Strings.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_Strings']} /* Strings.swift */; }};
		{ID['bf_StatusRingView']} /* StatusRingView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_StatusRingView']} /* StatusRingView.swift */; }};
		{ID['bf_GraceProgressView']} /* GraceProgressView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_GraceProgressView']} /* GraceProgressView.swift */; }};
		{ID['bf_PermissionView']} /* PermissionView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_PermissionView']} /* PermissionView.swift */; }};
		{ID['bf_MainView']} /* MainView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_MainView']} /* MainView.swift */; }};
		{ID['bf_Assets']} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_Assets']} /* Assets.xcassets */; }};
		{ID['bf_parking_json']} /* parking_zones.json in Resources */ = {{isa = PBXBuildFile; fileRef = {ID['ref_parking_json']} /* parking_zones.json */; }};
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		{ID['app_product']} /* Mawqif.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = Mawqif.app; sourceTree = BUILT_PRODUCTS_DIR; }};
		{ID['ref_MawqifApp']} /* MawqifApp.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MawqifApp.swift; sourceTree = "<group>"; }};
		{ID['ref_ContentView']} /* ContentView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; }};
		{ID['ref_ParkingZone']} /* ParkingZone.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ParkingZone.swift; sourceTree = "<group>"; }};
		{ID['ref_ParkingSession']} /* ParkingSession.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ParkingSession.swift; sourceTree = "<group>"; }};
		{ID['ref_ZoneDatabase']} /* ZoneDatabase.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ZoneDatabase.swift; sourceTree = "<group>"; }};
		{ID['ref_NotificationManager']} /* NotificationManager.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = NotificationManager.swift; sourceTree = "<group>"; }};
		{ID['ref_LocationManager']} /* LocationManager.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = LocationManager.swift; sourceTree = "<group>"; }};
		{ID['ref_Strings']} /* Strings.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Strings.swift; sourceTree = "<group>"; }};
		{ID['ref_StatusRingView']} /* StatusRingView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = StatusRingView.swift; sourceTree = "<group>"; }};
		{ID['ref_GraceProgressView']} /* GraceProgressView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = GraceProgressView.swift; sourceTree = "<group>"; }};
		{ID['ref_PermissionView']} /* PermissionView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PermissionView.swift; sourceTree = "<group>"; }};
		{ID['ref_MainView']} /* MainView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MainView.swift; sourceTree = "<group>"; }};
		{ID['ref_Assets']} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; }};
		{ID['ref_parking_json']} /* parking_zones.json */ = {{isa = PBXFileReference; lastKnownFileType = text.json; path = parking_zones.json; sourceTree = "<group>"; }};
		{ID['ref_InfoPlist']} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; }};
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		{ID['phase_frameworks']} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		{ID['main_group']} = {{
			isa = PBXGroup;
			children = (
				{ID['grp_resources']} /* Mawqif */,
				{ID['products_group']} /* Products */,
			);
			sourceTree = "<group>";
		}};
		{ID['products_group']} /* Products */ = {{
			isa = PBXGroup;
			children = (
				{ID['app_product']} /* Mawqif.app */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
		{ID['grp_resources']} /* Mawqif */ = {{
			isa = PBXGroup;
			children = (
				{ID['ref_MawqifApp']} /* MawqifApp.swift */,
				{ID['ref_ContentView']} /* ContentView.swift */,
				{ID['grp_models']} /* Models */,
				{ID['grp_managers']} /* Managers */,
				{ID['grp_views']} /* Views */,
				{ID['grp_utilities']} /* Utilities */,
				{ID['ref_Assets']} /* Assets.xcassets */,
				{ID['ref_parking_json']} /* parking_zones.json */,
				{ID['ref_InfoPlist']} /* Info.plist */,
			);
			path = Mawqif;
			sourceTree = "<group>";
		}};
		{ID['grp_models']} /* Models */ = {{
			isa = PBXGroup;
			children = (
				{ID['ref_ParkingZone']} /* ParkingZone.swift */,
				{ID['ref_ParkingSession']} /* ParkingSession.swift */,
			);
			path = Models;
			sourceTree = "<group>";
		}};
		{ID['grp_managers']} /* Managers */ = {{
			isa = PBXGroup;
			children = (
				{ID['ref_ZoneDatabase']} /* ZoneDatabase.swift */,
				{ID['ref_NotificationManager']} /* NotificationManager.swift */,
				{ID['ref_LocationManager']} /* LocationManager.swift */,
			);
			path = Managers;
			sourceTree = "<group>";
		}};
		{ID['grp_views']} /* Views */ = {{
			isa = PBXGroup;
			children = (
				{ID['ref_PermissionView']} /* PermissionView.swift */,
				{ID['ref_MainView']} /* MainView.swift */,
				{ID['grp_components']} /* Components */,
			);
			path = Views;
			sourceTree = "<group>";
		}};
		{ID['grp_components']} /* Components */ = {{
			isa = PBXGroup;
			children = (
				{ID['ref_StatusRingView']} /* StatusRingView.swift */,
				{ID['ref_GraceProgressView']} /* GraceProgressView.swift */,
			);
			path = Components;
			sourceTree = "<group>";
		}};
		{ID['grp_utilities']} /* Utilities */ = {{
			isa = PBXGroup;
			children = (
				{ID['ref_Strings']} /* Strings.swift */,
			);
			path = Utilities;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{ID['app_target']} /* Mawqif */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {ID['tgt_config_list']} /* Build configuration list for PBXNativeTarget "Mawqif" */;
			buildPhases = (
				{ID['phase_sources']} /* Sources */,
				{ID['phase_frameworks']} /* Frameworks */,
				{ID['phase_resources']} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = Mawqif;
			productName = Mawqif;
			productReference = {ID['app_product']} /* Mawqif.app */;
			productType = "com.apple.product-type.application";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{ID['project']} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {{
					{ID['app_target']} = {{
						CreatedOnToolsVersion = 15.0;
					}};
				}};
			}};
			buildConfigurationList = {ID['proj_config_list']} /* Build configuration list for PBXProject "Mawqif" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
				ar,
			);
			mainGroup = {ID['main_group']};
			productRefGroup = {ID['products_group']} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				{ID['app_target']} /* Mawqif */,
			);
		}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		{ID['phase_resources']} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{ID['bf_Assets']} /* Assets.xcassets in Resources */,
				{ID['bf_parking_json']} /* parking_zones.json in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		{ID['phase_sources']} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{ID['bf_MawqifApp']} /* MawqifApp.swift in Sources */,
				{ID['bf_ContentView']} /* ContentView.swift in Sources */,
				{ID['bf_ParkingZone']} /* ParkingZone.swift in Sources */,
				{ID['bf_ParkingSession']} /* ParkingSession.swift in Sources */,
				{ID['bf_ZoneDatabase']} /* ZoneDatabase.swift in Sources */,
				{ID['bf_NotificationManager']} /* NotificationManager.swift in Sources */,
				{ID['bf_LocationManager']} /* LocationManager.swift in Sources */,
				{ID['bf_Strings']} /* Strings.swift in Sources */,
				{ID['bf_StatusRingView']} /* StatusRingView.swift in Sources */,
				{ID['bf_GraceProgressView']} /* GraceProgressView.swift in Sources */,
				{ID['bf_PermissionView']} /* PermissionView.swift in Sources */,
				{ID['bf_MainView']} /* MainView.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		{ID['proj_debug']} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{{COMMON_SETTINGS}
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_TESTABILITY = YES;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				ONLY_ACTIVE_ARCH = YES;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
			}};
			name = Debug;
		}};
		{ID['proj_release']} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{{COMMON_SETTINGS}
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				MTL_ENABLE_DEBUG_INFO = NO;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "";
				SWIFT_COMPILATION_MODE = wholemodule;
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
		{ID['tgt_debug']} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{{TARGET_SETTINGS}
				DEBUG_INFORMATION_FORMAT = dwarf;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
			}};
			name = Debug;
		}};
		{ID['tgt_release']} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{{TARGET_SETTINGS}
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "";
				SWIFT_COMPILATION_MODE = wholemodule;
			}};
			name = Release;
		}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		{ID['proj_config_list']} /* Build configuration list for PBXProject "Mawqif" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{ID['proj_debug']} /* Debug */,
				{ID['proj_release']} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{ID['tgt_config_list']} /* Build configuration list for PBXNativeTarget "Mawqif" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{ID['tgt_debug']} /* Debug */,
				{ID['tgt_release']} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
/* End XCConfigurationList section */
	}};
	rootObject = {ID['project']} /* Project object */;
}}
"""

out_path = "Mawqif.xcodeproj/project.pbxproj"
with open(out_path, "w") as f:
    f.write(pbxproj)

print(f"✓ Generated {out_path}")
print(f"  Root project UUID: {ID['project']}")
print(f"  App target UUID:   {ID['app_target']}")
