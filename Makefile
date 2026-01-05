install:
	git pull
	helm upgrade -i $(appName) . -f env-dev/$(appName).yaml