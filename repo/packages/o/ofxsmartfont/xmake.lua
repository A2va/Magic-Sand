package("ofxsmartfont")
    set_homepage("https://github.com/braitsch/ofxSmartFont")
    set_description("Sane & simple font management for openFrameworks")

    set_urls("https://github.com/braitsch/ofxSmartFont.git")
    add_versions("2024.06.13", "eaa15f00058d6b7b3266bcb29f1b95afe3d39cde")

    set_description("sane & simple font management for openFrameworks")

    add_deps("openframeworks")

    on_install(function (package) 
        io.writefile("xmake.lua", [[$
            add_rules("mode.debug", "mode.release")
            add_requires("openframeworks")
            set_languages("cxx17")
            target("ofxsmartfont")
                set_kind("$(kind)")
                add_files("src/*.cpp")
                add_headerfiles("src/*.h")
                add_includedirs("src")
                add_packages("openframeworks")
        ]])
        import("package.tools.xmake").install(package)
    end)