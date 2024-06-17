package("ofxparagraph") 
    set_homepage("https://github.com/braitsch/ofxParagraph")
    set_description("Paragraph renderer for openFrameworks")

    set_urls("https://github.com/braitsch/ofxParagraph/archive/refs/heads/master.zip")
    add_versions("2024.06.13", "03e70105bf6ff92a36fd0b891eaccb0999de44e38a7626f544cf7f4f1284420a")

    add_deps("openframeworks", "ofxsmartfont")

    on_install(function (package) 
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            add_requires("openframeworks", "ofxsmartfont")
            set_languages("cxx17")
            target("ofxparagraph")
                set_kind("$(kind)")
                add_files("src/*.cpp")
                add_headerfiles("src/*.h")
                add_includedirs("src")
                add_packages("openframeworks", "ofxsmartfont")
        ]])
        import("package.tools.xmake").install(package)
    end)