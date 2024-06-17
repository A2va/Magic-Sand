package("libtess2")
    set_homepage("https://github.com/memononen/libtess2")
    set_description("Game and tools oriented refactored version of GLU tesselator")

    set_urls("https://github.com/memononen/libtess2.git")
    add_versions("2024.05.16", "fc52516467dfa124bdd967c15c7cf9faf02a34ca")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("libtess2")
                set_kind("$(kind)")
                add_files("Source/*.c")
                add_headerfiles("Include/*.h")
                add_includedirs("Include")
        ]])
        import("package.tools.xmake").install(package)
    end)