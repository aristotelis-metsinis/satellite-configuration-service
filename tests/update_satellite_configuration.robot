*** Settings ***
Documentation   Update satellite configuration test cases
Library         RequestsLibrary
Library         JSONLibrary
Library         Collections
Library         String
Resource        ../keywords/common.robot
Resource        ../keywords/request_data.robot
Resource        ../keywords/response_data.robot
Resource        ../keywords/update_satellite_configuration_steps.robot
Suite Setup     Create Session with Satellite Configuration Service
Suite Teardown  Delete All Sessions with Satellite Configuration Service

*** Test Cases ***
TC01 - Update Valid Configuration
    [Documentation]   Verify that a valid satellite configuration can be updated successfully (for each possible payload type).
    [Tags]            id:update_01    service:update
    [Setup]           Run Keywords    Clear Mission Configuration Database
    ...               AND  Populate Mission Configuration Database    &{REQ_VALID_OPTICAL_PAYLOAD}
    ...               AND  Populate Mission Configuration Database    &{REQ_VALID_SAR_PAYLOAD}
    ...               AND  Populate Mission Configuration Database    &{REQ_VALID_TELECOM_PAYLOAD}
    [Template]        Update Satellite Configuration
    1   &{REQ_VALID_OPTICAL_UPDATE}
    3   &{REQ_VALID_TELECOM_UPDATE}
    2   &{REQ_VALID_SAR_UPDATE}

TC02 - Update Non-existent Configuration
    [Documentation]             Verify server response when trying to update a non-existent configuration.
    [Tags]                      id:update_02    service:update
    ${response}                 PUT On Session    api    ${CONFIGURATION_URL}/${INVALID_ID}    headers=&{HEADERS}
    ...                         json=${REQ_VALID_OPTICAL_UPDATE}   expected_status=404
    Save Response Details       ${response}
    Status Should Be            404    ${response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Resource Does Not Exist Error Message  ${INVALID_ID}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC03 - Update with Invalid COSPAR ID
    [Documentation]   Verify server response when updating with an invalid COSPAR ID (for different COSPAR ID formats).
    [Tags]            id:update_03    service:update
    [Template]        Update Satellite Configuration with Invalid COSPAR ID
    1	&{REQ_INVALID_COSPAR_ID_XXX}
    3	&{REQ_INVALID_COSPAR_ID_-dddXX}
    1	&{REQ_INVALID_COSPAR_ID_YY-dddXX}
    2	&{REQ_INVALID_COSPAR_ID_YYYY-XX}
    1	&{REQ_INVALID_COSPAR_ID_YYYY-dXX}
    3	&{REQ_INVALID_COSPAR_ID_YYYY-ddd}
    2	&{REQ_INVALID_COSPAR_ID_YYYY-dddXXX}
    1	&{REQ_INVALID_COSPAR_ID_YYYYdddXX}
    3	&{REQ_INVALID_COSPAR_ID_YXYY-dddXX}
    2	&{REQ_INVALID_COSPAR_ID_YYYY-XddXX}
    1	&{REQ_INVALID_COSPAR_ID_YYYY-dddXd}
    1	&{REQ_INVALID_COSPAR_ID_YYYY-dddxx}

TC04 - Update with Invalid Payload Type
    [Documentation]             Verify server response when updating with an invalid payload type.
    [Tags]                      id:update_04    service:update
    ${response}                 PUT On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         json=${REQ_INVALID_TYPE}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${INVALID_PAYLOAD_TYPE_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}
    ${response}                 PUT On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         json=${REQ_INVALID_TYPE_LOWERCASE}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${INVALID_PAYLOAD_TYPE_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC05 - Missing COSPAR ID
    [Documentation]             Test that the request fails if the COSPAR ID field is missing.
    [Tags]                      id:update_05    service:update
    ${response}                 PUT On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         json=&{REQ_MISSING_COSPAR_ID}   expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${REQUIRED_COSPAR_ID_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}

TC06 - Missing Name
    [Documentation]             Test that the request fails if the NAME field is missing.
    [Tags]                      id:update_06    service:update
    ${response}                 PUT On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         json=&{REQ_MISSING_NAME}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${REQUIRED_NAME_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}

TC07 - Missing Type
    [Documentation]             Test that the request fails if the TYPE field is missing.
    [Tags]                      id:update_07    service:update
    ${response}                 PUT On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         json=&{REQ_MISSING_TYPE}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}   ${REQUIRED_PAYLOAD_TYPE_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC08 - Boundary Test - Empty Payload
    [Documentation]             Verify server response when sending an empty payload.
    [Tags]                      id:update_08    service:update
    ${response}                 PUT On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         json={}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${CANNOT_UNMARSHAL_STRING_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC09 - Check Unauthorized Access
    [Documentation]             Verify server rejects requests from unauthorized users.
    [Tags]                      id:update_09    service:update
    ${response}                 PUT On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{REQ_UNAUTHORIZED_HEADERS}
    ...                         json=${REQ_VALID_OPTICAL_UPDATE}   expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${AUTHORIZATION_TOKEN_NOT_FOUND_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}