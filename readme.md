This repository contains a simple script to build zmkfirmware locally.

# Requirements
1. Docker is installed
2. make command is installed
3. (Probably inevitably Windows users have WSL enabled to meet the above requirements) 


# Installation

```
git clone https://github.com/TakeshiAkehi/zmk-make.git
cd zmk-make
make run
make zmk_setup
make d3kb
make stop
```

`make run` : This command runs the zmk container in the background.

`make zmk_setup` This command performs initial setup. It needs to be executed only the first time. Folders such as `.west`, `zmk` etc... are placed in the zmk-config folder.

`make d3kb` This command actually builds the firmware in the build folder. The keyboard being built is my private keyboard, so your goal is to create a command to replace it.

`make stop` stops the zmk container


# How to set up your keyboard.
Create  `zmk-config/config/board/shields/<your keyboard name>` folder and place the `.keymap` file etc.

Add a new build command to the end of the Makefile.
```
# Makefile
d3kb:
	make zmk_build BOARD="seeeduino_xiao_ble" SHIELD="d3kb_left"
	make zmk_build BOARD="seeeduino_xiao_ble" SHIELD="d3kb_right"

<your command name>:
	make zmk_build BOARD="<your board name>" SHIELD="your shield name"
	make zmk_build BOARD="<your board name>" SHIELD="your shield name"
```

# other commands (wip)

`make ps` : This connmmnd shows the running container. If the container is running you will see Up displayed in the Status column

```
❯ make ps  
docker ps -a -f name=zmk-3.2
CONTAINER ID   IMAGE                         COMMAND               CREATED          STATUS          PORTS     NAMES
66cfcc6b1496   zmkfirmware/zmk-dev-arm:3.2   "tail -F /dev/null"   34 minutes ago   Up 34 minutes             zmk-3.2
```

`make attach` : This command attaches to the running container's bash.

`make zmk_update` : T

Change ZMK_CONFIG_DIR in Makefile to use your own `zmk-config` repository.

