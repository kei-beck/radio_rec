class Tasks::RadiruRec < Tasks::RadiruCommon

  def execute(hash)
    @param_hash = hash
    make_station_directory(@param_hash[:station].radiru_station_id)
    # 録音処理
    recording
    nil
  rescue => err_msg
    err_msg
  end

  def recording
    # 出力ファイル名
    out_dir = "#{@station_dir}/"
    out_dir << "#{@param_hash[:reservation].title.gsub(" ","_")}"
    out_dir << "_#{@param_hash[:reservation].start_time.slice(0,8)}"
    out_dir << "_#{@param_hash[:reservation].start_time.slice(8,4)}"
    # rtmpdumpコマンド
    station_id = @param_hash[:station].radiru_station_id
    dump_cmd =  "rtmpdump -q "
    dump_cmd << "--rtmp '#{NHK_RTMPE_URL.gsub("%",station_id)}' "
    dump_cmd << "--playpath '#{NHK_PLAYPATH[station_id.to_sym]}' "
    dump_cmd << "--app 'live' "
    dump_cmd << "--swfVfy #{NHK_RTMPE_SWF} "
    dump_cmd << "--live --stop #{@param_hash[:reservation].air_time} "
    dump_cmd << "-o #{out_dir}_rec.m4a"
    # 開始時刻まで待機
    sleep_time = @param_hash[:reservation].start_time.to_time  - Time.now
    sleep sleep_time if sleep_time > 0
    # 録音開始
    `#{dump_cmd}`
    # `ffmpeg -i #{out_dir}.flv -acodec copy #{out_dir}.m4a`
    start_time = @param_hash[:reservation].start_time.slice(0,8)
    date = "#{start_time.slice(0,4)}-#{start_time.slice(4,2)}-#{start_time.slice(6,2)}"
    ffmpeg_cmd =  "ffmpeg -loglevel quiet -y "
    ffmpeg_cmd << "-i #{out_dir}_rec.m4a "
    ffmpeg_cmd << "-timestamp now "
    ffmpeg_cmd << "-strict experimental "
    ffmpeg_cmd << "-metadata genre=Radio "
    ffmpeg_cmd << "-metadata date=#{date} "
    ffmpeg_cmd << "-acodec libfdk_aac "
    ffmpeg_cmd << "#{out_dir}.m4a"
    `#{ffmpeg_cmd}`
    # File.delete("#{out_dir}.flv")
  end

end