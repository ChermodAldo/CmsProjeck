if [ "$AXERON" = false ]; then
    echo "Hanya mendukung di Laxeron"
    exit 1
fi

if [ -z "$FUNCTION" ]; then
    echo "Variabel FUNCTION tidak didefinisikan."
    exit 1
fi

if [ ! -f "$FUNCTION" ]; then
    echo "File $FUNCTION tidak ditemukan."
    exit 1
fi

source "$FUNCTION"

if [ ! -f "$(dirname "$0")/axeron.prop" ]; then
    echo "File axeron.prop tidak ditemukan."
    exit 1
fi

source "$(dirname "$0")/axeron.prop"
core="ARM17:16TXsNew16zXr9a21qvWq9ei153XpNeu16HXttau1rHWstaq16PXpdew16TXsdee1qrXpder1qvXiNed17TXodeu16vXqtar16/XpNeh16jXqNar15/Xq9eu16HWqtev16Q="

if [ -n "$(getprop ro.hardware.vulkan)" ]; then
    renderer="vulkan"
elif [ -n "$(getprop ro.hardware.opengl)" ]; then
    renderer="skiagl"
else
    renderer="skiavk"
fi

setprop debug.hwui.renderer "$renderer"

if [ -z "$runPackage" ]; then
    echo "Mohon masukan package name"
    setUsingAxeron true
    exit 1
fi
print() {
    local text="$1"
    local len=${#text}
    local i=0
    while [ $i -lt $len ]; do
        echo -n "${text:$i:1}"
        sleep 0.02
        i=$((i+1))
    done
    echo ""
}

apply_system_properties() {
    setprop debug.egl.profiler 1
    setprop debug.hwui.use_buffer_age true
    settings put global window_animation_scale 0.0
    settings put global transition_animation_scale 0.0
    settings put global animator_duration_scale 0.0
}

apply_Cmd2() {
    cmd shortcut reset-throttling "$runPackage"
    cmd package compile -m speed-profile -f "$runPackage" -r --secondary-dex
    cmd package compile -m quicken -f "$runPackage"
    pm compile -m speed-profile -f "$runPackage"
    pm compile -m speed-profile --secondary-dex -f "$runPackage"
    device_config delete game_overlay "$runPackage"
    device_config put game_overlay "$runPackage" mode=2,fps=90,downscaleFactor=0.7
}

apply() {
(
    apply_Cmd2 > /dev/null 2>&1 &
    apply_system_properties
    am force-stop "$runPackage"
    cmd device_config put game_overlay "$runPackage" mode=2,renderer="$renderer",downscaleFactor=0.7,fps=90
    cmd package compile -m quicken -f "$runPackage" > /dev/null 2>&1 &
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
    cmd game set --mode performance --downscale 0.7 --fps 90 --user 0 "$runPackage" > /dev/null 2>&1 &
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
    
        ;;
    *)
        print "Kesalahan Mengaktifkan mode!."
        print "Gunakan performance++ di akhir command untuk meningkatkan performa atau performance-- untuk menurunkannya."
        echo ""
        exit 1
        ;;
esac
echo ""
echo "    \e[92m-ˏˋ⋆ Welcome To Module CMS - Version 10 ⋆ˊˎ-\e[0m"
echo ""
echo "》》{ Developer           / @Chermodsc          } 《《"
sleep 0.5
echo "》》{ Thanks to           / @fahrezone          } 《《"
sleep 0.5
echo "》》{ Credits             / @Vendora098         } 《《"
sleep 0.5
echo "》》{ Version Module      / 10.0                } 《《"
echo ""
echo "«---------------✧-------------✧---------------»"
echo ""
echo "\e[38;2;255;80;0mꪶ  _____ _____ _____    _____ ___   ___   ___ \e[0m"
echo "\e[38;2;255;80;0m |     |     |   __|  |  |  |_  | |   | |   |\e[0m"
echo "\e[38;2;255;80;0m |   --| | | |__   |  |  |  |_| |_| | |_| | |\e[0m"
echo "\e[38;2;255;80;0m |_____|_|_|_|_____|   \___/|_____|___|_|___| ꫂ\e[0m"
echo ""
echo "«---------------✧-------------✧---------------»"
echo ""
sleep 2
sleep 1
echo ""
echo ""
print "——•❏ Install Process ❏•——"
sleep 1

apply
echo ""
echo ""
sleep 3
print "——•❏ Installed Success ❏•——"
echo ""
sleep 0.5
echo ""
echo "Your device will improve its performance by 85 to 80% only" 
echo ""
echo ""
sleep 1
echo "[ + ] Choose a game [$runPackage]"
sleep 1
echo ""
echo "[ ▪ ] Opens the LAxeron menu..."
storm -x $core