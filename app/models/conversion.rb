class Hash
	# from https://gist.github.com/NigelThorne/2913760
  # like invert but not lossy
  #{1=>2,3=>2,2=>4}.inverse => {2=>[1, 3], 4=>[2]} 
  def inverse
  	self.each_with_object( {} ) { |(key, value), out| ( out[value] ||= [] ) << key }
  end
end

class Conversion < ActiveRecord::Base
	def initialize
		setup_translations
		setup_standards
	end

	def standardize_french
		{
			'1' => 1,
			'2' => [1, 2],
			'3' => 2,
			'4' => 3,
			'4+' => 4,
			'5a' => 5,
			'5b' => 6,
			'6a' => 7,
			'6a+' => 8,
			'6b' => 9,
			'6b+' => 10,
			'6c' => 11,
			'6c+' => 12,
			'7a' => 13,
			'7a+' => 14,
			'7b' => 15,
			'7b+' => 16,
			'7c' => 17,
			'7c+' => 18,
			'8a' => 19,
			'8a+' => 20,
			'8b' => 21,
			'8b+' => 22,
			'8c' => 23,
			'8c+' => 24,
			'9a' => 25
		}
	end

	def standardize_uk
		{
			'HVD' => 1,
			'MS' => 2,
			'S' => 3,
			'VS' => 4,
			'HVS' => 6,
			'E1 5b' => 7,
			'E2 5c' => 8,
			'E3 5c' => 10,
			'E4 6a' => 12,
			'E5 6b' => 14,
			'E6 6b' => 16,
			'E7 6c' => 19,
			'E8 7a' => 21,
			'E9 7b' => 23,
			'E10 7c' => 25
		}
	end

	def standardize_australian
		{
			'8' => 1,
			'9' => 1,
			'10' => 2,
			'11' => 2,
			'12' => 2,
			'13-' => 3,
			'13+' => 4,
			'14' => 5,
			'15' => 6,
			'19' => [7, 8],
			'20' => [8, 9],
			'21' => [10, 11],
			'22' => [11, 12],
			'23' => 13,
			'24' => 14,
			'25' => 15,
			'26' => 16,
			'27' => 17,
			'28' => 18,
			'29' => 19,
			'30' => 20,
			'31' => 21,
			'32' => 22,
			'33' => 23,
			'34' => 24,
			'35' => 25
		}
	end

	def standardize_uiaa
		{
			'I' => 1,
			'II' => 1,
			'III' => 2,
			'IV' => 3,
			'V-' => 4,
			'V' => 5,
			'V+' => 6,
			'VI+' => [7, 8],
			'VII-' => 8,
			'VII' => 9,
			'VII+' => [10, 11],
			'VIII-' => 11,
			'VIII' => [13, 14],
			'VIII+' => [14, 15],
			'IX-' => 16,
			'IX' => [17, 18],
			'IX+' => [18, 19],
			'X-' => 20,
			'X' => [21, 22],
			'X+' => [22, 23],
			'XI-' => 24,
			'XI' => 25
		}
	end

	def standardize_yds
		{
			'5.2' => 1,
			'5.3' => 1,
			'5.4' => 2,
			'5.5' => 2,
			'5.6' => 3,
			'5.7' => 4,
			'5.8' => 5,
			'5.9' => 6,
			'5.10a' => 7,
			'5.10b' => 8,
			'5.10c' => 9,
			'5.10d' => 10,
			'5.11a' => 11,
			'5.11b' => 12,
			'5.11c' => 13,
			'5.11d' => 13,
			'5.12a' => 14,
			'5.12b' => 15,
			'5.12c' => 16,
			'5.12d' => 17,
			'5.13a' => 18,
			'5.13b' => 19,
			'5.13c' => 20,
			'5.13d' => 21,
			'5.14a' => 22,
			'5.14b' => 23,
			'5.14c' => 24,
			'5.14d' => 25,
			'5.15a' => 25	
		}
	end

	def setup_standards
		@standards = Hash['French' => standardize_french, 'UIAA' => standardize_uiaa, 'UK' => standardize_uk, 'Australian' => standardize_australian, 'YDS' => standardize_yds]
	end

	def setup_translations
		@translations = {}

		[standardize_french, standardize_uiaa, standardize_uk, standardize_australian, standardize_yds].each do |table|
			@translations.merge!(table.inverse){ |key, v1, v2| [v1, v2].flatten }

			@translations.each_pair do |key, value|
				if key.class == Array
					key.each do |element|
						value.each{|val| @translations[element] << val}
					end
					@translations.delete(key)
				end
			end
		end
	end

	def convert(input_grade)
		all_translations = @translations[standardize_input(input_grade)]
		paired_translations = {}
		all_translations.each do |translation|
			paired_translations['french'] = translation if standardize_french.has_key?(translation)
			paired_translations['uk'] = translation if standardize_uk.has_key?(translation)
			paired_translations['australian'] = translation if standardize_australian.has_key?(translation)
			paired_translations['uiaa'] = translation if standardize_uiaa.has_key?(translation)
			paired_translations['yds'] = translation if standardize_yds.has_key?(translation)
		end
		paired_translations
	end

	def standardize_input(input_grade)
		@standards.each_pair do |table_name, grades|
			return grades[input_grade] if grades[input_grade]
		end
		nil
	end

end

# translations.each_key { |key| puts "#{key}: #{translations[key]}"  }

# from http://www.mec.ca/AST/ContentPrimary/Learn/Climbing/IntroToClimbing/ClimbingGradeConversion.jsp
# 1		1-2	HVD			8-9			I-II					5.2-5.3
# 2		2-3	MS			10-12		III						5.4-5.5
# 3		4		S				13-			IV						5.6
# 4		4+	VS			13+			V-						5.7
# 5		5a		 			14			V							5.8
# 6		5b	HVS			15			V+						5.9			V0			B1	4
# 7		6a	E1 5b		19			VI+						5.10a		V0+			B2	4+
# 8		6a+	E2 5c		19 / 20	VI+ / VII-		5.10b
# 9		6b	 				20			VII						5.10c		V1			B3	5
# 10	6b+	E3 5c		21			VII+					5.10d
# 11	6c	 				21 / 22	VII+ / VIII-	5.11a		V2			B4	6a
# 12	6c+ E4 6a		22			VIII-					5.11b		V3		B5-6	6a+
# 13	7a			 		23			VIII					5.11c/d	V4					6b/c
# 14	7a+	E5 6b		24			VIII / VIII+	5.12a
# 15	7b	 				25			VIII+					5.12b		V5					6c+
# 16	7b+	E6 6b		26			IX-						5.12c		V6			B7	7a
# 17	7c	 				27			IX						5.12d
# 18	7c+	 				28			IX / IX+			5.13a		V7			B8	7a+
# 19	8a	E7 6c		29			IX+						5.13b		V8			B9	7b+
# 20	8a+	 				30			X-						5.13c		V9					7c
# 21	8b	E8 7a		31			X							5.13d
# 22	8b+			 		32			X / X+				5.14a		V10			B10	7c+
# 23	8c	E9 7b		33			X+						5.14b		V11			B11	8a
# 24	8c+	 				34			XI-						5.14c		V12/13	B12	8a+
# 25	9a	E10 7c	35			XI						5.14d/5.15