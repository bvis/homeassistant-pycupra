.PHONY: check test lint format typecheck build shell clean

DOCKER_IMAGE = pycupra-dev
DOCKER_RUN = docker run --rm -v $(PWD):/workspace -w /workspace $(DOCKER_IMAGE)

build:
	docker build -f Dockerfile.dev -t $(DOCKER_IMAGE) .

check: build
	$(DOCKER_RUN) sh -c "ruff check custom_components/pycupra/ tests/ && ruff format --check custom_components/pycupra/ tests/ && mypy custom_components/pycupra/ && pytest tests/ -v"

test: build
	$(DOCKER_RUN) pytest tests/ -v

lint: build
	$(DOCKER_RUN) ruff check custom_components/pycupra/ tests/

format: build
	$(DOCKER_RUN) sh -c "ruff check --fix custom_components/pycupra/ tests/ && ruff format custom_components/pycupra/ tests/"

typecheck: build
	$(DOCKER_RUN) mypy custom_components/pycupra/

shell: build
	docker run --rm -it -v $(PWD):/workspace -w /workspace $(DOCKER_IMAGE) bash

clean:
	docker rmi $(DOCKER_IMAGE) 2>/dev/null || true
