package("fmod")
    set_urls("https://github.com/cinder/Cinder-FMOD.git")

    on_install(function (package)
        os.cp("include/*.h", package:installdir("include"))
        if package:is_plat("macosx") then
            os.cp("lib/macosx/libfmodex.dylib", package:installdir("lib"))
        elseif package:is_plat("windows") then
            os.cp("lib/msw/fmodex.dll", package:installdir("lib"))
            os.cp("lib/msw/fmodex_vc.lib", package:installdir("lib"))
        end
    end)
