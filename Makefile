.PHONY : python-ds-sandbox container


python-ds-sandbox : Dockerfile
	docker build -t $@ .

container :
	docker run -ti --rm \
		--mount type=bind,source="$$(PWD)",target=/home/sisko/pdsh \
		python-ds-sandbox:latest
