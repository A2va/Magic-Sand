package("libfreenect")
    set_homepage("https://github.com/OpenKinect/libfreenect")
    set_description("Drivers and libraries for the Xbox Kinect device on Windows, Linux, and OS X")

    set_urls("https://github.com/OpenKinect/libfreenect.git")
    add_versions("2024.05.14", "09a1f098040d00e6070c18174904547ec31d2774")

    add_deps("cmake", "libusb", "pthreads4w")
    on_install(function (package)
        io.replace("CMakeLists.txt", "find_package(libusb-1.0 REQUIRED)", "", {plain = true})
        local configs = {}

        local pthreads4w = package:dep("pthreads4w"):fetch()
        if pthreads4w then
            table.insert(configs, "-DTHREADS_PTHREADS_INCLUDE_DIR=" .. table.concat(pthreads4w.includedirs or pthreads4w.sysincludedirs, ";"))
            table.insert(configs, "-DTHREADS_PTHREADS_WIN32_LIBRARY=" .. table.concat(pthreads4w.libfiles, ";"))
        end
        import("package.tools.cmake").install(package, configs, {packagedeps = "libusb"})
        -- openFrameworks needs to have this internal header accesible
        os.cp("src/freenect_internal.h", package:installdir("include/libfreenect"))
        os.cp("src/usb_libusb10.h", package:installdir("include/libfreenect"))
    end)
