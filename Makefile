install:
	git pull
	helm install $(appName) . -f env-dev/$(appName).yaml