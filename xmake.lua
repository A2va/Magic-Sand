add_rules("mode.debug", "mode.release")
add_repositories("magicsand-repo repo")

add_requires("openframeworks", "ofxcv", "ofxparagraph", "ofxdatgui", "ofxmodal", "glfw")

set_languages("cxx17")

target("magic")
    set_kind("binary")
    set_rundir("bin")
    add_files("src/**.cpp")
    add_headerfiles("src/**.h")
    add_packages("openframeworks", "ofxcv", "ofxparagraph", "ofxdatgui", "ofxmodal", "glfw")

    before_run(function (target) 
        if not os.exists(path.join(target:targetdir(), "data")) then
            os.cp("bin/data", target:targetdir())
        end
    end)

    after_install(function (target) 
        local installdir = assert(target:installdir(), "please use `xmake install -o installdir` or `set_installdir` to set install directory on windows.")
        os.cp("bin/data", path.join(installdir, "bin"))
    end)

