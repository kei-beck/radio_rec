class Tasks::RadikoProgramImportWeekly < Tasks::RadikoProgramImportCommon
  def execute
    # 放送局ID取得
    stations = Station.where.not(radiko_station_id: nil)
    stations.each do |station|
      xml_url = PROGRAM_LIST_URL.gsub("%",station.radiko_station_id)
      # 番組一覧読込・取込
      program_import(program_list_xml_read(xml_url))
    end
  rescue => err_msg
    p err_msg
  end
end
