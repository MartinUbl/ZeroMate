include_guard()

set(ZEROMATE_RUNTIME_COMPONENT Runtime)

# Install the executable and the shared libraries it loads directly.
install(TARGETS
        zero_mate
        logging_system
    RUNTIME DESTINATION "." COMPONENT ${ZEROMATE_RUNTIME_COMPONENT}
    LIBRARY DESTINATION "." COMPONENT ${ZEROMATE_RUNTIME_COMPONENT}
)

# imgui_glfw is shared on Unix-like systems and static on Windows.
if(NOT WIN32)
    install(TARGETS imgui_glfw
        LIBRARY DESTINATION "." COMPONENT ${ZEROMATE_RUNTIME_COMPONENT}
    )
endif()

set(ZEROMATE_PERIPHERAL_TARGETS
    button
    dip_switch
    led
    logic_analyzer
    serial_terminal
    seven_seg_display
    ssd1306_oled
)

install(TARGETS ${ZEROMATE_PERIPHERAL_TARGETS}
    RUNTIME DESTINATION "peripherals" COMPONENT ${ZEROMATE_RUNTIME_COMPONENT}
    LIBRARY DESTINATION "peripherals" COMPONENT ${ZEROMATE_RUNTIME_COMPONENT}
)

# Peripheral libraries live one directory below their shared dependencies.
if(APPLE)
    set_target_properties(${ZEROMATE_PERIPHERAL_TARGETS}
        PROPERTIES INSTALL_RPATH "@loader_path/.."
    )
elseif(UNIX)
    set_target_properties(${ZEROMATE_PERIPHERAL_TARGETS}
        PROPERTIES INSTALL_RPATH "$ORIGIN/.."
    )
endif()

install(DIRECTORY
        "${PROJECT_SOURCE_DIR}/misc/fonts"
        "${PROJECT_SOURCE_DIR}/misc/icons"
        "${PROJECT_SOURCE_DIR}/misc/logos"
    DESTINATION "."
    COMPONENT ${ZEROMATE_RUNTIME_COMPONENT}
)

install(FILES
        "${PROJECT_SOURCE_DIR}/imgui.ini"
        "${PROJECT_SOURCE_DIR}/peripherals.json"
        "${PROJECT_SOURCE_DIR}/LICENSE"
        "${PROJECT_SOURCE_DIR}/README.md"
    DESTINATION "."
    COMPONENT ${ZEROMATE_RUNTIME_COMPONENT}
)

# A portable MSVC build needs the redistributable runtime DLLs beside the
# executable. System Windows DLLs remain provided by the operating system.
if(MSVC)
    set(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION ".")
    set(CMAKE_INSTALL_SYSTEM_RUNTIME_COMPONENT ${ZEROMATE_RUNTIME_COMPONENT})
    include(InstallRequiredSystemLibraries)
endif()
