
SHELL := /bin/bash

# get auth token for FunctionGraph API calls
get_auth_token:
	mkdir -p temp
	$(eval OTC_X_AUTH_TOKEN := $(shell ./tokenFromUsername.sh))

FGS_enableAuth: get_auth_token
	
	$(eval MY_FUNCTION_URN := $(shell terraform output -raw function_urn)) 
	$(eval MY_FUNCTION_NAME := $(shell terraform output -raw function_name)) 
	$(eval ENABLE_AUTH_IN_HEADER := false)

	# get current function config	
	@curl -X GET \
	 -H "Content-Type: application/json" \
	 -H "x-auth-token: $(OTC_X_AUTH_TOKEN)" \
	 https://functiongraph.eu-de.otc.t-systems.com/v2/${OTC_SDK_PROJECTID}/fgs/functions/$(MY_FUNCTION_URN)/config \
	 -o ./temp/getconfig_response.json
	 cat ./temp/getconfig_response.json | jq .
	@echo "--------------------------------------------------------------"

	jq \
		--argjson enable $(ENABLE_AUTH_IN_HEADER) \
		'.enable_auth_in_header = $$enable | del(.type, .log_group_id, .log_stream_id, .enable_lts_log)' \
		./temp/getconfig_response.json > ./temp/config.json


	# update function config with auth

	@curl -X PUT \
	 -H "Content-Type: application/json" \
	 -H "x-auth-token: $(OTC_X_AUTH_TOKEN)" \
	 -d @./temp/config.json \
	 https://functiongraph.eu-de.otc.t-systems.com/v2/${OTC_SDK_PROJECTID}/fgs/functions/$(MY_FUNCTION_URN)/config \
	 -o ./temp/config_response.json
	 cat ./temp/config_response.json | jq .
	@echo "" 
	# finished