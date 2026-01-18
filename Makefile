install:
	git pull
	helm upgrade -i $(appName) . -f env-dev/$(appName).yaml -namespace apps --create-namespace

uninstall:
	git pull
	helm uninstall $(appName)