class Tasks::RadioRecCommon

  BASE_DIR_NAME = "radio_rec"

  REC_STATUS = {
    NOT_YET: 0,
    RUNNING: 1,
    ALREADY: 2,
    FAILURE: 9
  }

  def make_tmp_directory(tmp_dir)
    @tmp_dir = "#{make_root}/#{tmp_dir}"
    FileUtils.mkdir_p(@tmp_dir) unless File.exist?(@tmp_dir)
  end

  def make_station_directory(station_id=nil)
    return if station_id.nil?
    @station_dir = "#{@tmp_dir}/#{station_id}"
    FileUtils.mkdir_p(@station_dir) unless File.exist?(@station_dir)
  end

  def make_root
    tmp = []
    __FILE__.split("/").each do | dir |
      tmp << dir
      break if dir == BASE_DIR_NAME
    end
    tmp.join("/")
  end

  def str_escape(str)
    return nil if str.nil?
    str.gsub("'", "").gsub("\"", "").gsub("\n","")
  end

  def initialize()
    p "-----#{Time.now}---------------"
  end

end
