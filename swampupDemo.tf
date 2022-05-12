# Required for Terraform 0.13 and up (https://www.terraform.io/upgrade-guides/0-13.html)
terraform {
  required_providers {
    artifactory = {
      source  = "registry.terraform.io/jfrog/artifactory"
      version = "6.6.1"
    }
    xray = {
      source  = "registry.terraform.io/jfrog/xray"
      version = "1.1.1"
    }
    project = {
      source  = "registry.terraform.io/jfrog/project"
      version = "1.1.0"
    }
  }
}

provider "artifactory" {
  url = "https://swampup-demo-fix-rt.jfrog.tech/"
}

provider "xray" {
  url = "https://swampup-demo-fix-rt.jfrog.tech/"
}

provider "project"{
  url = "https://swampup-demo-fix-rt.jfrog.tech/"
}

# Artifactory provider

resource "artifactory_user" "dev-user" {
  name  	= "developer"
  password  = "Passw0rd!"
  email 	= "dummy_user-dev@jfrog.com"
  groups    = [ "readers" ]
}

resource "artifactory_user" "qa-user" {
  name  	= "qa-tester"
  password  = "Passw0rd!"
  email 	= "dummy_user-qa@jfrog.com"
  groups    = [ "readers" ]
}

resource "artifactory_group" "dev-group" {
  name             = "terraform"
  description      = "dev group"
  admin_privileges = false
  users_names      = [ "qa-tester", "developer" ]
}

resource "artifactory_local_bower_repository" "bower-local" {
  key         = "bower-local"
  description = "Repo created by Terraform Provider Artifactory"
  xray_index  = true
}

resource "artifactory_local_cargo_repository" "cargo-local" {
  key         = "cargo-local"
  description = "Repo created by Terraform Provider Artifactory"
  xray_index  = true
}

resource "artifactory_local_cran_repository" "cran-local" {
  key         = "cran-local"
  description = "Repo created by Terraform Provider Artifactory"
  xray_index  = true
}

resource "artifactory_local_docker_v2_repository" "docker-local" {
  key             = "docker-local"
  tag_retention   = 3
  max_unique_tags = 5
  xray_index      = true
}

resource "artifactory_local_generic_repository" "generic-local" {
  key         = "generic-local"
  description = "Repo created by Terraform Provider Artifactory"
  xray_index  = true
}

resource "artifactory_local_go_repository" "go-local" {
  key         = "go-local"
  description = "Repo created by Terraform Provider Artifactory"
  xray_index  = true
}

resource "artifactory_local_maven_repository" "maven-local" {
  key                             = "maven-local"
  checksum_policy_type            = "client-checksums"
  snapshot_version_behavior       = "unique"
  max_unique_snapshots            = 10
  handle_releases                 = true
  handle_snapshots                = true
  suppress_pom_consistency_checks = false
  xray_index                      = true
}

resource "artifactory_local_npm_repository" "npm-local" {
  key         = "npm-local"
  description = "Repo created by Terraform Provider Artifactory"
  xray_index  = true
}

resource "artifactory_local_nuget_repository" "nuget-local" {
  key                        = "nuget-local"
  max_unique_snapshots       = 10
  force_nuget_authentication = true
  xray_index                 = true
}

resource "artifactory_local_pypi_repository" "pypi-local" {
  key         = "pypi-local"
  description = "Repo created by Terraform Provider Artifactory"
  xray_index  = true
}

resource "artifactory_remote_bower_repository" "bower-remote" {
  key              = "bower-remote"
  url              = "https://github.com/"
  vcs_git_provider = "GITHUB"
  xray_index       = true
}

resource "artifactory_remote_cargo_repository" "cargo-remote" {
  key              = "cargo-remote"
  anonymous_access = true
  url              = "https://github.com/"
  git_registry_url = "https://github.com/rust-lang/foo.index"
  xray_index       = true
}

resource "artifactory_remote_debian_repository" "debian-remote" {
  key        = "debian-remote"
  url        = "http://archive.ubuntu.com/ubuntu/"
  xray_index = true
}

resource "artifactory_remote_docker_repository" "docker-remote" {
  key                            = "docker-remote"
  external_dependencies_enabled  = true
  external_dependencies_patterns = ["**/hub.docker.io/**", "**/bintray.jfrog.io/**"]
  enable_token_authentication    = true
  url                            = "https://hub.docker.io/"
  block_pushing_schema1          = true
  xray_index                     = true
}

resource "artifactory_remote_go_repository" "go-remote" {
  key              = "go-remote"
  url              = "https://proxy.golang.org/"
  vcs_git_provider = "ARTIFACTORY"
  xray_index       = true
}

resource "artifactory_remote_maven_repository" "maven-remote" {
  key                             = "maven-remote"
  url                             = "https://repo1.maven.org/maven2/"
  fetch_jars_eagerly              = true
  fetch_sources_eagerly           = false
  suppress_pom_consistency_checks = false
  reject_invalid_jars             = true
}

