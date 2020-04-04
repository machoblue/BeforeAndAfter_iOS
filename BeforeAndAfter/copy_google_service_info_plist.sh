if [ "${CONFIGURATION}" = "Develop_Debug" ] || [ "${CONFIGURATION}" = "Develop_Release" ] ; then
    cp "${PROJECT_DIR}/${PROJECT_NAME}/GoogleService-Info_Develop.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
    echo "Develop GoogleService-Info copied."
elif [ "${CONFIGURATION}" = "Production_Debug" ] || [ "${CONFIGURATION}" = "Production_Release" ] ; then
    cp "${PROJECT_DIR}/${PROJECT_NAME}/GoogleService-Info_Production.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
    echo "Release GoogleService-Info copied."
fi
