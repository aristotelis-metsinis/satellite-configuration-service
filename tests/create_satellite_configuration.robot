*** Settings ***
Documentation   Create satellite configuration test cases
Library         RequestsLibrary
Library         Collections
Library         JSONLibrary
Resource        ../keywords/common.robot
Resource        ../keywords/request_data.robot
Resource        ../keywords/response_data.robot
Resource        ../keywords/create_satellite_configuration_steps.robot
Suite Setup     Create Session with Satellite Configuration Service
Suite Teardown  Delete All Sessions with Satellite Configuration Service

*** Test Cases ***
TC01 - Create Valid Configuration
    [Documentation]     Test that a valid satellite configuration can be created (for each possible payload type).
    [Tags]              id:create_01    service:create
    [Setup]             Clear Mission Configuration Database
    [Template]          Create Satellite Configuration
    &{REQ_VALID_OPTICAL_PAYLOAD}
    &{REQ_VALID_SAR_PAYLOAD}
    &{REQ_VALID_TELECOM_PAYLOAD}

TC02 - Invalid COSPAR ID
    [Documentation]     Test that an invalid COSPAR ID value returns a specific error (for different COSPAR ID formats).
    [Tags]              id:create_02    service:create
    [Template]          Create Satellite Configuration with Invalid COSPAR ID
    &{REQ_INVALID_COSPAR_ID_XXX}
    &{REQ_INVALID_COSPAR_ID_-dddXX}
    &{REQ_INVALID_COSPAR_ID_YY-dddXX}
    &{REQ_INVALID_COSPAR_ID_YYYY-XX}
    &{REQ_INVALID_COSPAR_ID_YYYY-dXX}
    &{REQ_INVALID_COSPAR_ID_YYYY-ddd}
    &{REQ_INVALID_COSPAR_ID_YYYY-dddXXX}
    &{REQ_INVALID_COSPAR_ID_YYYYdddXX}
    &{REQ_INVALID_COSPAR_ID_YXYY-dddXX}
    &{REQ_INVALID_COSPAR_ID_YYYY-XddXX}
    &{REQ_INVALID_COSPAR_ID_YYYY-dddXd}
    &{REQ_INVALID_COSPAR_ID_YYYY-dddxx}

TC03 - Invalid Type
    [Documentation]             Test that an invalid TYPE value returns a specific error.
    [Tags]                      id:create_03    service:create
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_INVALID_TYPE}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${INVALID_PAYLOAD_TYPE_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_INVALID_TYPE_LOWERCASE}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${INVALID_PAYLOAD_TYPE_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}

TC04 - Missing COSPAR ID
    [Documentation]             Test that the request fails if the COSPAR ID field is missing.
    [Tags]                      id:create_04    service:create
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_MISSING_COSPAR_ID}   expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${REQUIRED_COSPAR_ID_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}

TC05 - Missing Name
    [Documentation]             Test that the request fails if the NAME field is missing.
    [Tags]                      id:create_05    service:create
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_MISSING_NAME}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400    ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${REQUIRED_NAME_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}

TC06 - Missing Type
    [Documentation]             Test that the request fails if the TYPE field is missing.
    [Tags]                      id:create_06    service:create
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_MISSING_TYPE}    expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}   ${REQUIRED_PAYLOAD_TYPE_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}    ${DATA_SERVER_ERROR_SOURCE}

TC07 - Boundary Test for Exceeding Maximum Configurations
    [Documentation]              Test for the server’s response when exceeding the maximum number of configurations.
    [Tags]                       id:create_07    service:create
    # Get number of existing configurations.
    ${response}                  GET On Session  api  ${CONFIGURATION_URL}    expected_status=200
    Save Response Details        ${response}
    ${response_data}             Get Data
    ${number_of_configurations}  Get length  ${response_data}
    # Create configurations exceeding maximum.
    FOR  ${i}  IN RANGE  ${number_of_configurations} + 1  ${MAX_CONFIGS} + 2
        &{payload}              Create Dictionary   cospar_id=202${i}-00${i}ZZ  name=New Satellite ${i}    type=OPTICAL
        ${response}             POST On Session     api  ${CONFIGURATION_URL}    headers=&{HEADERS}
        ...                     json=&{payload}  expected_status=anything
        Save Response Details   ${response}
        ${expected_status}      Evaluate  200 if ${i} <= ${MAX_CONFIGS} else 400
        ${expected_status}      Convert To String   ${expected_status}
        Status Should Be        ${expected_status}  ${response}
        IF  ${i} > ${MAX_CONFIGS}
            ${actual_error_message}     Get Error Message
            Should Be Equal As Strings  ${actual_error_message}    ${FULL_MISSION_CONFIG_DATABASE_ERROR_MSG}
            ${actual_error_source}      Get Error Source
            Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}
        END
    END

TC08 - Check Unauthorized Access
    [Documentation]             Verify the endpoint rejects requests from unauthorized users.
    [Tags]                      id:create_08    service:create
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{REQ_UNAUTHORIZED_HEADERS}
    ...                         json=&{REQ_VALID_OPTICAL_PAYLOAD}   expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${AUTHORIZATION_TOKEN_NOT_FOUND_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}

TC09 - Unknown Payload Field
    [Documentation]             Verify the endpoint rejects requests with unknown payload field.
    [Tags]                      id:create_09    service:create
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_INVALID_UNKNOWN_PAYLOAD_FIELD}   expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
	${expected_error_message}   Build Unknown Field Error Message  ${UNKNOWN_PAYLOAD_FIELD}
    Should Be Equal As Strings  ${actual_error_message}    ${expected_error_message}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}

TC10 - Malformed JSON
    [Documentation]             Verify the endpoint rejects requests when the JSON request body is malformed.
    [Tags]                      id:create_10    service:create
	${malformed_payload}        Set Variable    {"cospar_id": "2024-003ZZ", "name": "New Satellite"
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         data=${malformed_payload}   expected_status=400
    Save Response Details       ${response}
    Status Should Be            400   ${response}
    ${actual_error_message}     Get Error Message
    Should Be Equal As Strings  ${actual_error_message}    ${UNEXPECTED_EOF_ERROR_MSG}
    ${actual_error_source}      Get Error Source
    Should Be Equal As Strings  ${actual_error_source}     ${DATA_SERVER_ERROR_SOURCE}
