##
REPO:=zmkfirmware/zmk-dev-arm
TAG:=3.2
# REPO:=zmkfirmware/zmk-build-arm
# TAG:=stable

CONTAINER_NAME:=zmk-$(TAG)
IMAGE_NAME:=$(REPO):$(TAG)

PWD := $(shell pwd)
ZMK_WORK_DIR = ${PWD}
ZMK_CONFIG_DIR = ${ZMK_WORK_DIR}/config
ZMK_BUILD_DIR = ${PWD}/build

run:
	docker run -d --rm \
	--volume ${PWD}:${PWD}:rw \
	--workdir ${ZMK_WORK_DIR} \
	--name=${CONTAINER_NAME} \
	${IMAGE_NAME} tail -F /dev/null

exec:
	docker exec $(ARGS) $(CONTAINER_NAME) $(CMD)

attach:
	make exec ARGS="-it" CMD="/bin/bash"

start:
	docker start $(CONTAINER_NAME)

stop:
	docker stop $(CONTAINER_NAME)

ps:
	docker ps -a -f name=$(CONTAINER_NAME)

rm:
	docker rm $(CONTAINER_NAME)

logs:
	docker logs $(CONTAINER_NAME)

images:
	docker images $(REPO)

top:
	docker top $(CONTAINER_NAME) aux

###
west_init:
	make exec CMD="west init -l ${ZMK_CONFIG_DIR}"

west_update:
	make exec CMD="west update"

west_export:
	make exec CMD="west zephyr-export"

west_reset:
	make exec CMD="rm .west -rf"
	make exec CMD="rm zmk -rf"
	make exec CMD="rm zephyr -rf"
	make exec CMD="rm modules -rf"

###
zmk_setup:
	make west_init
	make west_update

zmk_build:
	make exec CMD="west zephyr-export"
	make exec CMD="west build -p -s zmk/app -b ${BOARD} -d ${ZMK_BUILD_DIR}/${SHIELD} -- -DSHIELD=${SHIELD} -DZMK_CONFIG=${ZMK_CONFIG_DIR}"
	make exec CMD="chmod 777 -R ${ZMK_BUILD_DIR}"
	make exec CMD="cp ${ZMK_BUILD_DIR}/${SHIELD}/zephyr/zmk.uf2 ${ZMK_BUILD_DIR}/${SHIELD}.uf2"

d3kb:
	make zmk_build BOARD="seeeduino_xiao_ble" SHIELD="d3kb_left"
	make zmk_build BOARD="seeeduino_xiao_ble" SHIELD="d3kb_right"

zzkb:
	make zmk_build BOARD="seeeduino_xiao_ble" SHIELD="zzkb"

all:
	make d3kb
	make zzkb