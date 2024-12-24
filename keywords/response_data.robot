*** Settings ***
Documentation   Response data processed by project's keywords and test cases
Library         String

*** Variables ***
${MISSION_CONFIG_CREATED_DATA_MSG}          Mission config created successfully.
${MISSION_CONFIG_UPDATED_DATA_MSG}          Mission config updated successfully.
${MISSION_CONFIG_DELETED_DATA_MSG}          Mission config deleted successfully.
${INVALID_COSPAR_ID_ERROR_MSG}	            invalid request due to invalid COSPAR ID
${INVALID_PAYLOAD_TYPE_ERROR_MSG}           invalid request due to invalid payload type
${REQUIRED_COSPAR_ID_ERROR_MSG}	            invalid request due to cospar ID is required
${REQUIRED_NAME_ERROR_MSG}                  invalid request due to name is required
${REQUIRED_PAYLOAD_TYPE_ERROR_MSG}          invalid request due to payload type is required
${FULL_MISSION_CONFIG_DATABASE_ERROR_MSG}   invalid request due to mission config database is full
${AUTHORIZATION_TOKEN_NOT_FOUND_ERROR_MSG}  Could not read token, authorization token not found
${RESOURCE_DOES_NOT_EXIST_ERROR_MSG}	    'resource 'INVALID_ID_PLACEHOLDER' of type 'Mission'' does not exist
${PARSE_INT_INVALID_SYNTAX_ERROR_MSG}	    invalid request due to strconv.ParseInt: parsing \"INVALID_ID_FORMAT_PLACEHOLDER\": invalid syntax
${CANNOT_UNMARSHAL_STRING_ERROR_MSG}	    invalid request due to json: cannot unmarshal string into Go value of type missionconfig.UpdateMissionConfig
${UNKNOWN_FIELD_ERROR_MSG}                  invalid request due to json: unknown field \"UNKNOWN_FIELD_PLACEHOLDER\"
${UNEXPECTED_EOF_ERROR_MSG}                 invalid request due to unexpected EOF
${DATA_SERVER_ERROR_SOURCE}                 data-server

*** Keywords ***
Build Resource Does Not Exist Error Message
    [Arguments]  ${INVALID_ID}
    ${message}  Replace String	${RESOURCE_DOES_NOT_EXIST_ERROR_MSG}	INVALID_ID_PLACEHOLDER	${INVALID_ID}
    RETURN  ${message}

Build Parse Int Invalid Syntax Error Message
    [Arguments]  ${INVALID_ID_FORMAT}
    ${message}  Replace String	${PARSE_INT_INVALID_SYNTAX_ERROR_MSG}	INVALID_ID_FORMAT_PLACEHOLDER	${INVALID_ID_FORMAT}
    RETURN  ${message}

Build Unknown Field Error Message
    [Arguments]  ${UNKNOWN_FIELD}
    ${message}  Replace String	${UNKNOWN_FIELD_ERROR_MSG}	UNKNOWN_FIELD_PLACEHOLDER	${UNKNOWN_FIELD}
    RETURN  ${message}
