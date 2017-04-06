require 'open-uri'
require 'json'

class Tasks::RadiruCommon < Tasks::RadioRecCommon
  TMP_DIR       = "tmp/radiru"

  NHK_AREAS     = 140
  NHK_SERVICES  = { r1: "r1",
                    r2: "r2",
                    fm: "r3"}
  NHK_PLAYPATH  = { r1: "NetRadio_R1_flash@63346",
                    r2: "NetRadio_R2_flash@63342",
                    fm: "NetRadio_FM_flash@63343"}
  API_URL          = "api.nhk.or.jp/v1/pg"
  API_KEY          = ""
  PROGRAM_LIST_URL = "http://#{API_URL}/list/#{NHK_AREAS}/%service/%date.json?key=#{API_KEY}"
  PROGRAM_INFO_URL = "http://#{API_URL}/info/#{NHK_AREAS}/%service/%id.json?key=#{API_KEY}"
  NHK_RTMPE_URL    = "rtmpe://netradio-%-flash.nhk.jp"
  NHK_RTMPE_SWF    = "http://www3.nhk.or.jp/netradio/files/swf/rtmpe.swf"

  def initialize()
    make_tmp_directory(TMP_DIR)
    p "-----#{Time.now}---------------"
  end

end