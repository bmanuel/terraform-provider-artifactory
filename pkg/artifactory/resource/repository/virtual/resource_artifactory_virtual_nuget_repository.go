package virtual

import (
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/jfrog/terraform-provider-artifactory/v6/pkg/artifactory/resource/repository"
	"github.com/jfrog/terraform-provider-shared/packer"
	"github.com/jfrog/terraform-provider-shared/util"
)

func ResourceArtifactoryVirtualNugetRepository() *schema.Resource {

	const packageType = "nuget"

	var nugetVirtualSchema = util.MergeSchema(BaseVirtualRepoSchema, map[string]*schema.Schema{
		"force_nuget_authentication": {
			Type:        schema.TypeBool,
			Optional:    true,
			Default:     false,
			Description: "If set, user authentication is required when accessing the repository. An anonymous request will display an HTTP 401 error. This is also enforced when aggregated repositories support anonymous requests.",
		},
	}, repository.RepoLayoutRefSchema("virtual", packageType))

	type NugetVirtualRepositoryParams struct {
		VirtualRepositoryBaseParams
		ForceNugetAuthentication bool `json:"forceNugetAuthentication"`
	}

	var unpackNugetVirtualRepository = func(s *schema.ResourceData) (interface{}, string, error) {
		d := &util.ResourceData{s}

		repo := NugetVirtualRepositoryParams{
			VirtualRepositoryBaseParams: UnpackBaseVirtRepo(s, packageType),
			ForceNugetAuthentication:    d.GetBool("force_nuget_authentication", false),
		}
		repo.PackageType = packageType
		return &repo, repo.Key, nil
	}

	return repository.MkResourceSchema(nugetVirtualSchema, packer.Default(nugetVirtualSchema), unpackNugetVirtualRepository, func() interface{} {
		return &NugetVirtualRepositoryParams{
			VirtualRepositoryBaseParams: VirtualRepositoryBaseParams{
				Rclass:      "virtual",
				PackageType: packageType,
			},
		}
	})
}
