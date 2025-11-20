# SD2-Master-Executable
The repository that houses makefiles for SD2 projects. Will currently execute livemap and livestream repos at same time.

# Run this in Pi5 and it'll work
## Step 1:
### On Pi5
mkdir -p ~/dev
cd ~/dev

#### Clone all three
git clone <url-to-hub-repo> sd2-hub
git clone <url-to-livestream> Pi5-SD2-Livestream
git clone <url-to-livemap>    Pi5-SD2-Livemap

## Step 2
cd ~/dev/sd2-hub

#### One-shot setup (apt + venvs + pip deps for both services)
make setup

#### Run both servers in parallel
make run-all
