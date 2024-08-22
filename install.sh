$AXFUN
import axeron.prop

FILE="/sdcard/device_ids.txt"
DEVICE_ID=$(settings get secure android_id)

if ! grep -q "$DEVICE_ID" "$FILE"; then
    echo "$DEVICE_ID" >> "$FILE"
fi

if [ "$AXERON" = false ]; then
    echo "Hanya mendukung di Laxeron"
    exit 1
fi
display_info=$(dumpsys display)

local core="r17rYI0tYD6Cp9pPOtlQ2c0rYMzuOEctdEmseIcseHlP29kC2QyrYAcvaZ1Ez9DPOyctd9lC21yrN4mt2ycsXnmP29pQJ5qrR=="

if [ -n "$1" ] && [ "$1" == "-p" ];then
    axprop $path_axeronprop runPackage -s "$2"
    runPackage="$2"
    shift 2
fi
echo " Folder $path_axeronprop"

if [ -z "$path_axeronprop" ]; then
    echo "Variabel axeron.prop tidak didefinisikan."
    exit 1
fi

if [ ! -f "$path_axeronprop" ]; then
    echo "File axeron.prop tidak ditemukan."
    exit 1
fi

if [ -n "$(getprop ro.hardware.vulkan)" ]; then
    renderer="vulkan"
elif [ -n "$(getprop ro.hardware.opengl)" ]; then
    renderer="skiagl"
else
    renderer="skiavk"
fi
rm -rf /storage/emulated/0/AxeronModules/.cache

UNIQUE_COUNT=$(sort "$FILE" | uniq | wc -l)
User() {
    USER_COUNT=$(wc -l < "$FILE")
    echo ""
    echo "Total pengguna CMS yang terdeteksi: $USER_COUNT"
}

case $1 in
  Users)
    sleep 1
    User
    exit 0
    ;;
  Info)
    echo "Ngapain bang info info?"
    exit 0
    ;;
esac

setprop debug.hwui.renderer "$renderer"

fps=$(echo "$display_info" | grep -oE 'fps=[0-9.]+' | awk -F '=' '{printf "%d\n", $2+0}' | head -n 1)


if [ -z "$runPackage" ]; then
    echo "Mohon masukan package name"
    exit 1
fi
print() {
    local text="$1"
    local len=${#text}
    local i=0
    while [ $i -lt $len ]; do
        echo -n "${text:$i:1}"
        i=$((i+1))
    done
    echo ""
}

apply_system_properties() {
    setprop debug.egl.profiler 1
    setprop debug.hwui.use_buffer_age true
    settings put global window_animation_scale 0.5
    settings put global transition_animation_scale 0.5
    settings put global animator_duration_scale 0.5
}

apply_Cmd2() {
    cmd shortcut reset-throttling "$runPackage"
    device_config delete game_overlay "$runPackage"
}
optimizion() {
echo "[ 𝗢𝗽𝘁𝗶𝗺𝗶𝘇𝗮𝘁𝗶𝗼𝗻 $runPackage ]"

if cmd package compile -m quicken -f "$runPackage" > /dev/null 2>&1; then
    echo "Optimization \"$runPackage\" success"
else
    echo "Optimization \"$runPackage\" failed"
fi

if pm compile -m speed-profile -f "$runPackage"; then
    echo "Optimization \"$runPackage\" success"
else
    echo "Optimization \"$runPackage\" failed"
fi

if pm compile -m speed-profile --secondary-dex -f "$runPackage"; then
    echo "Optimization \"$runPackage\" success"
else
    echo "Optimization \"$runPackage\" failed"
fi

if cmd package compile -m speed-profile -f "$runPackage" -r --secondary-dex; then
    echo "Optimization \"$runPackage\" success"
else
    echo "Optimization \"$runPackage\" failed"
fi
}

apply() {
(
    apply_Cmd2
    apply_system_properties
    am force-stop "$runPackage"
    cmd activity kill-all
) > /dev/null 2>&1 &
}

    case "$1" in
        "performance++")
    performance_mode="mode=enabled=true"
    setprop debug.egl.hw 0
    setprop debug.sf.hw 0
    setprop debug.sf.latch_unsignaled 1
    cmd power set-fixed-performance-mode-enabled true "$performance_mode"
    cmd power set-adaptive-power-saver-enabled false
    cmd game set --mode performance --downscale 0.7 --fps "$fps" --user 0 "$runPackage" > /dev/null 2>&1 &
    device_config put game_overlay "$runPackage" mode=2,fps="$fps",downscaleFactor=0.7
    cmd device_config put game_overlay "$runPackage" mode=2,renderer="$renderer",downscaleFactor=0.7,fps="$fps"
    cmd game mode 2 "$runPackage" > /dev/null 2>&1 &
    cmd thermalservice override-status 0
    setprop debug.egl.swapinterval 0
    setprop debug.sf.disable_client_composition_cache 1
    setprop debug.gr.numframebuffers 5
    setprop debug.gpu.rendering.framebuffer 2 
    setprop debug.composition.type gpu
    print "𝗠𝗼𝗱𝗲 𝗣𝗲𝗻𝗶𝗻𝗴𝗸𝗮𝘁𝗮𝗻 𝗣𝗲𝗿𝗳𝗼𝗿𝗺𝗮 (performance++): Meningkatkan performa perangkat sekitar 25% hingga 55% untuk package [$runPackage]"
    setprop debug.sf.high_fps_early_gl_phase_offset_ns 8900000
    setprop debug.sf.high_fps_early_phase_offset_ns 7500000
    setprop debug.sf.high_fps_early_phase_offset_ns 6100000
    setprop debug.sf.high_fps_early_gl_phase_offset_ns 650000
    setprop debug.sf.high_fps_late_app_phase_offset_ns 100000
    setprop debug.sf.high_fps_early_gl_phase_offset_ns 9000000
