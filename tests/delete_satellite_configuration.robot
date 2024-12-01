*** Settings ***
Documentation   Delete satellite configuration test cases
Library         RequestsLibrary
Library         JSONLibrary
Library         Collections
Library         String
Resource        ../keywords/common.robot
Resource        ../keywords/request_data.robot
Resource        ../keywords/response_data.robot
Suite Setup     Create Session with Satellite Configuration Service
Suite Teardown  Delete All Sessions with Satellite Configuration Service

*** Test Cases ***
TC01 - Delete Valid Configuration
    [Documentation]             Verify that a valid satellite configuration can be deleted successfully.
    [Tags]                      id:delete_01    service:delete
    [Setup]                     Run Keywords    Clear Mission Configuration Database
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_OPTICAL_PAYLOAD}
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_SAR_PAYLOAD}
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_TELECOM_PAYLOAD}
    ${response}                 DELETE On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         expected_status=200
    Save Response Details       ${response}
    Status Should Be            200    ${response}
    ${actual_meta}              Get Meta
    Should Be Equal             ${actual_meta}    ${None}
    ${actual_data_message}      Get Data Message
    Should Be Equal As Strings  ${actual_data_message}    ${MISSION_CONFIG_DELETED_DATA_MSG}
    ${actual_errors}            Get Errors
    Should Be Equal             ${actual_errors}    ${None}

TC02 - Delete Non-existent Configuration
    [Documentation]             Verify server response when trying to delete a non-existent configuration.
    [Tags]                      id:delete_02    service:delete
    ${response}                 DELETE On Session    api    ${CONFIGURATION_URL}/${INVALID_ID}    headers=&{HEADERS}
    ...                         expected_status=404
    Save Response Details       ${response}
    Status Should Be            404    ${response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Resource Does Not Exist Error Message  ${INVALID_ID}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC03 - Delete with Invalid ID Format
    [Documentation]             Verify server response when deleting with an invalid ID format.
    [Tags]                      id:delete_03    service:delete
    ${response}                 DELETE On Session    api    ${CONFIGURATION_URL}/${INVALID_ID_FORMAT}    headers=&{HEADERS}
    ...                         expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Parse Int Invalid Syntax Error Message  ${INVALID_ID_FORMAT}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC04 - Check Unauthorized Access
    [Documentation]             Verify the endpoint rejects requests from unauthorized users.
    [Tags]                      id:delete_04    service:delete
    ${response}                 DELETE On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{REQ_UNAUTHORIZED_HEADERS}
    ...                         expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${AUTHORIZATION_TOKEN_NOT_FOUND_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC05 - Boundary Test - Delete with ID as 0
    [Documentation]             Verify server response when trying to delete a configuration with ID=0.
    [Tags]                      id:delete_05    service:delete
    ${id}                       Set Variable    0
    ${response}                 DELETE On Session    api    ${CONFIGURATION_URL}/${id}    headers=&{HEADERS}
    ...                         expected_status=404
    Save Response Details       ${response}
    Status Should Be            404    ${response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Resource Does Not Exist Error Message  ${id}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC06 - Confirm Deletion of Valid ID
    [Documentation]             Confirm the satellite configuration is no longer retrievable after deletion.
    [Tags]                      id:delete_06    service:delete
    [Setup]                     Run Keywords    Clear Mission Configuration Database
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_OPTICAL_PAYLOAD}
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_SAR_PAYLOAD}
    ...                         AND  Populate Mission Configuration Database    &{REQ_VALID_TELECOM_PAYLOAD}
    ${delete_response}          DELETE On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         expected_status=200
    Save Response Details       ${delete_response}
    ${get_response}             GET On Session    api    ${CONFIGURATION_URL}/${VALID_ID}    headers=&{HEADERS}
    ...                         expected_status=404
    Save Response Details       ${get_response}
    Status Should Be            404    ${get_response}
    ${actual_error_message}     Get Error Message
    ${expected_error_message}   Build Resource Does Not Exist Error Message  ${VALID_ID}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}