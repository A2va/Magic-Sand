package("ofxdatgui")
    set_homepage("https://braitsch.github.io/ofxDatGui")
    set_description("Simple to use, fully customizable, high-resolution graphical user interface for openFrameworks")

    set_urls("https://github.com/thomwolf/ofxDatGui.git") -- fork
    add_versions("2024.06.13", "0c2230afa68fe5dea822932f6b4c178778af9440")

    add_deps("openframeworks", "ofxsmartfont")

    on_install(function (package)
        local oldir = os.cd(path.join(package:cachedir(), "source", "ofxdatgui"))
        io.replace("src/core/ofxDatGuiComponent.cpp", "std::make_unique", "make_unique", {plain = true})
        io.replace("src/core/ofxDatGuiComponent.cpp", "make_unique", "std::make_unique", {plain = true})
        io.replace("src/core/ofxDatGuiComponent.cpp", "std::string", "string", {plain = true})
        io.replace("src/core/ofxDatGuiComponent.cpp", "string", "std::string", {plain = true})

        io.replace("src/core/ofxDatGuiComponent.h", "std::shared_ptr", "shared_ptr", {plain = true})
        io.replace("src/core/ofxDatGuiComponent.h", "shared_ptr", "std::shared_ptr", {plain = true})
        io.replace("src/core/ofxDatGuiComponent.h", "std::unique_ptr", "unique_ptr", {plain = true})
        io.replace("src/core/ofxDatGuiComponent.h", "unique_ptr", "std::unique_ptr", {plain = true})
        io.replace("src/core/ofxDatGuiComponent.h", "std::string", "string", {plain = true})
        io.replace("src/core/ofxDatGuiComponent.h", "string", "std::string", {plain = true})

        io.replace("src/ofxDatGui.h", "std::unique_ptr", "unique_ptr", {plain = true})
        io.replace("src/ofxDatGui.h", "unique_ptr", "std::unique_ptr", {plain = true})
        io.replace("src/ofxDatGui.h", "std::vectpr", "vectpr", {plain = true})
        io.replace("src/ofxDatGui.h", "vectpr", "std::vectpr", {plain = true})

        io.replace("src/components/ofxDatGuiSlider.h", "std::setprecision", "setprecision", {plain = true})
        io.replace("src/components/ofxDatGuiSlider.h", "setprecision", "std::setprecision", {plain = true})

        io.replace("src/components/ofxDatGuiTextInputField.h", "std::min", "min", {plain = true})
        io.replace("src/components/ofxDatGuiTextInputField.h", "min", "std::min", {plain = true})

        -- add std include
        io.replace("src/core/ofxDatGuiComponent.h", "#include \"ofxDatGuiIntObject.h\"", "#include \"ofxDatGuiIntObject.h\" \n #include <memory> \n #include <string>")
        io.replace("src/components/ofxDatGuiSlider.h", "#include \"ofxDatGuiComponent.h\"", "#include \"ofxDatGuiComponent.h\" \n #include <iostream> \n #include <iomanip>")
        io.replace("src/components/ofxDatGuiTextInputField.h", "#include \"ofxDatGuiIntObject.h\"", "#include \"ofxDatGuiIntObject.h\" \n #include <algorithm>")
        os.cd(oldir)

        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            add_requires("openframeworks", "ofxsmartfont")
            set_languages("cxx17")
            target("ofxdatgui")
                set_kind("$(kind)")
                add_files("src/**.cpp|libs/*.cpp")
                add_headerfiles("src/**.h|libs/*.h")
                add_includedirs("src", "src/components", "src/core", "src/themes")
                add_packages("openframeworks", "ofxsmartfont")
        ]])
        import("package.tools.xmake").install(package)
    end)