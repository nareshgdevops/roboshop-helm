install:
	git pull
	helm install appName=$(appName) .