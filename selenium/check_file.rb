class CheckFile

  #  ファイルの中身を確認し、言語を判定
  #  言語判定基準 日本語が一文字でも含まれていたら日本語、その他は英語
  #  argument video_informations Array { title: string id: int file: string}
  #  return video_informations Array { title: string id: int file: string la: string}
  def language(video_informations)
    video_informations.each_with_index do |video_info, i|
      begin
        File.open($VTTFILES + "#{video_info[:file]}") do |file|
          file.each_line do |labmen|
            japanese_regex = /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/
            if labmen =~ japanese_regex
              video_informations[i]['la'] = 'ja'
            end
            break unless video_informations[i]['la'].nil?
          end
          if video_informations[i]['la'].nil?
            video_informations[i]['la'] = 'en'
          else
            break
          end
        end
      rescue SystemCallError => e
        next
      rescue IOError => e
        next
      end
    end
    video_informations
  end
end
