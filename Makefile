SUBMODULE := containerization
KERNEL_DIR := $(SUBMODULE)/kernel

.PHONY: submodule build clean

submodule:
	git submodule update --init --recursive

build: submodule
	./scripts/build-kernel.sh

clean:
	$(MAKE) -C $(KERNEL_DIR) clean
