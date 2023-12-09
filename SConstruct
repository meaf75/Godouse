#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

# For reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# tweak this if you want to use different folders, or more folders, to store your source code in.
project_name = "godouse"
gd_extensions_folder = "godouse-cpp-gdextensions"

env.Append(CPPPATH=["{}/".format(gd_extensions_folder)])

# Add files to include in the compilation
sources : list[str] = Glob("{}/*.cpp".format(gd_extensions_folder))
sources.append(Glob("{}/XInputSimulator/*.cpp".format(gd_extensions_folder)))

if env["platform"] == "macos":
    library = env.SharedLibrary(
        "bin/{}.{}.{}.framework/{}.{}.{}".format(
            project_name,env["platform"], env["target"],project_name, env["platform"], env["target"]
        ),
        source=sources,
    )
elif env["platform"] == "windows":
    # Include windows library
    env.Append(LIBS=["User32"])
    library = env.SharedLibrary(
        "bin/{}{}{}".format(project_name,env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )
elif env["platform"] == "android":
    lib_name = "lib_{}".format(project_name)
    library = env.SharedLibrary(
        "bin/{}{}{}".format(lib_name,env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
