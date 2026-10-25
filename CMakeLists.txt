cmake_minimum_required(VERSION 3.28)

include(${CMAKE_CURRENT_LIST_DIR}/tools/rp6502.cmake)

project(CHUCKIE-EGG C ASM)

add_executable(chuckie)
target_sources(chuckie PRIVATE
    src/platform.s
    src/chuckie.s
)
target_include_directories(chuckie PRIVATE src)

# The game keeps its variables at the fixed addresses of the BBC Micro,
# so it links with its own memory map instead of the cc65 default.
target_link_options(chuckie PRIVATE -C ${CMAKE_CURRENT_SOURCE_DIR}/src/chuckie.cfg)
set_property(TARGET chuckie APPEND PROPERTY LINK_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/src/chuckie.cfg)

rp6502_asset(chuckie help src/help.txt)
# The image loads at $0800, which starts with the jumps of platform.s
# for reset, IRQ and NMI.
rp6502_executable(chuckie DATA 0x0800 RESET 0x0800 IRQ 0x0803 NMI 0x0806)
rp6502_web(chuckie)
