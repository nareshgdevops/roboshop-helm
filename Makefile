install:
	git pull
	helm install -f Chart.yaml appName=$(appName) .