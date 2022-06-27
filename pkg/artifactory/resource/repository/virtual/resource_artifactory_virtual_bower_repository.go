package virtual

import (
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/jfrog/terraform-provider-artifactory/v6/pkg/artifactory/resource/repository"
	"github.com/jfrog/terraform-provider-shared/packer"
	"github.com/jfrog/terraform-provider-shared/util"
)

func ResourceArtifactoryVirtualBowerRepository() *schema.Resource {

	const packageType = "bower"

	var bowerVirtualSchema = util.MergeSchema(
		BaseVirtualRepoSchema,
		externalDependenciesSchema,
		repository.RepoLayoutRefSchema("virtual", packageType),
	)

	var unpackBowerVirtualRepository = func(s *schema.ResourceData) (interface{}, string, error) {
		repo := unpackExternalDependenciesVirtualRepository(s, packageType)
		return repo, repo.Id(), nil
	}

	return repository.MkResourceSchema(
		bowerVirtualSchema,
		packer.Default(bowerVirtualSchema),
		unpackBowerVirtualRepository,
		func() interface{} {
			return &ExternalDependenciesVirtualRepositoryParams{
				VirtualRepositoryBaseParams: VirtualRepositoryBaseParams{
					Rclass:      "virtual",
					PackageType: packageType,
				},
			}
		},
	)
}
