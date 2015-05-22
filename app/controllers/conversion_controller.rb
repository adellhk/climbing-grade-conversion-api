class ConversionController < ApplicationController

	def convert
		puts 'In conversion#convert!' * 20
		conversion = Conversion.new.convert(params[:input_grade])

		render json: conversion
	end

	def greet
		greeting = {message: 'hello'}
		
		render json: greeting
	end

end