resource "artifactory_remote_npm_repository" "npm-remote" {
  key                                  = "npm-remote"
  url                                  = "https://registry.npmjs.org/"
  list_remote_folder_items             = true
  mismatching_mime_types_override_list = "application/json,application/xml"
  xray_index                           = true
}

resource "artifactory_remote_nuget_repository" "nuget-remote" {
  key                        = "nuget-remote"
  url                        = "https://www.nuget.org/"
  download_context_path      = "api/v2/package"
  force_nuget_authentication = true
  v3_feed_url                = "https://api.nuget.org/v3/index.json"
  xray_index                 = true
}

resource "artifactory_remote_pypi_repository" "pypi_remote" {
  key               = "pypi-remote"
  url               = "https://files.pythonhosted.org"
  pypi_registry_url = "https://custom.PYPI.registry.url"
  xray_index        = true
}


resource "artifactory_virtual_bower_repository" "bower-virtual" {
  key                           = "bower-virtual"
  repositories                  = [
    artifactory_local_bower_repository.bower-local.key,
    artifactory_remote_bower_repository.bower-remote.key,
  ]
  description                   = "A test virtual repo"
  notes                         = "Internal description"
  includes_pattern              = "com/jfrog/**,cloud/jfrog/**"
  excludes_pattern              = "com/google/**"
  external_dependencies_enabled = false
}


resource "artifactory_virtual_cran_repository" "cran-virtual" {
  key              = "cran-virtual"
  repositories     = []
  description      = "A test virtual repo"
  notes            = "Internal description"
  includes_pattern = "com/jfrog/**,cloud/jfrog/**"
  excludes_pattern = "com/google/**"
}


resource "artifactory_virtual_docker_repository" "docker-virtual" {
  key = "docker-virtual"
  repositories = [
    artifactory_local_docker_v2_repository.docker-local.key,
    artifactory_remote_docker_repository.docker-remote.key
  ]
  description      = "A test virtual repo"
  notes            = "Internal description"
  includes_pattern = "com/jfrog/**,cloud/jfrog/**"
  excludes_pattern = "com/google/**"
}


resource "artifactory_virtual_go_repository" "go-virtual" {
  key                           = "go-virtual"
  repo_layout_ref               = "go-default"
  repositories                  = []
  description                   = "A test virtual repo"
  notes                         = "Internal description"
  includes_pattern              = "com/jfrog/**,cloud/jfrog/**"
  excludes_pattern              = "com/google/**"
  external_dependencies_enabled = true
  external_dependencies_patterns = [
    "**/github.com/**",
    "**/go.googlesource.com/**"
  ]
}


resource "artifactory_virtual_maven_repository" "maven-virtual" {
  key             = "maven-virtual"
  repo_layout_ref = "maven-2-default"
  repositories = [
    artifactory_local_maven_repository.maven-local.key,
    artifactory_remote_maven_repository.maven-remote.key
  ]
  description                              = "A test virtual repo"
  notes                                    = "Internal description"
  includes_pattern                         = "com/jfrog/**,cloud/jfrog/**"
  excludes_pattern                         = "com/google/**"
  force_maven_authentication               = true
  pom_repository_references_cleanup_policy = "discard_active_reference"
}

resource "artifactory_virtual_npm_repository" "npm-virtual" {
  key              = "npm-virtual"
  repositories     = []
  description      = "A test virtual repo"
  notes            = "Internal description"
  includes_pattern = "com/jfrog/**,cloud/jfrog/**"
  excludes_pattern = "com/google/**"
}

resource "artifactory_virtual_nuget_repository" "nuget-virtual" {
  key                        = "nuget-virtual"
  repositories               = []
  description                = "A test virtual repo"
  notes                      = "Internal description"
  includes_pattern           = "com/jfrog/**,cloud/jfrog/**"
  excludes_pattern           = "com/google/**"
  force_nuget_authentication = true
}


resource "artifactory_virtual_pypi_repository" "pypi-virtual" {
  key              = "pypi-virtual"
  repositories     = []
  description      = "A test virtual repo"
  notes            = "Internal description"
  includes_pattern = "com/jfrog/**,cloud/jfrog/**"
  excludes_pattern = "com/google/**"
}


resource "artifactory_artifact_webhook" "artifact-webhook" {
  key         = "artifact-webhook"
  event_types = ["deployed", "deleted", "moved", "copied"]
  criteria {
    any_local        = true
    any_remote       = false
    repo_keys        = [artifactory_local_maven_repository.maven-local.key]
    include_patterns = ["foo/**"]
    exclude_patterns = ["bar/**"]
  }
  url    = "http://tempurl.org/webhook"
  secret = "some-secret"

  custom_http_headers = {
    header-1 = "value-1"
    header-2 = "value-2"
  }

  depends_on = [artifactory_local_maven_repository.maven-local]
}

