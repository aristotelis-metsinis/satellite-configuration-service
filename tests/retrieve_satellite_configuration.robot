*** Settings ***
Documentation   Retrieve satellite configuration test cases
Library         RequestsLibrary
Library         Collections
Library         JSONLibrary
Library         String
Resource        ../keywords/common.robot
Resource        ../keywords/request_data.robot
Resource        ../keywords/response_data.robot
Suite Setup     Create Session with Satellite Configuration Service
Suite Teardown  Delete All Sessions with Satellite Configuration Service

*** Test Cases ***
TC01 - Retrieve Valid Configuration
    [Documentation]             Test retrieving satellite configuration with a valid mission ID.
    [Tags]                      id:retrieve_01    service:retrieve
    [Setup]                     Run Keywords    Clear Mission Configuration Database
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_OPTICAL_PAYLOAD}
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_SAR_PAYLOAD}
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_TELECOM_PAYLOAD}
    ${response}                 GET On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    expected_status=200
    Save Response Details       ${response}
    Status Should Be            200    ${response}
    ${actual_meta}              Get Meta
    Should Be Equal             ${actual_meta}    ${None}
    ${actual_data_id}           Get Data Configuration ID
    Should Be Equal As Numbers  ${actual_data_id}      ${VALID_ID}
    ${actual_data_name}         Get Data Configuration Name
    ${expected_data_name}       Get From Dictionary    ${REQ_VALID_OPTICAL_PAYLOAD}    name
    Should Be Equal As Strings  ${actual_data_name}    ${expected_data_name}
    ${actual_data_type}         Get Data Configuration Type
    ${expected_data_type}       Get From Dictionary    ${REQ_VALID_OPTICAL_PAYLOAD}    type
    Should Be Equal As Strings  ${actual_data_type}    ${expected_data_type}
    ${actual_data_cospar_id}    Get Data Configuration Cospar ID
    ${expected_data_cospar_id}  Get From Dictionary    ${REQ_VALID_OPTICAL_PAYLOAD}    cospar_id
    Should Be Equal As Strings  ${actual_data_cospar_id}    ${expected_data_cospar_id}
    ${actual_errors}            Get Errors
    Should Be Equal             ${actual_errors}  ${None}

TC02 - Retrieve Non-existent Configuration
    [Documentation]             Test retrieving satellite configuration with an invalid mission ID.
    [Tags]                      id:retrieve_02    service:retrieve
    ${response}                 GET On Session    api    ${CONFIGURATION_URL}/${INVALID_ID}    expected_status=404
    Save Response Details       ${response}
    Status Should Be            404    ${response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Resource Does Not Exist Error Message  ${INVALID_ID}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC03 - Boundary Test - Retrieve with ID as 0 or -1
    [Documentation]             Test retrieving configurations with boundary ID values.
    [Tags]                      id:retrieve_03    service:retrieve
    ${id}                       Set Variable    0
    ${response}                 GET On Session    api    ${CONFIGURATION_URL}/${id}    expected_status=404
    Save Response Details       ${response}
    Status Should Be            404    ${response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Resource Does Not Exist Error Message  ${id}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}
    ${id}                       Set Variable    -1
    ${response}                 GET On Session    api    ${CONFIGURATION_URL}/${id}    expected_status=404
    Save Response Details       ${response}
    Status Should Be            404    ${response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Resource Does Not Exist Error Message  ${id}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC04 - Retrieve with Invalid ID Format
    [Documentation]             Test the response when an invalid data format is passed as ID.
    [Tags]                      id:retrieve_04    service:retrieve
    ${response}                 GET On Session    api    ${CONFIGURATION_URL}/${INVALID_ID_FORMAT}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Parse Int Invalid Syntax Error Message  ${INVALID_ID_FORMAT}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC05 - Check Unauthorized Access
    [Documentation]             Verify the endpoint rejects requests from unauthorized users.
    [Tags]                      id:retrieve_05    service:retrieve
    ${response}                 GET On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{REQ_UNAUTHORIZED_HEADERS}
    ...                         expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${AUTHORIZATION_TOKEN_NOT_FOUND_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}