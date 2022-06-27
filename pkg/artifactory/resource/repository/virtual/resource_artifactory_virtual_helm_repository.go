package virtual

import (
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/jfrog/terraform-provider-artifactory/v6/pkg/artifactory/resource/repository"
	"github.com/jfrog/terraform-provider-shared/packer"
	"github.com/jfrog/terraform-provider-shared/util"
)

func ResourceArtifactoryVirtualHelmRepository() *schema.Resource {

	const packageType = "helm"

	helmVirtualSchema := util.MergeSchema(BaseVirtualRepoSchema, map[string]*schema.Schema{
		"use_namespaces": {
			Type:        schema.TypeBool,
			Optional:    true,
			Default:     false,
			Description: "From Artifactory 7.24.1 (SaaS Version), you can explicitly state a specific aggregated local or remote repository to fetch from a virtual by assigning namespaces to local and remote repositories\nSee https://www.jfrog.com/confluence/display/JFROG/Kubernetes+Helm+Chart+Repositories#KubernetesHelmChartRepositories-NamespaceSupportforHelmVirtualRepositories. Default to 'false'",
		},
	}, repository.RepoLayoutRefSchema("virtual", packageType))

	type HelmVirtualRepositoryParams struct {
		VirtualRepositoryBaseParamsWithRetrievalCachePeriodSecs
		UseNamespaces bool `json:"useNamespaces"`
	}

	unpackHelmVirtualRepository := func(data *schema.ResourceData) (interface{}, string, error) {
		d := &util.ResourceData{data}
		repo := HelmVirtualRepositoryParams{
			VirtualRepositoryBaseParamsWithRetrievalCachePeriodSecs: UnpackBaseVirtRepoWithRetrievalCachePeriodSecs(data, "helm"),
			UseNamespaces: d.GetBool("use_namespaces", false),
		}

		return repo, repo.Id(), nil
	}

	constructor := func() interface{} {
		return &HelmVirtualRepositoryParams{
			VirtualRepositoryBaseParamsWithRetrievalCachePeriodSecs: VirtualRepositoryBaseParamsWithRetrievalCachePeriodSecs{
				VirtualRepositoryBaseParams: VirtualRepositoryBaseParams{
					Rclass:      "virtual",
					PackageType: packageType,
				},
			},
			UseNamespaces: false,
		}
	}

	return repository.MkResourceSchema(helmVirtualSchema, packer.Default(helmVirtualSchema), unpackHelmVirtualRepository, constructor)
}
