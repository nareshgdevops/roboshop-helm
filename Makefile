install:
	git pull
	helm upgrade -i $(appName) . -f env-dev/$(appName).yaml -n app --create-namespace

uninstall:
	git pull
	helm uninstall $(appName) -n app