*** Settings ***
Documentation   Request data utilised by project's keywords and test cases

*** Variables ***
${VALID_ID}                           1
${INVALID_ID}                         9999  # Assumes this ID doesn't exist
${INVALID_ID_FORMAT}                  invalid_id
${UNKNOWN_PAYLOAD_FIELD}		      data_downlink_frequency_band
#
&{REQ_VALID_OPTICAL_PAYLOAD}          cospar_id=2024-111GR    name=New Satellite Mission      type=OPTICAL
&{REQ_VALID_OPTIC_PAYLOAD}            cospar_id=2024-111GR    name=New Satellite Mission      type=OPTIC
&{REQ_VALID_SAR_PAYLOAD}              cospar_id=2024-222UK    name=New Satellite Mission      type=SAR
&{REQ_VALID_SARS_PAYLOAD}             cospar_id=2024-222UK    name=New Satellite Mission      type=SARS
&{REQ_VALID_TELECOM_PAYLOAD}          cospar_id=2024-333RU    name=New Satellite Mission      type=TELECOM
#
&{REQ_VALID_OPTICAL_UPDATE}           cospar_id=2025-235BE    name=Updated Satellite Mission  type=OPTICAL
&{REQ_VALID_SAR_UPDATE}               cospar_id=2025-674NL    name=Updated Satellite Mission  type=SAR
&{REQ_VALID_TELECOM_UPDATE}           cospar_id=2025-284BR    name=Updated Satellite Mission  type=TELECOM
#
&{REQ_INVALID_COSPAR_ID_XXX}          cospar_id=INVALID       name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_-dddXX}       cospar_id=-567GR        name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YY-dddXX}     cospar_id=24-567GR      name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YYYY-XX}      cospar_id=2024-GR       name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YYYY-dXX}     cospar_id=2024-7GR      name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YYYY-ddd}     cospar_id=2024-567      name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YYYY-dddXXX}  cospar_id=2024-567GRE   name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YYYYdddXX}    cospar_id=2024567GR     name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YXYY-dddXX}   cospar_id=2O24-567GR    name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YYYY-XddXX}   cospar_id=2024-_67GR    name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YYYY-dddXd}   cospar_id=2024-567G8    name=New Satellite Mission      type=OPTICAL
&{REQ_INVALID_COSPAR_ID_YYYY-dddxx}   cospar_id=2024-567gr    name=New Satellite Mission      type=OPTICAL
#
&{REQ_INVALID_TYPE}                   cospar_id=2024-003ZZ    name=New Satellite Mission      type=UNKNOWN
&{REQ_INVALID_TYPE_LOWERCASE}         cospar_id=2024-003ZZ    name=New Satellite Mission      type=optical
#
&{REQ_MISSING_COSPAR_ID}                                      name=New Satellite Mission      type=OPTICAL
&{REQ_MISSING_NAME}                   cospar_id=2024-003ZZ                                    type=OPTICAL
&{REQ_MISSING_TYPE}                   cospar_id=2024-003ZZ    name=New Satellite Mission
#
${REQ_SQL_INJECTION_PAYLOAD}          id=1 OR 1=1
${REQ_CROSS_SITE_SCRIPTING_PAYLOAD}   id=<script>alert(document.cookie)</script>
#
&{REQ_UNAUTHORIZED_HEADERS}           Content-Type=application/json     Authorization=InvalidToken
#
&{REQ_INVALID_UNKNOWN_PAYLOAD_FIELD}  cospar_id=2024-333RU    name=New Satellite Mission      type=SAR      ${UNKNOWN_PAYLOAD_FIELD}=S-Band