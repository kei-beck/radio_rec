class Tasks::RadioRecController < Tasks::RadioRecCommon
  def execute
    # 予約情報の取得
    reservation = find_reservation_by_time
    return if reservation.blank?
    # 放送局情報の取得
    station = find_station_by_reservation(reservation)
    param_hash = {reservation: reservation,
                  station:     station}
    
    reservation_status_update!(reservation, REC_STATUS[:RUNNING])
    # radiko 録音処理開始
    rs = Tasks::RadikoRec.new.execute(param_hash) if station.radiko_station_id.present?
    # radiru 録音処理開始
    rs = Tasks::RadiruRec.new.execute(param_hash) if station.radiru_station_id.present?
    reservation_status_update!(reservation, rs.blank? ? REC_STATUS[:ALREADY] : REC_STATUS[:FAILURE])
  end

  def find_reservation_by_time
    # 5分以内に録音開始となる予約を取得する
    from_time = Time.now.strftime("%Y%m%d%H%M")
    to_time  = 5.minutes.from_now.strftime("%Y%m%d%H%M")
    where_str = "start_time between ? and ? and status = ?"
    Reservation.where([where_str,from_time,to_time,REC_STATUS[:NOT_YET]]) \
               .order(:start_time) \
               .first
  end

  def find_station_by_reservation(reservation)
    Station.where(id: reservation.station_id).first
  end

  def reservation_status_update!(reservation,status)
    reservation.status = status
    reservation.save!
  end
end
