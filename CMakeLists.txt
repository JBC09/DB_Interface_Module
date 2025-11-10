cmake_minimum_required(VERSION 3.16)

project(ClonixDatabase VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)
find_package(Crow CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(unofficial-mysql-connector-cpp CONFIG REQUIRED)


qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appClonixDatabase
    main.cpp
        src/RestApi/RestApi.cpp
        include/RestApi/RestApi.h
        src/Log/Log.cpp
        include/Log/Log.h
        include/DB/Db.h
        src/DB/Db.cpp
)

qt_add_qml_module(appClonixDatabase
    URI ClonixDatabase
    VERSION 1.0
    QML_FILES
        Main.qml
        Components/InputLabel.qml
        Components/LeftSection.qml
        Components/RightSection.qml
        Components/TextFieldCustom.qml
        Components/ButtonCustom.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appClonixDatabase PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appClonixDatabase
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)


target_link_libraries(appClonixDatabase PRIVATE
        Qt6::Quick
        Crow::Crow asio::asio
        nlohmann_json::nlohmann_json
        unofficial::mysql-connector-cpp::connector
)


target_include_directories(appClonixDatabase PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")

include(GNUInstallDirs)
install(TARGETS appClonixDatabase
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
