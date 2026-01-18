install:
	git pull
	helm upgrade -i $(appName) . -f env-dev/$(appName).yaml -n apps --create-namespace

uninstall:
	git pull
	helm uninstall $(appName) -n app