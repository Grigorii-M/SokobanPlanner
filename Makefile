env:
	echo "Run 'planutils activate' after this command:"
	docker run --mount type=bind,source="/home/grigorii_m/Projects/SokobanOnSteroids",target="/root/data" -it --privileged planutils bash
