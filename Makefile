.PHONY : python-ds-sandbox sandbox jupyter-image jupyter

all :
	@echo "No default, specify a target"

python-ds-sandbox : Dockerfile
	docker build -t $@ . -f $<

jupyter-image : Dockerfile.jupyter
	docker build -t $@ . -f $<

sandbox :
	docker run -ti --rm \
		-p 8888:8888 --env="DISPLAY" \
		--mount type=bind,source="$$(PWD)",target=/home/sisko/pdsh \
		python-ds-sandbox:latest

jupyter :
	docker run --name toward-data-science -p 8888:8888 --env="DISPLAY" \
		-v "$$PWD/notebooks:/home/ubuntu/notebooks" -d toward-data-science
