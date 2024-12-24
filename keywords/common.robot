*** Settings ***
Documentation       Common project variables and keywords
Library             RequestsLibrary
Library             JSONLibrary

*** Variables ***
${BASE_URL}             http://localhost:1234
${CONFIGURATION_URL}    /configs
&{HEADERS}              Content-Type=application/json
${MAX_CONFIGS}          6

*** Keywords ***
Create Session with Satellite Configuration Service
    Create Session  api   ${BASE_URL}   headers=&{HEADERS}

Delete All Sessions with Satellite Configuration Service
    Delete All Sessions

Set Base URL of Satellite Configuration Service
    [Arguments]  ${base_url}=${BASE_URL}
    Set Suite Variable  ${BASE_URL}    ${base_url}

Save Response Details
    [Arguments]  ${response}
    Log  Status Code : ${response.status_code}
    Log  Response Body : ${response.text}
    ${response_json}    Convert String To JSON  ${response.text}
    Set Test Variable   ${RESPONSE_JSON}    ${response_json}

Get Data Configuration
    [Arguments]  ${data_index}
    RETURN  ${RESPONSE_JSON['data'][${data_index}]}

Get Data Configuration ID
    [Arguments]  ${data_index}=None
    IF  '${data_index}'=='None'
        RETURN  ${RESPONSE_JSON['data']['id']}
    ELSE
        RETURN  ${RESPONSE_JSON['data'][${data_index}]['id']}
    END

Get Data Configuration Name
    [Arguments]  ${data_index}=None
    IF  '${data_index}'=='None'
        RETURN  ${RESPONSE_JSON['data']['name']}
    ELSE
        RETURN  ${RESPONSE_JSON['data'][${data_index}]['name']}
    END

Get Data Configuration Type
    [Arguments]  ${data_index}=None
    IF  '${data_index}'=='None'
        RETURN  ${RESPONSE_JSON['data']['type']}
    ELSE
        RETURN  ${RESPONSE_JSON['data'][${data_index}]['type']}
    END

Get Data Configuration Cospar ID
    [Arguments]  ${data_index}=None
    IF  '${data_index}'=='None'
        RETURN  ${RESPONSE_JSON['data']['cospar_id']}
    ELSE
        RETURN  ${RESPONSE_JSON['data'][${data_index}]['cospar_id']}
    END

Get Data Message
    RETURN  ${RESPONSE_JSON['data']['message']}

Get Error Message
    RETURN  ${RESPONSE_JSON['errors'][0]['message']}

Get Error Source
    RETURN  ${RESPONSE_JSON['errors'][0]['source']}

Get Meta
    RETURN  ${RESPONSE_JSON['meta']}

Get Errors
    RETURN  ${RESPONSE_JSON['errors']}

Get Data
    RETURN  ${RESPONSE_JSON['data']}

Clear Mission Configuration Database
    # Get number of existing configurations.
    ${response}                  GET On Session  api  ${CONFIGURATION_URL}    expected_status=200
    Save Response Details        ${response}
    ${response_data}             Get Data
    ${number_of_configurations}  Get length  ${response_data}
    # Delete existing configurations.
    FOR  ${i}  IN RANGE  0  ${number_of_configurations}
        ${id}   Get Data Configuration ID    ${i}
        DELETE On Session    api    ${CONFIGURATION_URL}/${id}    headers=&{HEADERS}    expected_status=200
    END

Populate Mission Configuration Database
    [Arguments]  &{REQ_VALID_PAYLOAD}
    ${response}                 POST On Session  api    ${CONFIGURATION_URL}    headers=&{HEADERS}
    ...                         json=&{REQ_VALID_PAYLOAD}   expected_status=200
