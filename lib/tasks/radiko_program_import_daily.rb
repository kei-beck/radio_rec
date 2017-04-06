class Tasks::RadikoProgramImportDaily < Tasks::RadikoProgramImportCommon
  def execute
    # 認証処理(エリア取得)
    auth_fms = get_auth_fms_repeatedly(get_keydata)
    area_id = Regexp.new(/(JP\d+)/).match(auth_fms)[1]
    xml_url_arr = []
    xml_url_arr << PROGRAM_LIST_URL_TODAY.gsub("%",area_id)
    xml_url_arr << PROGRAM_LIST_URL_TOMMOROW.gsub("%",area_id)
    xml_url_arr.each do |xml_url|
      # 番組一覧読込・取込
      program_import(program_list_xml_read(xml_url))
    end
  rescue => err_msg
    p err_msg
  end
end
