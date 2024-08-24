# Makefile for Gatekeeper demo

# Variables
KUBECTL = kubectl
EXAMPLES_DIR = ./examples
POLICIES_DIR = ./policies

# Phony targets
.PHONY: all apply-namespace-rule create-bad-ns create-good-ns apply-combined-rule create-good-deployment create-bad-deployment nuke help

# Default target
all: apply-namespace-rule create-bad-ns create-good-ns apply-combined-rule create-good-deployment create-bad-deployment

# Apply namespace rule
apply-namespace-rule:
	@echo "Applying namespace rule..."
	$(KUBECTL) apply -f $(POLICIES_DIR)/ns_require_labels_template.yaml
	$(KUBECTL) apply -f $(POLICIES_DIR)/ns_Require_createdby_label_constraints.yaml

# Create bad namespace
create-bad-ns:
	@echo "Creating bad namespace (should fail)..."
	-$(KUBECTL) apply -f $(EXAMPLES_DIR)/just_another_ns.yaml

# Create good namespace
create-good-ns:
	@echo "Creating good namespace (should succeed)..."
	$(KUBECTL) apply -f $(EXAMPLES_DIR)/law_abiding_ns.yaml

# Apply combined rule
apply-combined-rule:
	@echo "Applying combined rule..."
	$(KUBECTL) apply -f $(POLICIES_DIR)/combined_policies_template.yaml
	$(KUBECTL) apply -f $(POLICIES_DIR)/combined_policies_constraints.yaml

# Create good deployment
create-good-deployment:
	@echo "Creating good deployment (should succeed)..."
	$(KUBECTL) apply -f $(EXAMPLES_DIR)/good-deployment-service.yaml

# Create bad deployment
create-bad-deployment:
	@echo "Creating bad deployment (should fail)..."
	-$(KUBECTL) apply -f $(EXAMPLES_DIR)/bad-deployment.yaml

# Nuke (delete all resources)
nuke:
	@echo "Nuking all resources..."
	-$(KUBECTL) delete -f $(EXAMPLES_DIR)
	-$(KUBECTL) delete -f $(POLICIES_DIR)

# Show help
help:
	@echo "Available targets:"
	@echo "  all                    - Run all steps in order"
	@echo "  apply-namespace-rule   - Apply namespace rule"
	@echo "  create-bad-ns          - Create bad namespace (should fail)"
	@echo "  create-good-ns         - Create good namespace"
	@echo "  apply-combined-rule    - Apply combined rule"
	@echo "  create-good-deployment - Create good deployment"
	@echo "  create-bad-deployment  - Create bad deployment (should fail)"
	@echo "  nuke                   - Delete all created resources"
	@echo "  help                   - Show this help message"