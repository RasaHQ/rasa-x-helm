package test

import (
	"strings"

	"github.com/gruntwork-io/terratest/modules/random"
)

var (
	chart         string = "../charts/rasa-x"
	releaseName   string = "rasa-x"
	namespaceName string = "test-" + strings.ToLower(random.UniqueId())
)
