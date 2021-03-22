# BioDepot BWB Toil Plugin

Main Tool: https://github.com/BioDepot/BioDepot-workflow-builder

# Deployment:

We do not install Toil in Bwb containers to minimize the size of the container's image of Bwb. To use Toil without installation, we wrote a Docker file to build an image that consists of Toil, including the docker command-line tool (Docker CLI). Why do we need to have the Docker CLI? To leverage bioinformatics software without installation, we intend to use the Toil to call Docker containers using Docker images of those tools. We also need to map the volume of the "docker.sock" directory from the host machine. It is the UNIX socket that the Docker daemon is listening to and the main entry point for Docker API.

# How to install Toil plugin

Clone the BioDepot-workflow-builder (BWB) first and then this repository.

```bash
git clone https://github.com/BioDepot/BioDepot-workflow-builder
git clone https://github.com/varikmp/biodepot_toil_widgets
```

Run the plugin.sh script to install the Toil plugin for BWB.
Specify the BioDepot BWB location that you cloned and the operation to install the plugin

```bash
./plugin.sh BWB_DIRECTORY OPERATION
./plugin.sh /home/biodepot/BioDepot-workflow-builder/ install
```

Build or rebuild the container image with the Toil plugin included

```bash
./plugin.sh BWB_DIRECTORY OPERATION
./plugin.sh /home/biodepot/BioDepot-workflow-builder/ build
```

Launch the container

```bash
./plugin.sh BWB_DIRECTORY OPERATION
./plugin.sh /home/biodepot/BioDepot-workflow-builder/ launch
```

