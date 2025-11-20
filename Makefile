#############################
# Config
#############################

PYTHON  := python3

# System packages needed on the Pi
PI_PACKAGES := python3 python3-pip python3-venv v4l-utils ffmpeg git cmake

# --- Repo 1: Livestream (Pi5-SD2-Livestream) ---
LIVESTREAM_DIR      := Pi5-SD2-Livestream
LIVESTREAM_REQ_FILE := requirements.txt
LIVESTREAM_ENTRY    := camera_stream.py

# --- Repo 2: Livemap (Pi5-SD2-Livemap) ---
LIVEMAP_DIR         := Pi5-SD2-Livemap
LIVEMAP_REQ_FILE    := requirements.txt
LIVEMAP_ENTRY       := livemap_server.py


#############################
# Top-level targets
#############################

# One-shot full setup: apt + both venvs + pip deps
all: setup

setup: system-deps livestream-deps livemap-deps
	@echo "=== Setup complete. You can now run: make run-all ==="

# Run both servers in parallel and wait
run-all: run-both-parallel


#############################
# System-level dependencies
#############################

system-deps:
	sudo apt-get update
	sudo apt-get install -y $(PI_PACKAGES)


#############################
# Repo 1: Livestream service
#############################

$(LIVESTREAM_DIR)/venv:
	cd $(LIVESTREAM_DIR) && $(PYTHON) -m venv venv

livestream-deps: $(LIVESTREAM_DIR)/venv
	cd $(LIVESTREAM_DIR) && ./venv/bin/pip install --upgrade pip
	cd $(LIVESTREAM_DIR) && ./venv/bin/pip install -r $(LIVESTREAM_REQ_FILE)

run-livestream: $(LIVESTREAM_DIR)/venv
	cd $(LIVESTREAM_DIR) && ./venv/bin/python $(LIVESTREAM_ENTRY)


#############################
# Repo 2: Livemap service
#############################

$(LIVEMAP_DIR)/venv:
	cd $(LIVEMAP_DIR) && $(PYTHON) -m venv venv

livemap-deps: $(LIVEMAP_DIR)/venv
	cd $(LIVEMAP_DIR) && ./venv/bin/pip install --upgrade pip
	cd $(LIVEMAP_DIR) && ./venv/bin/pip install -r $(LIVEMAP_REQ_FILE)

run-livemap: $(LIVEMAP_DIR)/venv
	cd $(LIVEMAP_DIR) && ./venv/bin/python $(LIVEMAP_ENTRY)


#############################
# Parallel runner + cleanup
#############################

run-both-parallel: $(LIVESTREAM_DIR)/venv $(LIVEMAP_DIR)/venv
	cd $(LIVESTREAM_DIR) && ./venv/bin/python $(LIVESTREAM_ENTRY) &
	cd $(LIVEMAP_DIR)    && ./venv/bin/python $(LIVEMAP_ENTRY) &
	wait

clean:
	rm -rf $(LIVESTREAM_DIR)/venv
	rm -rf $(LIVEMAP_DIR)/venv

.PHONY: all setup system-deps \
        livestream-deps livemap-deps \
        run-livestream run-livemap run-all run-both-parallel \
        clean
