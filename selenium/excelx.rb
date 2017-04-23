class Excelx
  require 'roo'
  require 'date'

  def purse()
    d = Date.today
    workbook = Roo::Excelx.new($EXCELX)
    wb_value = workbook.drop(0).compact
    wb_ary = [wb_value[0], wb_value[1]].transpose
    wb_hash = Hash[*wb_ary.flatten]
    wb_hash['有効期限(年)'] = wb_hash['有効期限(年)'].to_i - d.year.to_i
    wb_hash
  end
end
