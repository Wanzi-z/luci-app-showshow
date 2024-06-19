#!/usr/bin/lua

local function handle_update_wifi()
    local json = require("cjson")
    ngx.req.read_body()
    local data = ngx.req.get_body_data()
    local decoded = json.decode(data)

    local type = decoded.type
    local name = decoded.name
    local password = decoded.password

    if name then
        if type == "wifi24" then
            os.execute('uci set wireless.@wifi-iface[0].ssid="' .. name .. '"')
        elseif type == "wifi5" then
            os.execute('uci set wireless.@wifi-iface[1].ssid="' .. name .. '"')
        end
    end

    if password then
        if type == "wifi24" then
            os.execute('uci set wireless.@wifi-iface[0].key="' .. password .. '"')
        elseif type == "wifi5" then
            os.execute('uci set wireless.@wifi-iface[1].key="' .. password .. '"')
        end
    end

    os.execute("uci commit wireless")
    os.execute("wifi reload")

    ngx.say('{"status": "success"}')
end

local function handle_toggle_detect(action)
    if action == "start" then
        os.execute("uci set ua2f.enabled.enabled=1")
        os.execute("uci set ua2f.firewall.handle_fw=1")
        os.execute("uci set ua2f.firewall.handle_intranet=1")
        os.execute('uci set ua2f.main.custom_ua="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/114514"')
        os.execute("uci commit ua2f")
        os.execute("service ua2f enable")
        os.execute("service ua2f start")
    elseif action == "stop" then
        os.execute("service ua2f stop")
    end
    ngx.say('{"status": "success"}')
end

local function handle_status()
    local cpu_usage = io.popen("top -bn1 | grep 'CPU:' | awk '{print 100 - $8}'"):read("*a")
    local mem_usage = io.popen("free | grep Mem | awk '{print $3/$2 * 100.0}'"):read("*a")
    local upload_speed = io.popen("ifstat -i eth0 1 1 | awk 'NR==4 {print $6 \" KB/s\"}'"):read("*a")
    local download_speed = io.popen("ifstat -i eth0 1 1 | awk 'NR==4 {print $8 \" KB/s\"}'"):read("*a")
    local baidu_status = os.execute("ping -c 1 www.baidu.com > /dev/null 2>&1") == 0 and "Connected" or "Disconnected"
    local google_status = os.execute("ping -c 1 www.google.com > /dev/null 2>&1") == 0 and "Connected" or "Disconnected"
    local device_count = io.popen("iw dev wlan0 station dump | grep Station | wc -l"):read("*a")
    local detect_enabled = os.execute("uci get ua2f.enabled.enabled") == 0

    ngx.say('{"cpu": "' .. cpu_usage:match("%S+") .. '", "memory": "' .. mem_usage:match("%S+") .. '", "upload": "' .. upload_speed:match("%S+") .. '", "download": "' .. download_speed:match("%S+") .. '", "baidu": "' .. baidu_status .. '", "google": "' .. google_status .. '", "device_count": "' .. device_count:match("%S+") .. '", "detect_enabled": ' .. tostring(detect_enabled) .. '}')
end

local uri = ngx.var.uri

if uri == "/cgi-bin/update_wifi" then
    handle_update_wifi()
elseif uri == "/cgi-bin/toggle_detect" then
    local args = ngx.req.get_uri_args()
    handle_toggle_detect(args.action)
elseif uri == "/cgi-bin/status" then
    handle_status()
else
    ngx.say('{"status": "error", "message": "未知请求"}')
end
