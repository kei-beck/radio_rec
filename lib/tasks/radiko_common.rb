require 'open-uri'
require 'rexml/document'

class Tasks::RadikoCommon < Tasks::RadioRecCommon
  TMP_DIR       = "tmp/radiko"
  KEY_NAME      = "authkey.png"
  
  RADIKO_URL       = "radiko.jp"
  SWF_VERSION      = "4.1.0.00"
  # PLAYER_NAME      = "player_#{SWF_VERSION}.swf"
  PLAYER_NAME      = "myplayer-release.swf"
  # PLAYER_URL       = "http://#{RADIKO_URL}/player/swf/#{PLAYER_NAME}"
  PLAYER_URL       = "http://#{RADIKO_URL}/apps/js/flash/#{PLAYER_NAME}"
  AUTH_FMS_URL     = "https://#{RADIKO_URL}/v2/api/auth%_fms"
  STREAM_XML       = "http://#{RADIKO_URL}/v2/station/stream/%.xml"
  STATION_LIST_URL = "http://#{RADIKO_URL}/v2/station/list/%.xml"
  PROGRAM_LIST_URL          = "http://#{RADIKO_URL}/v2/api/program/station/weekly?station_id=%"
  PROGRAM_LIST_URL_TODAY    = "http://#{RADIKO_URL}/v2/api/program/today?area_id=%"
  PROGRAM_LIST_URL_TOMMOROW = "http://#{RADIKO_URL}/v2/api/program/tomorrow?area_id=%"

  def initialize()
    make_tmp_directory(TMP_DIR)
    @authtoken = nil
    p "-----#{Time.now}---------------"
  end

  def get_auth_fms_repeatedly(key_file)
    get_auth_fms(key_file,get_auth_fms)
  end
  def get_auth_fms(key_file=nil, auth_fms=nil)
    partialkey = nil
    if key_file.nil? && auth_fms.nil?
      times = "1"
    else
      times = "2"
      @authtoken = Regexp.new(/x-radiko-authtoken: ([\w-]+)/i).match(auth_fms)[1]
      keyoffset = Regexp.new(/x-radiko-keyoffset: (\d+)/i).match(auth_fms)[1]
      keylength = Regexp.new(/x-radiko-keylength: (\d+)/i).match(auth_fms)[1]
      partialkey = `dd if=#{key_file} bs=1 skip=#{keyoffset} count=#{keylength} 2> /dev/null | base64`.chomp
    end
    tmp_url = AUTH_FMS_URL.gsub("%",times)
    wget_str = 'wget -q '
    wget_str << "--header='pragma: no-cache' "
    wget_str << "--header='X-Radiko-App: pc_1' "
    wget_str << "--header='X-Radiko-App-Version: #{SWF_VERSION}' "
    wget_str << "--header='X-Radiko-User: test-stream' "
    wget_str << "--header='X-Radiko-Device: pc' "
    wget_str << "--header='X-Radiko-Authtoken: #{@authtoken}' " if @authtoken.present?
    wget_str << "--header='X-Radiko-Partialkey: #{partialkey}' " if partialkey.present?
    wget_str << "--post-data='\r\n' "
    wget_str << "--no-check-certificate "
    wget_str << "--save-headers "
    wget_str << "#{tmp_url} -O -"
    `#{wget_str}`
  rescue
    raise "auth#{times}_fmsのダウンロードに失敗しました。"
  end

  def get_keydata
    pick_keydata(player_download)
  end
  
  def player_download
    open("#{@tmp_dir}/#{PLAYER_NAME}", "wb") do | saved_file |
      open(PLAYER_URL, 'rb') do | read_file |
        saved_file.write(read_file.read)
      end
    end
    "#{@tmp_dir}/#{PLAYER_NAME}"
  rescue
    raise "プレイヤーのダウンロードに失敗しました。¥n#{PLAYER_URL}"
  end

  def pick_keydata(player)
    dir = "#{@tmp_dir}/#{KEY_NAME}"
    `swfextract -b 14 #{player} -o #{dir}`
    dir
  rescue
    raise "キーデータの取り出しに失敗しました。"
  end

end