env:
	echo "Run 'planutils activate' now:"
	docker run --mount type=bind,source="/home/grigorii_m/Projects/Planning/SokobanOnSteroids",target="/root/data" -it --privileged planutils bash
