module("luci.controller.mypackage", package.seeall)

function index()
    entry({"admin", "status", "mypackage"}, call("render_status_page"), _("防检测状态"), 1).leaf = true
end

function render_status_page()
    local cpu_usage = io.popen("top -bn1 | grep 'CPU:' | awk '{print 100 - $8}'"):read("*a")
    local mem_usage = io.popen("free | grep Mem | awk '{print $3/$2 * 100.0}'"):read("*a")
    local upload_speed = io.popen("ifstat -i eth0 1 1 | awk 'NR==4 {print $6 \" KB/s\"}'"):read("*a")
    local download_speed = io.popen("ifstat -i eth0 1 1 | awk 'NR==4 {print $8 \" KB/s\"}'"):read("*a")
    local baidu_status = os.execute("ping -c 1 www.baidu.com > /dev/null 2>&1") == 0 and "Connected" or "Disconnected"
    local google_status = os.execute("ping -c 1 www.google.com > /dev/null 2>&1") == 0 and "Connected" or "Disconnected"
    local device_count = io.popen("iw dev wlan0 station dump | grep Station | wc -l"):read("*a")
    local detect_enabled = os.execute("uci get ua2f.enabled.enabled") == 0

    luci.http.prepare_content("application/json")
    luci.http.write_json({
        cpu = cpu_usage:match("%S+"),
        memory = mem_usage:match("%S+"),
        upload = upload_speed:match("%S+"),
        download = download_speed:match("%S+"),
        baidu = baidu_status,
        google = google_status,
        device_count = device_count:match("%S+"),
        detect_enabled = detect_enabled
    })
end
