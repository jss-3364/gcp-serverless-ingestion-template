# Terraform Bootstrap

This directory contains the Terraform configuration for bootstrapping the GCP infrastructure required for this project. The bootstrap process sets up the foundational resources needed before deploying the main infrastructure.

## Overview

The bootstrap Terraform configuration creates:

1. **Cloud Storage Bucket**: A GCS bucket for storing Terraform state files
2. **Artifact Registry Repository**: A Docker repository for storing Python container images used by Cloud Run
3. **GCP API Services**: Enables required Google Cloud APIs for the project

## Prerequisites

Before running the bootstrap, ensure you have:

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured
- Authenticated with GCP: `gcloud auth application-default login`
- A GCP project created
- Required permissions in the GCP project:
  - `roles/storage.admin` (to create the state bucket)
  - `roles/serviceusage.serviceUsageAdmin` (to enable APIs)
  - `roles/resourcemanager.projectIamAdmin` (if managing IAM)

## Required Variables

The following variables must be provided (via environment variables or `.env` file):

- `PROJECT_ID`: Your GCP project ID
- `REGION`: The GCP region (e.g., `europe-west1`)
- `TERRAFORM_BUCKET_NAME`: Name for the Terraform state bucket

## Files Description

### `cloud_storage.tf`
Contains the Cloud Storage bucket resource:
- `google_storage_bucket.tf_state_bucket`: Creates the GCS bucket for Terraform state

### `artifact_registry.tf`
Contains the Artifact Registry repository:
- `google_artifact_registry_repository.python_artifacts`: Creates a Docker repository for Python container images
  - Configured with immutable tags
  - Cleanup policy to keep the 5 most recent versions

### `providers.tf`
Configures the Terraform providers and API services:
- Google Cloud Provider version configuration
- Sets default labels for all resources
- `google_project_service.enable_apis`: Enables required GCP APIs

### `variables.tf`
Defines input variables:
- `project_id`: GCP project ID (required)
- `location`: GCP region (defaults to `europe-west1`)
- `tf_state_bucket`: Name for the Terraform state bucket (required)

### `backend.tf`
Defines the Terraform backend configuration (currently using local state for bootstrap)

### `locals.tf`
Defines local values:
- Maps variables to locals
- Lists GCP APIs to enable (compute, storage, and artifact registry)
- Defines the Artifact Registry repository name

## Usage

### Using Makefile (Recommended)

From the project root, run:

```bash
make bootstrap-deployment
```

This command will:
1. Navigate to the bootstrap directory
2. Initialize Terraform
3. Plan the changes
4. Apply the changes automatically

### Manual Execution

If you prefer to run Terraform manually:

```bash
cd .infrastructure/terraform/bootstrap

# Set environment variables
export TF_VAR_project_id="your-project-id"
export TF_VAR_region="europe-west1"
export TF_VAR_tf_state_bucket="your-bucket-name"

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the changes
terraform apply
```

## What Gets Created

After successful execution, you will have:

1. **GCS Bucket**: `gs://<TERRAFORM_BUCKET_NAME>/`
   - Location: Your specified region
   - Purpose: Store Terraform state files for subsequent deployments

2. **Artifact Registry Repository**: `python-artifacts-repo`
   - Location: Your specified region
   - Format: DOCKER
   - Purpose: Store Python container images for Cloud Run services
   - Features:
     - Immutable tags enabled
     - Automatic cleanup policy (keeps 5 most recent versions)

3. **Enabled APIs**:
   - `compute.googleapis.com`
   - `storage.googleapis.com`
   - `artifactregistry.googleapis.com`

## Important Notes

⚠️ **First-Time Setup**: This bootstrap must be run before any other Terraform deployments, as it creates the state bucket that other Terraform configurations will use.

⚠️ **State Management**: The bootstrap itself uses local state initially. After the bucket is created, you may want to migrate the bootstrap state to the bucket as well (optional in my case).

⚠️ **Force Destroy**: The state bucket has `force_destroy = true`, meaning it can be deleted even if it contains objects. Use with caution in production environments.

## Troubleshooting

### Error: "Bucket name already exists"
- The bucket name must be globally unique across all GCP projects
- Choose a different name for `TERRAFORM_BUCKET_NAME`

### Error: "Permission denied"
- Ensure you have the required IAM roles in the GCP project
- Verify your authentication: `gcloud auth list`

### Error: "API not enabled"
- Some APIs may require additional permissions or project settings
- Check the [GCP Service Usage documentation](https://cloud.google.com/service-usage/docs)

## Next Steps

After successfully bootstrapping:

1. Verify the bucket was created: `gsutil ls gs://<TERRAFORM_BUCKET_NAME>`
2. Verify the Artifact Registry repository was created: `gcloud artifacts repositories list --location=<REGION>`
3. Proceed with deploying the main infrastructure
4. Configure backend state for other Terraform modules to use this bucket

