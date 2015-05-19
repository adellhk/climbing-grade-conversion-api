class ConversionController < ApplicationController

	def convert
		render json: Conversion.new.convert(params[:input_grade])
	end
	
end
