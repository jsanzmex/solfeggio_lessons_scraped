input_file = ARGV[0]

def extract_description(input_str)
  match = input_str.to_enum(:scan, /aria-label="(.*?)"/).map { Regexp.last_match }
  match[0][1]
end

def extract_index(input_str)
  begin
    if not input_str.include?("\№")
      return 0
    end
    match = input_str.to_enum(:scan, /\№+ (\d+)/).map { Regexp.last_match }
    match[0][1].to_i
  rescue
    return 0
  end
end

file = File.new(input_file, "r")
match_datas = file.read.to_enum(:scan, /<a[^>]*?href=(["\'])?((?:.(?!\1|>))*.?)\1?/).map { Regexp.last_match }
selection = match_datas.select{|d| d.to_s.include?("Solfeggio")}.map{|m| {url: m[2], description: extract_description(m.to_s), index: extract_index(m.to_s)} }.sort_by! { |k| k[:index]}.uniq{|e| e[:url]}

for e in selection do
  print("[" + e[:description] + "](" + e[:url] + ")\n")
end

print("\n\n\nPrinted " + selection.length.to_s + " URLs.")
