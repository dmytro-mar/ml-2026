KERNEL := ml-2026
VENV   := .venv

ifeq ($(OS),Windows_NT)
    PYTHON  ?= python
    VENV_PY := $(CURDIR)/$(VENV)/Scripts/python.exe
else
    PYTHON  ?= python3
    VENV_PY := $(VENV)/bin/python
endif

.PHONY: all venv kernel hooks clean

all: kernel hooks

venv: $(VENV)/.installed

$(VENV_PY):
	$(PYTHON) -m venv $(VENV)

$(VENV)/.installed: $(VENV_PY) requirements.txt
	$(VENV_PY) -m pip install --upgrade pip
	$(VENV_PY) -m pip install -r requirements.txt
	@echo ok > $@

kernel: venv
	$(VENV_PY) -m ipykernel install --user --name $(KERNEL) --display-name "Python ($(KERNEL))"

hooks:
	git config core.hooksPath .githooks

clean:
	-$(VENV_PY) -m jupyter kernelspec uninstall -y $(KERNEL)
	$(PYTHON) -c "import shutil; shutil.rmtree('$(VENV)', ignore_errors=True)"