resource "artifactory_artifact_property_webhook" "artifact-property-webhook" {
  key         = "artifact-prop-webhook"
  event_types = ["added", "deleted"]
  criteria {
    any_local        = true
    any_remote       = false
    repo_keys        = [artifactory_local_maven_repository.maven-local.key]
    include_patterns = ["foo/**"]
    exclude_patterns = ["bar/**"]
  }
  url    = "http://tempurl.org/webhook"
  secret = "some-secret"

  custom_http_headers = {
    header-1 = "value-1"
    header-2 = "value-2"
  }

  depends_on = [artifactory_local_maven_repository.maven-local]
}

resource "artifactory_docker_webhook" "docker-webhook" {
  key         = "docker-webhook"
  event_types = ["pushed", "deleted", "promoted"]
  criteria {
    any_local        = true
    any_remote       = false
    repo_keys        = [artifactory_local_docker_v2_repository.docker-local.key]
    include_patterns = ["foo/**"]
    exclude_patterns = ["bar/**"]
  }
  url    = "http://tempurl.org/webhook"
  secret = "some-secret"

  custom_http_headers = {
    header-1 = "value-1"
    header-2 = "value-2"
  }

  depends_on = [artifactory_local_docker_v2_repository.docker-local]
}

# Xray provider

resource "random_id" "randid" {
  byte_length = 2
}

resource "xray_security_policy" "security" {
  name        = "test-security-policy-severity-${random_id.randid.dec}"
  description = "Security policy description"
  type        = "security"

  rule {
    name     = "rule-name-severity"
    priority = 1

    criteria {
      min_severity          = "High"
      fix_version_dependant = false
    }

    actions {
      webhooks                           = []
      mails                              = ["test@email.com"]
      block_release_bundle_distribution  = true
      fail_build                         = true
      notify_watch_recipients            = true
      notify_deployer                    = true
      create_ticket_enabled              = false // set to true only if Jira integration is enabled
      build_failure_grace_period_in_days = 5     // use only if fail_build is enabled

      block_download {
        unscanned = true
        active    = true
      }
    }
  }
}

resource "xray_license_policy" "license" {
  name        = "test-license-policy-allowed-${random_id.randid.dec}"
  description = "License policy, allow certain licenses"
  type        = "license"

  rule {
    name     = "License_rule"
    priority = 1

    criteria {
      allowed_licenses         = ["Apache-1.0", "Apache-2.0"]
      allow_unknown            = false
      multi_license_permissive = true
    }

    actions {
      webhooks                           = []
      mails                              = ["test@email.com"]
      block_release_bundle_distribution  = false
      fail_build                         = true
      notify_watch_recipients            = true
      notify_deployer                    = true
      create_ticket_enabled              = false // set to true only if Jira integration is enabled
      custom_severity                    = "High"
      build_failure_grace_period_in_days = 5 // use only if fail_build is enabled

      block_download {
        unscanned = true
        active    = true
      }
    }
  }
}

resource "xray_watch" "docker-repository" {
  name        = "docker-repository-watch-${random_id.randid.dec}"
  description = "Watch a single repo or a list of repositories"
  active      = true

  watch_resource {
    type       = "repository"
    bin_mgr_id = "default"
    name       = artifactory_local_docker_v2_repository.docker-local.key

    filter {
      type  = "regex"
      value = ".*"
    }
  }

  assigned_policy {
    name = xray_security_policy.security.name
    type = "security"
  }

  assigned_policy {
    name = xray_license_policy.license.name
    type = "license"
  }

  watch_recipients = ["test@email.com", "test1@email.com"]
}

resource "xray_watch" "maven-repository" {
  name        = "maven-repository-watch-${random_id.randid.dec}"
  description = "Watch a single repo or a list of repositories"
  active      = true

  watch_resource {
    type       = "repository"
    bin_mgr_id = "default"
    name       = artifactory_local_maven_repository.maven-local.key

    filter {
      type  = "regex"
      value = ".*"
    }
  }

  assigned_policy {
    name = xray_security_policy.security.name
    type = "security"
  }

  assigned_policy {
    name = xray_license_policy.license.name
    type = "license"
  }

  watch_recipients = ["test@email.com", "test1@email.com"]
}



# Project provider

resource "project" "myproject" {
  key          = "myproj"
  display_name = "My Project"
  description  = "My Project"
  admin_privileges {
    manage_members   = true
    manage_resources = true
    index_resources  = true
  }
  max_storage_in_gibibytes   = 10
  block_deployments_on_limit = false
  email_notification         = true

  member {
    name  = "developer" // Must exist already in Artifactory
    roles = ["Developer", "Project Admin"]
  }

  member {
    name  = "qa-tester" // Must exist already in Artifactory
    roles = ["Developer"]
  }

  group {
    name  = "terraform"
    roles = ["Contributor"]
  }

  repos = [
    artifactory_local_docker_v2_repository.docker-local.key,
    artifactory_remote_docker_repository.docker-remote.key,
    artifactory_virtual_docker_repository.docker-virtual.key
  ]

  depends_on = [
    artifactory_local_docker_v2_repository.docker-local,
    artifactory_remote_docker_repository.docker-remote,
    artifactory_virtual_docker_repository.docker-virtual
  ]
}
