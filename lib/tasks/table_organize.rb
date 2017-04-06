class Tasks::TableOrganize < Tasks::RadioRecCommon

  def execute
    # 削除対象日
    @ago = (Time.now - 2.week).strftime("%Y%m%d%H%M")
    # organize methodをまとめて呼び出し
    self.public_methods(false).each do |method_name|
      send(method_name) if method_name.to_s.include?("organize")
    end
  rescue => err_msg
    p err_msg
  end

  def programs_organize
    Program.destroy_all(["start_time < ?",@ago])
  end

  def reservations_organize
    Reservation.destroy_all(["start_time < ?",@ago])
  end  
end