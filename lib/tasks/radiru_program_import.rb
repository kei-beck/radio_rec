class Tasks::RadiruProgramImport < Tasks::RadiruCommon
  def execute
    date_arr = [Date.today,Date.today + 1.days]
    date_arr.each do |date|
      NHK_SERVICES.each do |station_id,service|
        station = Station.where(radiru_station_id: station_id).first
        list_url    = PROGRAM_LIST_URL.gsub("%service",service).gsub("%date",date.to_s)
        json_stream = program_list_json_read(list_url)
        json_stream["list"][service].each do |program|
          program_change_confirm_and_save!(station.id,station_id,program)
        end
      end
    end
  end

  # 番組一覧読込
  def program_list_json_read(json_url)
    JSON.parse(open(json_url, 'rb').read)
  rescue
    raise "番組一覧の読込に失敗しました。 #{json_url}"
  end

  # 番組変更チェックとセーブ
  def program_change_confirm_and_save!(station_id,radiru_station_id,json)
    start_time  = json["start_time"].to_time.strftime("%Y%m%d%H%M")
    end_time    = json["end_time"].to_time.strftime("%Y%m%d%H%M")
    air_time    = (end_time.to_time - start_time.to_time).to_i
    title       = json["title"]
    sub_title   = str_escape(json["subtitle"])
    performer   = str_escape(json["subtitle"])
    tmp_str = []
    # 同一時間帯の番組存在確認
    program = Program.where(station_id: station_id,
                            start_time: start_time,
                            end_time:   end_time).first
    if program.present?
      # 存在する場合、番組タイトル・出演者が変更されてないか確認
      if title != program.title || performer != program.performer
        tmp_str << "番組名・出演者が変更されました。"
        tmp_str << "#{radiru_station_id} #{start_time}~#{end_time}"
        tmp_str << "[番組名]#{program.title} -> #{title}"
        tmp_str << "[出演者]#{program.performer} -> #{performer}"
      end
    else
      # 存在しない場合、新規取込か時間変更等の可能性あり
      tmp_time = end_time.to_i - 1
      program = Program.where(["station_id = ? and start_time between ? and ?", \
                              station_id, start_time, tmp_time.to_s])

      if program.present?
        tmp_str << "#{radiru_station_id} #{start_time}~#{end_time}[#{title}]により"
        tmp_str << "下記の放送予定を削除しました。"
        program.each do | del_program |
          tmp_str << "#{radiru_station_id} #{del_program.start_time}~#{del_program.end_time} [#{del_program.title}]"
          del_program.destroy
        end
      end
      program = Program.new(station_id: station_id,
                            start_time: start_time,
                            end_time:   end_time)
    end
    if tmp_str.present?
      p "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
      tmp_str.each{|str|p str}
    end
    # 登録・更新
    program.air_time    = air_time
    program.title       = title
    program.sub_title   = sub_title
    program.performer   = performer
    program.save!
  end
end