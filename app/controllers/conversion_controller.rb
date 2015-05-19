class ConversionController < ApplicationController

	def convert
		# convert(params[:input_grade])
		p Conversion.new.convert('5.10a')
	end
end
