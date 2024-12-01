*** Settings ***
Documentation   List satellite configurations test cases
Library         RequestsLibrary
Library         JSONLibrary
Library         String
Library         OperatingSystem
Library         Collections
Resource        ../keywords/common.robot
Resource        ../keywords/request_data.robot
Resource        ../keywords/response_data.robot
Suite Setup     Create Session with Satellite Configuration Service
Suite Teardown  Delete All Sessions with Satellite Configuration Service

*** Test Cases ***
TC01 - List Valid Configurations
    [Documentation]              Test for retrieving all configurations.
    [Tags]                       id:list_01    service:list
    [Setup]                      Run Keywords    Clear Mission Configuration Database
    ...                          AND  Populate Mission Configuration Database    &{REQ_VALID_OPTICAL_PAYLOAD}
    ...                          AND  Populate Mission Configuration Database    &{REQ_VALID_SAR_PAYLOAD}
    ...                          AND  Populate Mission Configuration Database    &{REQ_VALID_TELECOM_PAYLOAD}
    ${response}                  GET On Session    api    ${CONFIGURATION_URL}   expected_status=200
    Save Response Details        ${response}
    Status Should Be             200    ${response}
    ${actual_data}               Get Data
    Should Not Be Empty          ${actual_data}
    ${number_of_configurations}  Get length  ${actual_data}
    Should Be Equal As Integers  ${number_of_configurations}    3
    ${expected_configurations}   Create List  ${REQ_VALID_OPTICAL_PAYLOAD}   ${REQ_VALID_SAR_PAYLOAD}    ${REQ_VALID_TELECOM_PAYLOAD}
    FOR  ${id}  IN RANGE  0  ${number_of_configurations}
        ${actual_configuration}  Get Data Configuration    ${id}
        Remove From Dictionary   ${actual_configuration}   id
        Should Be Equal          ${actual_configuration}   ${expected_configurations}[${id}]
    END
    ${actual_meta}               Get Meta
    Should Be Equal              ${actual_meta}    ${None}
    ${actual_errors}             Get Errors
    Should Be Equal              ${actual_errors}  ${None}

TC02 - Boundary Condition - Validate with Empty Mission Configuration Database
    [Documentation]         Test for an empty database scenario.
    [Tags]                  id:list_02    service:list
    [Setup]                 Run Keywords    Clear Mission Configuration Database
    ${response}             GET On Session    api    ${CONFIGURATION_URL}   expected_status=200
    Save Response Details   ${response}
    Status Should Be        200    ${response}
    ${actual_data}          Get Data
    Should Be Empty         ${actual_data}
    ${actual_errors}        Get Errors
    Should Be Equal         ${actual_errors}  ${None}

TC03 - Test for SQL Injection Vulnerability
    [Documentation]         Attempt SQL Injection attack on the API and validate response.
    [Tags]                  id:list_03    service:list
    ${response}             GET On Session    api    ${CONFIGURATION_URL}?${REQ_SQL_INJECTION_PAYLOAD}   expected_status=400
    Save Response Details   ${response}
    Status Should Be        400    ${response}
    ${actual_data}          Get Data
    Should Be Empty         ${actual_data}

TC04 - Test for Cross-Site Scripting
    [Documentation]         Attempt Cross-Site Scripting attack on the API and validate response.
    [Tags]                  id:list_04    service:list
    ${response}             GET On Session    api    ${CONFIGURATION_URL}?${REQ_CROSS_SITE_SCRIPTING_PAYLOAD}   expected_status=400
    Save Response Details   ${response}
    Status Should Be        400    ${response}
    ${actual_data}          Get Data
    Should Be Empty         ${actual_data}

TC05 - Check Unauthorized Access
    [Documentation]             Verify the endpoint rejects requests from unauthorized users.
    [Tags]                      id:list_05    service:list
    ${response}                 GET On Session  api    ${CONFIGURATION_URL}    headers=&{REQ_UNAUTHORIZED_HEADERS}
    ...                         expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${AUTHORIZATION_TOKEN_NOT_FOUND_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}