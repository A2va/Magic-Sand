package("ofxmodal")
    set_homepage("https://github.com/braitsch/ofxModal")
    set_description("A flexible and extensible kit of Modal windows for openFrameworks")

    set_urls("https://github.com/braitsch/ofxModal.git")
    add_versions("2024.06.13", "71bfaa283407bbe58b921fd581d8665f21cf5eb8")

    add_deps("openframeworks", "ofxparagraph", "ofxdatgui")

    on_install(function (package) 
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            add_requires("openframeworks", "ofxparagraph", "ofxdatgui")
            set_languages("cxx17")
            target("ofxmodal")
                set_kind("$(kind)")
                add_files("src/*.cpp")
                add_headerfiles("src/*.h")
                add_includedirs("src")
                add_packages("openframeworks", "ofxparagraph", "ofxdatgui")
        ]])
        import("package.tools.xmake").install(package)
    end)