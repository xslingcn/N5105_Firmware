#!/bin/bash
# AutoBuild Module by Hyy2001 <https://github.com/Hyy2001X/AutoBuild-Actions>
# AutoBuild DiyScript

Firmware_Diy_Core() {

	Author=XSLING
	Default_IP="10.10.0.1"
	Default_Title="XSLING OpenWrt"

	Short_Fw_Date=true
	x86_Full_Images=false
	Fw_Format=false
	Regex_Skip="packages|buildinfo|sha256sums|manifest|kernel|rootfs|factory|itb|profile|ext4|json"

	AutoBuild_Features=false
}

Firmware_Diy() {

	# 请在该函数内定制固件

	# 可用预设变量, 其他可用变量请参考运行日志
	# ${OP_AUTHOR}			OpenWrt 源码作者
	# ${OP_REPO}			OpenWrt 仓库名称
	# ${OP_BRANCH}			OpenWrt 源码分支
	# ${TARGET_PROFILE}		设备名称
	# ${TARGET_BOARD}		设备架构
	# ${TARGET_FLAG}		固件名称后缀

	# ${WORK}			OpenWrt 源码位置
	# ${CONFIG_FILE}		使用的配置文件名称
	# ${FEEDS_CONF}			OpenWrt 源码目录下的 feeds.conf.default 文件
	# ${CustomFiles}		仓库中的 /CustomFiles 绝对路径
	# ${Scripts}			仓库中的 /Scripts 绝对路径
	# ${FEEDS_LUCI}			OpenWrt 源码目录下的 package/feeds/luci 目录
	# ${FEEDS_PKG}			OpenWrt 源码目录下的 package/feeds/packages 目录
	# ${BASE_FILES}			OpenWrt 源码目录下的 package/base-files/files 目录

	ECHO "[Firmware_Diy] Starting ..."
	echo "Version_File: ${Version_File}"
    case "${OP_AUTHOR}/${OP_REPO}:${OP_BRANCH}" in
    coolsnowwolf/lede:master)
        cat >>"${Version_File}" << 'EOF'
sed -i '/check_signature/d' /etc/opkg.conf

# if [ -z "\$(grep "REDIRECT --to-ports 53" /etc/firewall.user 2> /dev/null)" ]
# then
# 	echo '#iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
# 	echo '#iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
# 	echo '#[ -n "\$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
# 	echo '#[ -n "\$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> /etc/firewall.user
# fi
exit 0
EOF
		# sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${FEEDS_PKG}/ttyd/files/ttyd.config
		# sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci/Makefile
		# sed -i '/uci commit luci/i\uci set luci.main.mediaurlbase="/luci-static/argon-mod"' $(PKG_Finder d package default-settings)/files/zzz-default-settings

		AddPackage other vernesong OpenClash dev
		AddPackage lean jerrykuku luci-app-argon-config master
		# AddPackage themes thinktip luci-theme-neobird main
		AddPackage other fw876 helloworld master

		case "${TARGET_PROFILE}" in
		# d-team_newifi-d2)
		# 	Copy ${CustomFiles}/${TARGET_PROFILE}_system ${BASE_FILES}/etc/config system
		# 	patch < ${CustomFiles}/d-team_newifi-d2_mt76_dualband.patch -p1 -d ${WORK}
		# ;;
		x86_64)
			ls package
			ECHO "Modifying x86_64 target..."
			# sed -i "s?6.1?6.6?g" ${WORK}/target/linux/x86/Makefile
			ClashDL amd64 dev
			ClashDL amd64 tun
			ClashDL amd64 meta
			AddPackage passwall xiaorouji openwrt-passwall-packages main
			AddPackage passwall xiaorouji openwrt-passwall main
		;;
		esac
	esac
}