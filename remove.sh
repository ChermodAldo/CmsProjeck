if [ $AXERON = false ]; then
	echo "Only Support in Laxeron"
fi

source $FUNCTION
source $(dirname $0)/axeron.prop

echo ""
echo "》》 Proses Uninstall 𝙲𝙼𝚂 𝚅𝙴𝚁𝚂𝙸𝙾𝙽 -> 10.0 《《"
echo ""
sleep 0.5
echo "Wait.."
echo ""
echo ""
sleep 3
echo "Close the application [$runPackage]"
echo ""
echo ""
sleep 5
    am force-stop "$runPackage"
    cmd activity kill-all
    cmd thermalservice override-status 0

reset_system_properties() {
    settings put global window_animation_scale 1.0
    settings put global transition_animation_scale 1.0
    settings put global animator_duration_scale 1.0
    settings delete global window_animation_scale
}
uninstall() {
    reset_system_properties
}

uninstall > /dev/null 2>&1

echo "Uninstall berhasil. Semua perubahan dikembalikan ke nilai default."
echo ""
echo "{}{-------[ Don't forget to Reboot! ]-------}"
echo ""
echo ""