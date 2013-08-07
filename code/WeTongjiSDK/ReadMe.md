1.In your main project's Build Phase panel, add WeTongjiSDK to Target Dependencies.

2.In your main project's Build Settings panel, add "-framework WeTongjiSDK" and "-lxml2" to Other Linker Flags.

3.Add the following script to the build Pre-actions of your main project:

if [ ${BUILT_PRODUCTS_DIR} != "" ] && [ "${EXECUTABLE_PATH}" != "" ]; then
rm -rf "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_PATH}"
fi