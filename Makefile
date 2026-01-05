install:
	git pull
	helm upgrade -i $(appName) . -f env-dev/$(appName).yaml

uninstall:
	git pull
	helm uninstall $(appName)