# -*- coding: utf-8 -*-
# Required Libraries.

import logging
import sys
import requests



API_TOKEN_NOCODE = ""
API_TOKEN = ""
ORG = "dynatracedevops"
INSTANCE = "vsrm.dev.azure.com"
PROJECT = "devlove-alpha"
API_VERSION = "7.1"

AZDO_RELEASES_URL = "https://"+ INSTANCE + "/"+ORG+"/"+PROJECT+"/_apis/release/releases/"
AZDO_RELEASE_DEF_URL = "https://"+ INSTANCE + "/"+ORG+"/"+PROJECT+"/_apis/release/definitions/"

def get_header(api_token):
    """"Header builder"""
    return { "Accept":"*/*",
            "Connection": "keep-alive",
            "Cache-Control": "no-cache",
            "Authorization": "Basic " + api_token
              }


def get_release_by_id(id):
    return do_get(AZDO_RELEASES_URL + id)

def get_releases():
    return do_get(AZDO_RELEASES_URL)

def delete_release(id):
    response = do_delete(AZDO_RELEASES_URL + str(id))
    if (response.status_code == 204):
        logging.info("Release " + str(id)  + " has been deleted.")

    elif (response.status_code == 404):
        logging.info("Release " + str(id)  + " not found.")

    else:
        logging.info("Release " + str(id)  + " HTTP Status Code:" + str(response.status_code) + " Reason:" + response.text)
    return response


def do_get(endpoint):
    """Function get http request"""
    endpoint = endpoint + "?api-version=" + API_VERSION
    response = requests.get(endpoint, headers=get_header(API_TOKEN), verify=True, timeout=180)
    return response

def do_delete(endpoint):
    """Function get http request"""
    endpoint = endpoint + "?api-version=" + API_VERSION
    response = requests.delete(endpoint , headers=get_header(API_TOKEN), verify=True, timeout=180)
    return response


def main():
    
    logging.info("================= AzureDevOps Tooling ================================")

    #response = get_releases()
    #response = get_release_by_id(str(release))
    #response = delete_release(str(release))

    # Validate response, if not, print text
    for releaseId in range (7130, 7155):
        delete_release(releaseId)


if __name__ == '__main__':
    
    logging.basicConfig(filename='azdoactions.log', level=logging.INFO)
    logging.getLogger().addHandler(logging.StreamHandler(sys.stdout))

    main()
