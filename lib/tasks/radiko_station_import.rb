class Tasks::RadikoStationImport < Tasks::RadikoCommon

  def execute
    # 認証処理(エリア取得)
    auth_fms = get_auth_fms_repeatedly(get_keydata)
    area_id = Regexp.new(/(JP\d+)/).match(auth_fms)[1]
    # 放送局一覧取得
    xml_stream = station_list_xml_read(area_id)    
    # 放送局取込
    station_import(xml_stream)
  rescue => err_msg
    p err_msg
  end

  # 放送局一覧取得
  def station_list_xml_read(area_id)
    open(STATION_LIST_URL.gsub("%",area_id), 'rb').read
  rescue
    raise "放送局一覧のダウンロードに失敗しました。"
  end

  # 放送局取込
  def station_import(xml_stream)
    xml_doc = REXML::Document.new(xml_stream)
    xml_doc.each_element('//stations/station') do | xml_str |
      station = Station.where(radiko_station_id: xml_str.elements["id"].text).first
      if station.blank?
        station = Station.new
        station.radiko_station_id = xml_str.elements["id"].text
      end
      station.name       = xml_str.elements["name"].text
      station.ascii_name = xml_str.elements["ascii_name"].text
      station.save!
    end
  rescue
    raise "放送局の取込に失敗しました。"
  end

end