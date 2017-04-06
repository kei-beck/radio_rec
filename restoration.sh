# restoration.sh

rbenv exec rails runner Tasks::RadikoProgramImportWeekly.new.execute

rbenv exec rails runner Tasks::RadikoProgramImportDaily.new.execute

rbenv exec rails runner Tasks::RadiruProgramImport.new.execute

rbenv exec rails runner Tasks::ReservationRegister.new.execute