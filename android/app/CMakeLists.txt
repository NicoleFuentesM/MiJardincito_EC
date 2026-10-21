cmake_minimum_required(VERSION 3.10.2)

project(jardincito LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Directorios donde están las cabeceras (.h)
include_directories(
    src/main/cpp/include
    include
)

# Compila los archivos C++ en la biblioteca compartida libjardincito.so
add_library(
    jardincito
    SHARED
    src/main/cpp/src/jardincito_bridge.cpp
    src/main/cpp/src/PlantaNativa.cpp
    src/main/cpp/src/Jardincito.cpp
    src/main/cpp/src/CargadorJSON.cpp
)
