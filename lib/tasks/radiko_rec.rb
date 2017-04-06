class Tasks::RadikoRec < Tasks::RadikoCommon

  def execute(hash)
    @param_hash = hash
    make_station_directory(@param_hash[:station].radiko_station_id)
    # 認証処理
    auth_fms = get_auth_fms_repeatedly(get_keydata)
    # 録音処理
    recording
    nil
  rescue => err_msg
    err_msg
  end

  def recording
    stream_hash = stream_uri_parse(stream_xml_download)
    # 出力ファイル名
    out_dir =  "#{@station_dir}/"
    out_dir << "#{@param_hash[:reservation].title.gsub(" ","_")}"
    out_dir << "_#{@param_hash[:reservation].start_time.slice(0,8)}"
    out_dir << "_#{@param_hash[:reservation].start_time.slice(8,4)}"
    # rtmpdumpコマンド
    dump_cmd =  "rtmpdump -q -v -r '#{stream_hash[:rtmpe_url]}' "
    dump_cmd << "--app '#{stream_hash[:app]}' "
    dump_cmd << "--playpath '#{stream_hash[:playpath]}' "
    dump_cmd << "-W #{PLAYER_URL} "
    dump_cmd << "-C S:'' -C S:'' -C S:'' -C S:#{@authtoken} "
    dump_cmd << "--live --stop #{@param_hash[:reservation].air_time} "
    dump_cmd << "--flv #{out_dir}.flv"
    # 開始時刻まで待機
    sleep_time = @param_hash[:reservation].start_time.to_time  - Time.now
    sleep sleep_time if sleep_time > 0
    # 録音開始
    `#{dump_cmd}`
    # `ffmpeg -i #{out_dir}.flv -acodec copy #{out_dir}.m4a`
    start_time = @param_hash[:reservation].start_time.slice(0,8)
    date = "#{start_time.slice(0,4)}-#{start_time.slice(4,2)}-#{start_time.slice(6,2)}"
    ffmpeg_cmd =  "ffmpeg -loglevel quiet -y "
    ffmpeg_cmd << "-i #{out_dir}.flv "
    ffmpeg_cmd << "-timestamp now -ab 46k -ar 48k "
    ffmpeg_cmd << "-strict experimental "
    ffmpeg_cmd << "-metadata genre=Radio "
    ffmpeg_cmd << "-metadata date=#{date} "
    ffmpeg_cmd << "-acodec libfdk_aac "
    ffmpeg_cmd << "#{out_dir}.m4a"
    `#{ffmpeg_cmd}`
    # File.delete("#{out_dir}.flv")
  end

  def stream_xml_download
    xml_stream = open(STREAM_XML.gsub("%",@param_hash[:station].radiko_station_id), 'rb').read
    xml_doc = REXML::Document.new(xml_stream)
    xml_doc.elements['url/item'].text
  end
  
  def stream_uri_parse(uri)
    tmp_arr = uri.split("/")
    {rtmpe_url: "#{tmp_arr.shift(3).join("/")}",
     playpath:  "#{tmp_arr.pop}",
     app:       "#{tmp_arr.join("/")}"}
  end

end