class Tasks::ReservationRegister < Tasks::RadioRecCommon

  def execute
    # keyword取得
    keywords = Keyword.all
    # keywordごとにprogram検索
    keywords.each do |keyword|
      programs = find_program_by_keyword(keyword)
      programs && programs.each do |program|
        reservation_check_and_save!(program)
      end
    end
  rescue => err_msg
    p err_msg
  end

  def find_program_by_keyword(keyword)
    where_arr = []
    param_arr = []
    like_str  = "%#{keyword.keyword}%"

    where_arr << "title like ?"       if keyword.title_flg
    where_arr << "sub_title like ?"   if keyword.sub_title_flg
    where_arr << "performer like ?"   if keyword.performer_flg
    where_arr << "description like ?" if keyword.description_flg
    where_arr << "information like ?" if keyword.information_flg

    param_arr << where_arr.join(" or ")
    where_arr.each{|var|param_arr << like_str}

    Program.where(param_arr)
  end

  def reservation_check_and_save!(program)
    # 同一番組の存在確認
    reservation = Reservation.where(program_id: program.id).first
    if reservation.blank?
      reservation = Reservation.new(program_id: program.id,
                                    status:     REC_STATUS[:NOT_YET])
    end
    reservation.station_id = program.station_id
    reservation.start_time = program.start_time
    reservation.air_time   = program.air_time
    reservation.title      = program.title
    reservation.performer  = program.performer
    reservation.save!
  end
end