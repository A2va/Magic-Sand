package("openframeworks")
    set_homepage("https://openframeworks.cc")
    set_description("openFrameworks is a community-developed cross platform toolkit for creative coding in C++")
    
    set_urls("https://github.com/openframeworks/openFrameworks.git")
    add_versions("2024.05.17", "e388ed091426b6bfb20f69e6bc2b035c8e861f7e")

    -- broken with stable version
    -- set_urls("https://github.com/openframeworks/openFrameworks/archive/refs/tags/$(version).tar.gz")
    -- add_versions("0.12.0", "cec363c952af92cc2b7f1f59a4d30f69e3010f21848bc30ab0fb13994a68a52c")
    add_deps("libfreenect", "libtess2")
    add_deps("opencv", "cairo", "freeimage") -- image
    add_deps("pugixml", "nlohmann_json") -- textual format
    add_deps("utfcpp", "uriparser", "libcurl")
    add_deps("videoinput", "glew", "glfw", "glm") -- video
    -- add_deps("glut", {system = is_plat("macosx")})
    add_deps("freeglut")
    add_deps("fmod", "openal-soft", "rtaudio", "kissfft", "libsndfile") -- audio
    
    add_defines("OF_USING_STD_FS", "OF_SOUND_PLAYER_OPENAL")

    on_install(function (package)
        os.cp(path.join(package:scriptdir(), "port", "xmake.lua"), "xmake.lua")

        if package:is_plat("windows") then
            package:add("defines", "TARGET_WIN32")
        elseif package:is_plat("mingw") then
            package:add("defines", "TARGET_MINGW")
        elseif package:is_plat("linux") then
            package:add("defines", "TARGET_LINUX")
        elseif package:is_plat("macosx") then 
            package:add("defines", "TARGET_OSX")
        end
        import("package.tools.xmake").install(package)
    end)