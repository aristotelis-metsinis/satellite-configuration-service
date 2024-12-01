*** Settings ***
Documentation   Variables and keywords used by 'create satellite configuration' test cases
Library         RequestsLibrary
Resource        ../keywords/common.robot
Resource        ../keywords/response_data.robot

*** Keywords ***
Create Satellite Configuration
    [Arguments]  &{REQ_VALID_PAYLOAD}
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_VALID_PAYLOAD}   expected_status=200
    Save Response Details       ${response}
    Status Should Be            200   ${response}
    ${actual_meta}              Get Meta
    Should Be Equal             ${actual_meta}    ${None}
    ${actual_data_message}      Get Data Message
    Should Be Equal As Strings  ${actual_data_message}   ${MISSION_CONFIG_CREATED_DATA_MSG}
    ${actual_errors}            Get Errors
    Should Be Equal             ${actual_errors}    ${None}

Create Satellite Configuration with Invalid COSPAR ID
    [Arguments]  &{REQ_INVALID_COSPAR_ID}
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_INVALID_COSPAR_ID}   expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${INVALID_COSPAR_ID_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}