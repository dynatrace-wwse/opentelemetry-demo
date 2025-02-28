#!/bin/sh

export dt_clientid="dt0s02.R47E3EZ4"
export dt_clientsecret="dt0s02.R47EXX.XXX"
export dt_tenant_url="https://sro97894.apps.dynatrace.com"
export dt_event_wf="d773094d-2f64-435d-a255-3b65fa8c20eb"
export dt_validation_wf_id_staging="d773094d-2f64-435d-a255-3b65fa8c20eb"

echo "check variables from last step"
env
echo "start reading functions"

create_token() {
    echo "****   Create Token    *****"
    result=$(curl --request POST 'https://sso.dynatrace.com/sso/oauth2/token' \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data 'grant_type=client_credentials&client_id='$dt_clientid'&client_secret='$dt_clientsecret'')
    echo $result
    result_dyna=$(echo $result | jq -r '.access_token')
    echo "created Token"
    echo $result_dyna
}

get_validation_status() {
    echo " -----   get_validation_status -----  "
    create_token
    curl -X 'GET' \
        "$dt_tenant_url/platform/automation/v1/executions/$(echo $id)" \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        -H "authorization: Bearer $(echo $result_dyna)" | jq -r '.state'
}

get_result() {
    echo " -----    get_result  ----- "
    create_token
    rex=$(curl -X 'GET' \
        "$dt_tenant_url/platform/automation/v1/executions/$(echo $id)/tasks" \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        -H "authorization: Bearer $(echo $result_dyna)")
    echo $rex
    validationresult=$(echo $rex | jq -r '.run_validation.result.validation_status')
    validationurl=$(echo $rex | jq -r '.run_validation.result.validation_url')
    jira=$(echo $rex | jq -r '.create_tracking_task.result.key')
    jiraurl=$(echo $rex | jq -r '.create_tracking_task.result.url')
    echo $jira
    echo $jiraurl
    echo $validationresult
    echo $validationurl
    echo "##vso[task.setvariable variable=validationresult;]$validationresult"
    echo "##vso[task.setvariable variable=jira;]$jira"
    echo "##vso[task.setvariable variable=validationurl;]$validationurl"
    if [ "$validationresult" == "fail" ] || [ "$validationresult" == "warning" ] || [ "$validationresult" == "error" ]; then
        echo "the release validation has failed"
        exit 1
    else
        echo "the release validation was successful"
    fi
}

start_validation_wf() {
    echo " -----    start_validation_wf  ----- "
    create_token
    res=$(curl -X 'POST' \
        "$dt_tenant_url/platform/automation/v1/workflows/$dt_validation_wf_id_staging/run" \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        -H "authorization: Bearer $(echo $result_dyna)" \
        -d '{
         "params": {
            "Release": $(Release.ReleaseId),
            "PROBLEM": "$(PROBLEM)",
            "Pipelineurl": "$(Release.ReleaseWebURL)",
            "test_start_timestamp": "$(start_timestamp)",
            "test_stop_timestamp": "$(stop_timestamp)",
            "stage": "$(ENVIRONMENT)",
            "Repository": "$(REPOSITORY)",
            "Release_Version": "$(DT_RELEASE_VERSION)",
            "Application": "$(APPLICATION)",
            "Namespace": "$(NAMESPACE)",
            "Build_Version": "$(DT_RELEASE_BUILD_VERSION)"       
         }
         }')
    id=$(echo $res | jq -r '.id')
    echo $id
    while [[ $get_validation_status == "RUNNING" ]]; do
        sleep 30
    done

}

start_test_wf() {
    echo " -----    start_test_wf  ----- "
    create_token
    res=$(curl -X 'POST' \
        "$dt_tenant_url/platform/automation/v1/workflows/$dt_event_wf/run" \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        -H "authorization: Bearer $(echo $result_dyna)" \
        -d '{
         "params": {
            "event_type": "END_TEST",
            "PROBLEM": "$(PROBLEM)",
            "Release": $(Release.ReleaseId),
            "Pipelineurl": "$(Release.ReleaseWebURL)",
            "stage": "$(ENVIRONMENT)",
            "Repository": "$(REPOSITORY)",
            "Release_Version": "$(DT_RELEASE_VERSION)",
            "Application": "$(APPLICATION)",
            "Namespace": "$(NAMESPACE)",
            "Build_Version": "$(DT_RELEASE_BUILD_VERSION)"            
         }
         }')
    echo $res
    id=$(echo $res | jq -r '.id')
    echo $id
    #while [[ $(get_wf_status) == "RUNNING" ]]; do
    #sleep 10
    #done

}

main() {
    start_test_wf
    sleep 30
    start_validation_wf
    get_result

}

main
