package test

import (
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
	appsv1 "k8s.io/api/apps/v1"
	apiv1 "k8s.io/api/core/v1"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/logger"
)

func TestParameters_RasaX(t *testing.T) {
	t.Parallel()

	// Path to the helm chart we will test
	helmChartPath, err := filepath.Abs(chart)
	require.NoError(t, err)

	// Set up the namespace; confirm that the template renders the expected value for the namespace.
	logger.Logf(t, "Namespace: %s\n", namespaceName)

	optionsWithValues := &helm.Options{
		SetValues: map[string]string{
			"rasax.podLabels.test_label": "test_value",
		},
		KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
	}

	optionsWithoutValues := &helm.Options{
		KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
	}

	outputWithOptions := helm.RenderTemplate(t, optionsWithValues, helmChartPath, releaseName, []string{"templates/rasa-x-deployment.yaml"})
	outputWithoutOptions := helm.RenderTemplate(t, optionsWithoutValues, helmChartPath, releaseName, []string{"templates/rasa-x-deployment.yaml"})

	var deploymentWithOptions appsv1.Deployment
	var deploymentWithoutOptions appsv1.Deployment
	helm.UnmarshalK8SYaml(t, outputWithOptions, &deploymentWithOptions)
	helm.UnmarshalK8SYaml(t, outputWithoutOptions, &deploymentWithoutOptions)

	// Verify the deployment pod template spec is set to the expected values

	renderedDeploymentWithOptions := deploymentWithOptions
	renderedDeploymentWithoutOptions := deploymentWithoutOptions

	require.Equal(t, len(renderedDeploymentWithOptions.Spec.Template.Spec.Containers), 1)
	require.Equal(t, len(renderedDeploymentWithoutOptions.Spec.Template.Spec.Containers), 1)

	require.Contains(t, renderedDeploymentWithOptions.Spec.Template.Labels, "test_label")
}


func TestParameters_RasaX_Service(t *testing.T) {
	t.Parallel()

	// Path to the helm chart we will test
	helmChartPath, err := filepath.Abs(chart)
	require.NoError(t, err)

	// Set up the namespace; confirm that the template renders the expected value for the namespace.
	logger.Logf(t, "Namespace: %s\n", namespaceName)

	optionsWithValues := &helm.Options{
		SetValues: map[string]string{
			"rasax.service.type": "LoadBalancer",
			"rasax.service.port": "123",
		},
		KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
	}

	optionsWithoutValues := &helm.Options{
		KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
	}

	outputWithOptions := helm.RenderTemplate(t, optionsWithValues, helmChartPath, releaseName, []string{"templates/rasa-x-service.yaml"})
	outputWithoutOptions := helm.RenderTemplate(t, optionsWithoutValues, helmChartPath, releaseName, []string{"templates/rasa-x-service.yaml"})

	var serviceWithOptions apiv1.Service
	var serviceWithoutOptions apiv1.Service
	helm.UnmarshalK8SYaml(t, outputWithOptions, &serviceWithOptions)
	helm.UnmarshalK8SYaml(t, outputWithoutOptions, &serviceWithoutOptions)

	// Verify the service template spec is set to the expected values

	renderedServiceWithOptions := serviceWithOptions
	renderedServiceWithoutOptions := serviceWithoutOptions

	require.Contains(t, renderedServiceWithOptions.Spec.Type, "LoadBalancer")
	require.Contains(t, renderedServiceWithoutOptions.Spec.Type, "ClusterIP")

	require.Equal(t, renderedServiceWithOptions.Spec.Ports[0].Port, int32(123))
	require.Equal(t, renderedServiceWithoutOptions.Spec.Ports[0].Port, int32(0))
}
