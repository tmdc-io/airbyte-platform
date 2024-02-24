CH_DIR = charts
DIR = airbyte
VERSION = ${TAG}
PACKAGED_CHART = ${DIR}-${VERSION}.tgz
ECR_DEFAULT_REGIONS = us-east-1

# Push OCI package

push-oci-chart:
	@echo
	echo "=== login to OCI registry ==="
	aws ecr-public get-login-password --region us-east-1 | helm3.14.0 registry login  --username AWS --password-stdin public.ecr.aws
	@echo
	@echo "=== package OCI chart ==="
	helm3.14.0 package ${CH_DIR}/${DIR}/ --version ${VERSION}
	@echo
	@echo "=== create repository ==="
	aws ecr-public describe-images --repository-name ${DIR} --region us-east-1 || aws ecr-public create-repository --repository-name ${DIR} --region us-east-1
	@echo
	@echo "=== push OCI chart ==="
	helm3.14.0 push ${PACKAGED_CHART} oci://public.ecr.aws/z2k6n2n9
	@echo
	@echo "=== logout of registry ==="
	helm3.14.0 registry logout public.ecr.aws