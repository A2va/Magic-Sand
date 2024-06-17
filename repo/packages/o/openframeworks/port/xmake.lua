add_modes("mode.debug", "mode.release")

add_requires("libfreenect", "libtess2")
add_requires("opencv", "cairo", "freeimage") -- image
add_requires("pugixml", "nlohmann_json") -- textual format
add_requires("utfcpp", "uriparser", "libcurl")
add_requires("videoinput", "glew", "glfw", "glm") -- video
add_requires("glut", {system = is_plat("macosx")})
add_requires("fmod", "openal-soft", "rtaudio", "kissfft", "libsndfile") -- audio

if is_plat("linux") then
    add_requires("gstreamer")
end

set_languages("cxx17")

target("openframeworks")
    set_kind("$(kind)")
    add_defines("OF_USING_STD_FS")
    if is_plat("linux") then
        add_packages("gstreamer")
    end

    add_requires("libfreenect", "libtess2")
    add_requires("opencv", "cairo", "freeimage") -- image
    add_requires("utfcpp", "uriparser", "libcurl")
    add_requires("videoinput", "glew", "glfw", "glm") -- video
    add_requires("fmod", "openal-soft", "rtaudio", "kissfft", "libsndfile") -- audio
    
    -- main files
    add_files("addons/ofxKinect/**.cpp")
    add_files("addons/ofxXmlSettings/**.cpp")
    add_files("addons/ofxOpenCv/**.cpp")
    add_files("libs/**.cpp")
    add_headerfiles("libs/**.h")
    add_headerfiles("libs/**.inl")
    if is_plat("macosx") then
        add_files("libs/**.m")
    end

    -- addons 
    add_headerfiles("addons/ofxKinect/**.h")
    add_includedirs("addons/ofxKinect/src/extra")
    add_headerfiles("addons/ofxXmlSettings/**.h")
    add_headerfiles("addons/ofxOpenCv/**.h")

    add_includedirs("addons/ofxXmlSettings/libs")
    add_includedirs("addons/ofxOpenCv/libs")


    -- disable fmod
    remove_files("libs/openFrameworks/sound/ofFmodSoundPlayer.cpp")
    remove_headerfiles("libs/openFrameworks/sound/ofFmodSoundPlayer.h")

    if not is_plat("linux") then
        remove_headerfiles("libs/openFrameworks/app/ofAppEGLWindow.h")
        remove_files("libs/openFrameworks/app/ofAppEGLWindow.cpp")
    end

    if not is_plat("macosx") then
        remove_headerfiles("libs/openFrameworks/video/ofAVFoundationGrabber.h")
    end

    on_load(function (target)
        if target:is_plat("windows") then
            target:add("defines", "UNICODE")
            target:add("defines", "TARGET_WIN32")
        elseif target:is_plat("mingw") then
            target:add("defines", "TARGET_MINGW")
        elseif target:is_plat("linux") then
            target:add("defines", "TARGET_LINUX")
        elseif target:is_plat("macosx") then 
            target:add("defines", "TARGET_OSX")
        end

        target:add("defines", "OF_SOUND_PLAYER_OPENAL") -- force to use openal for sound


        -- patch some includes
        io.replace("addons/ofxKinect/src/ofxKinect.h", "#include \"libfreenect.h\"", "#include <libfreenect/libfreenect.h>")
        io.replace("addons/ofxKinect/src/ofxKinect.cpp", "#include \"libfreenect_registration.h\"", "#include <libfreenect/libfreenect_registration.h>")
        io.replace("addons/ofxKinect/src/ofxKinect.cpp", "#include \"freenect_internal.h\"", "#include <libfreenect/freenect_internal.h>")
        io.replace("addons/ofxXmlSettings/src/ofxXmlSettings.h", "#include \"../libs/tinyxml.h\"", "#include <tinyxml.h>")

        io.replace("libs/openFrameworks/utils/ofJson.h", "#include <json.hpp>", "#include <nlohmann/json.hpp>")
        io.replace("libs/openFrameworks/app/ofAppGlutWindow.cpp", "#include \"glut.h\"", "#include <GL/glut.h> #include <GL/freeglut_ext.h>")
        io.replace("libs/openFrameworks/sound/ofRtAudioSoundStream.cpp", "#include <RtAudio.h>", "#include <rtaudio/RtAudio.h>")
        io.replace("libs/openFrameworks/utils/ofUtils.h", "#include <utf8.h>", "#include <utf8cpp/utf8.h>")

        if not target:is_plat("linux") then
            target:remove("files", "libs/openFrameworks/video/ofGstUtils.cpp", "libs/openFrameworks/video/ofGstVideoGrabber.cpp", "libs/openFrameworks/video/ofGstVideoPlayer.cpp")
            target:remove("headerfiles", "libs/openFrameworks/video/ofGstUtils.h", "libs/openFrameworks/video/ofGstVideoGrabber.h", "libs/openFrameworks/video/ofGstVideoGrabber.h")
        end

        for _, dir in ipairs(os.dirs("libs/openFrameworks/*")) do
            if not dir:endswith(".settings") then
                target:add("includedirs", dir)
            end
        end
    end)