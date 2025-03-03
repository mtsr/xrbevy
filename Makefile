install_cargo_apk:
	echo "Installing patched version of cargo-apk"
	cargo install --path repos/android-ndk-rs/cargo-apk

download_dependencies:
	mkdir -p repos
	for i in android-ndk-rs bevy bevy_rapier gfx openxrs wgpu wgpu-rs; \
	do \
		echo "==== $$i =========="; \
		if [ ! -d "$$i" ]; then \
			git -C repos clone https://github.com/blaind/$$i.git; \
			git -C repos/$$i fetch origin; \
			git -C repos/$$i checkout bevy_openxr; \
		fi; \
	done;
	
	git -C repos clone https://github.com/blaind/bevy_openxr.git

update_dependencies:
	for i in android-ndk-rs bevy bevy_rapier gfx openxrs wgpu wgpu-rs; \
	do \
		git -C repos/$$i pull; \
	done;
	
	git -C repos/bevy_openxr pull
	git pull

diff:
	for i in android-ndk-rs bevy bevy_rapier gfx openxrs wgpu wgpu-rs bevy_openxr; \
	do \
		git -C repos/$$i diff; \
	done;

adb_logcat:
	$$ANDROID_SDK_ROOT/platform-tools/adb -d logcat |grep Rust

adb_shell:
	$$ANDROID_SDK_ROOT/platform-tools/adb -d shell

run_xr_apk:
	cargo apk run --example xr_apk_scene --release

run_xr_pc:
	cargo run --example xr_pc_scene

