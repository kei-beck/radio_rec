class Tasks::RadikoProgramImportCommon < Tasks::RadikoCommon
  # 番組一覧読込
  def program_list_xml_read(xml_url)
    open(xml_url, 'rb').read
  rescue
    raise "番組一覧の読込に失敗しました。"
  end

  # 番組一覧取込
  def program_import(xml_stream)
    xml_doc = REXML::Document.new(xml_stream)
    xml_doc.each_element("//radiko/stations/station") do |xml_station|
      station_id = xml_station.attribute("id").value
      station = Station.where(radiko_station_id: station_id).first
      xml_station.each_element("scd/progs") do |xml_progs|
        xml_progs.elements.each do |xml_prog|
          next unless xml_prog.name == "prog"
          # 番組変更チェックとセーブ
          program_change_confirm_and_save!(station.id,station_id,xml_prog)
        end
      end
    end
  end

  # 番組変更チェックとセーブ
  def program_change_confirm_and_save!(station_id,radiko_station_id,xml)
    start_time  = xml.attribute("ft").value.slice(0,12)
    end_time    = xml.attribute("to").value.slice(0,12)
    air_time    = xml.attribute("dur").value
    title       = str_escape(xml.elements["title"].text)
    sub_title   = str_escape(xml.elements["sub_title"].text)
    performer   = str_escape(xml.elements["pfm"].text)
    description = str_escape(xml.elements["desc"].text)
    information = str_escape(xml.elements["info"].text)
    tmp_str = []
    # 同一時間帯の番組存在確認
    program = Program.where(station_id: station_id,
                            start_time: start_time,
                            end_time:   end_time).first
    if program.present?
      # 存在する場合、番組タイトル・出演者が変更されてないか確認
      if title != program.title || performer != program.performer
        tmp_str << "番組名・出演者が変更されました。"
        tmp_str << "#{radiko_station_id} #{start_time}~#{end_time}"
        tmp_str << "[番組名]#{program.title} -> #{title}"
        tmp_str << "[出演者]#{program.performer} -> #{performer}"
      end
    else
      # 存在しない場合、新規取込か時間変更等の可能性あり
      tmp_time = end_time.to_i - 1
      program = Program.where(["station_id = ? and start_time between ? and ?", \
                              station_id, start_time, tmp_time.to_s])

      if program.present?
        tmp_str << "#{radiko_station_id} #{start_time}~#{end_time}[#{title}]により"
        tmp_str << "下記の放送予定を削除しました。"
        program.each do | del_program |
          tmp_str << "#{radiko_station_id} #{del_program.start_time}~#{del_program.end_time} [#{del_program.title}]"
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
    program.description = description
    program.information = information
    program.save!
  end
end