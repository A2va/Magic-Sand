package("kissfft")
    set_homepage("https://github.com/mborgerding/kissfft")
    set_description("a Fast Fourier Transform (FFT) library that tries to Keep it Simple, Stupid")

    set_urls("https://github.com/mborgerding/kissfft.git")
    add_versions("2024.06.15", "f5f2a3b2f2cd02bf80639adb12cbeed125bdf420")

    on_install(function (package) 
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")

            target("kissfft")
                set_kind("$(kind)")
                add_files("*.c")
                add_headerfiles("*.h", "kissfft.hh")
        ]])
        import("package.tools.xmake").install(package)
    end)