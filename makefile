.PHONY: clean

###########################################################

ifeq (,$(PLATFORM))
PLATFORM=$(UNION_PLATFORM)
endif

ifeq (,$(PLATFORM))
$(error please specify PLATFORM, eg. PLATFORM=trimui make)
endif

###########################################################

BUILD_TIME!=date "+%Y-%m-%d %H:%M:%S"

LIBC_LIB=/opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib
PAYLOAD_LIB=

all: lib sdl core emu settings payload zip

lib:
	cd ./src/libmsettings && make
	cd ./src/libmmenu && make

sdl:
	cd ./third-party/SDL-1.2 && ./make.sh

core:
	cd ./src/batmon && make
	cd ./src/keymon && make
	cd ./src/lumon && make
	cd ./src/progressui && make
	cd ./src/miniui && make

emu:
	cd ./third-party/picoarch && make platform=miyoomini -j

settings:
	cd ./third-party/DinguxCommander && make -j

payload:
	mkdir -p ./build
	cp -R ./skeleton/. ./build/PAYLOAD
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libc.so.6 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libcrypt.so.1 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libdl.so.2 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libgcc_s.so.1 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libm.so.6 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libpcprofile.so ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libpthread.so.0 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libresolv.so.2 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/librt.so.1 ./build/PAYLOAD/.system/lib/
	cp -L /opt/miyoomini-toolchain/arm-none-linux-gnueabihf/libc/lib/libstdc++.so.6 ./build/PAYLOAD/.system/lib/
	cd ./build && find . -type f -name '.keep' -delete
	cd ./build && find . -type f -name '.DS_Store' -delete
	cp ./src/libmsettings/libmsettings.so ./build/PAYLOAD/.system/lib/
	cp ./src/libmmenu/libmmenu.so ./build/PAYLOAD/.system/lib/
	cp ./third-party/SDL-1.2/build/.libs/libSDL-1.2.so.0.11.5 ./build/PAYLOAD/.system/lib/libSDL-1.2.so.0
	cp ./src/batmon/batmon ./build/PAYLOAD/.system/bin/
	cp ./src/keymon/keymon ./build/PAYLOAD/.system/bin/
	cp ./src/lumon/lumon ./build/PAYLOAD/.system/bin/
	cp ./src/progressui/progressui ./build/PAYLOAD/.system/bin/progressui
	cp ./src/progressui/progress.sh ./build/PAYLOAD/.system/bin/progress
	cp ./src/miniui/MiniUI ./build/PAYLOAD/.system/paks/MiniUI.pak/
	cp ./third-party/picoarch/picoarch ./build/PAYLOAD/.system/bin/
	cp ./third-party/picoarch/*.so ./build/PAYLOAD/.system/cores/
	cp ./third-party/DinguxCommander/output/DinguxCommander ./build/PAYLOAD/.system/paks/Settings/Files.pak/
	cp -r ./third-party/DinguxCommander/res ./build/PAYLOAD/.system/paks/Settings/Files.pak/

zip:
	cd ./build/PAYLOAD/.system && echo $(BUILD_TIME) > version.txt
	cd ./build/PAYLOAD && zip -r MiniUI.zip .system

clean:
	rm -rf ./build
	cd ./src/libmsettings && make clean
	cd ./src/libmmenu && make clean
	cd ./third-party/SDL-1.2 && make distclean
	cd ./src/batmon && make clean
	cd ./src/keymon && make clean
	cd ./src/lumon && make clean
	cd ./src/progressui && make clean
	cd ./src/miniui && make clean
	cd ./third-party/picoarch && make platform=miyoomini clean
	cd ./third-party/DinguxCommander && make clean