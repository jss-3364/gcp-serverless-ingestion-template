# Load automatically .env file
ifneq (,$(wildcard .env))
    include .env
    export
else
    $(error ❌ No .env file found! Please copy .env.example and fill in your values)
endif

# ------------------------------------------------------
# Check mandatory variables
# ------------------------------------------------------
# GCP informations
ifeq ($(strip $(PROJECT_ID)),)
    $(error ❌ Missing PROJECT_ID in .env)
endif

ifeq ($(strip $(REGION)),)
    $(error ❌ Missing REGION in .env)
endif

ifeq ($(strip $(TERRAFORM_BUCKET_NAME)),)
    $(error ❌ Missing TERRAFORM_BUCKET_NAME in .env)
endif

# ------------------------------------------------------
# Folders
# ------------------------------------------------------
BOOTSTRAP_TF_DIR := .infrastructure/terraform/_bootstrap

# ======================================================
# HELP
# ======================================================
.PHONY: help
help:
	@echo ""
	@echo "📘 Available commands:"
	@echo "  make bootstrap-deployment      → Deploy the bootstrap project (bucket)"
	@echo ""

# ======================================================
# TERRAFORM - Bootstrap
# ======================================================
.PHONY: bootstrap-deployment
bootstrap-deployment:
	cd $(BOOTSTRAP_TF_DIR) && \
	TF_VAR_project_id=$(PROJECT_ID) TF_VAR_region=$(REGION) TF_VAR_tf_state_bucket=$(TERRAFORM_BUCKET_NAME) terraform init && \
	TF_VAR_project_id=$(PROJECT_ID) TF_VAR_region=$(REGION) TF_VAR_tf_state_bucket=$(TERRAFORM_BUCKET_NAME) terraform plan && \
	TF_VAR_project_id=$(PROJECT_ID) TF_VAR_region=$(REGION) TF_VAR_tf_state_bucket=$(TERRAFORM_BUCKET_NAME) terraform apply -auto-approve