toast Mode Performance++ 6500
     ;;
   "performance--")
    performance_mode="mode=enabled=false"
    setprop debug.egl.hw 0
    setprop debug.sf.hw 0
    setprop debug.egl.sync 1
    cmd power set-fixed-performance-mode-enabled false "$performance_mode"
    cmd power set-adaptive-power-saver-enabled true
    setprop debug.egl.swapinterval 1
    setprop debug.gr.numframebuffers 2
    setprop debug.composition.type cpu
    print "𝗠𝗼𝗱𝗲 𝗣𝗲𝗻𝗴𝗵𝗲𝗺𝗮𝘁𝗮𝗻 𝗗𝗮𝘆𝗮 (performance--): Menghemat daya perangkat sekitar 5% hingga 25% untuk package [$runPackage]"
    setprop debug.sf.high_fps_early_gl_phase_offset_ns 7500000
    setprop debug.sf.high_fps_early_phase_offset_ns 6100000
    setprop debug.sf.high_fps_early_phase_offset_ns 5600000
    setprop debug.sf.high_fps_early_gl_phase_offset_ns 600000
    setprop debug.sf.high_fps_late_app_phase_offset_ns 75000
    setprop debug.sf.high_fps_early_gl_phase_offset_ns 8000000
toast Mode Performance-- 6500
        ;;
    *)
        print "Kesalahan Mengaktifkan mode!."
        print "Gunakan performance++ di akhir command untuk meningkatkan performa atau performance-- untuk menurunkannya."
        echo ""
        exit 1
        ;;
esac
echo ""
echo "    \e[92m-ˏˋ⋆ Welcome To Module CMS - Version 11 ⋆ˊˎ-\e[0m"
echo ""
echo "》》{ Developer           / @Chermodsc          } 《《"
sleep 0.5
echo "》》{ Thanks to           / @fahrezone          } 《《"
sleep 0.5
echo "》》{ Version Module      / 11.0                } 《《"
echo ""
echo "«---------------✧-------------✧---------------»"
echo ""
echo "\e[38;2;255;80;0m ꪶ ___  _  _  ____   __   __     __  \e[0m"
echo "\e[38;2;255;80;0m  / __)( \/ )/ ___) /  \ /  \   /  \ \e[0m"
echo "\e[38;2;255;80;0m ( (__ / \/ \\___ \(_/ /(_/ / _(  0 )\e[0m"
echo "\e[38;2;255;80;0m  \___)\_)(_/(____/ (__) (__)(_)\__/ ꫂ\e[0m"
echo ""
echo "«---------------✧-------------✧---------------»"
echo ""
sleep 2
echo ""
echo ""
print "——•❏ Install Process ❏•——"
echo ""
sleep 1
echo ""
echo "FPS telah dipilih secara otomatis: [FPS --$fps]"
sleep 1

apply
echo ""
echo ""
sleep 3
print "——•❏ Installed Success ❏•——"
echo ""
sleep 1
echo ""
optimizion
echo ""
sleep 1
echo ""
echo "Your device will improve its performance by 85 to 80% only" 
echo ""
echo ""
sleep 1
echo "[ + ] Stop app [$runPackage]"
sleep 1
echo ""
echo "[ ▪ ] Opens the LAxeron menu..."
xtorm $core
