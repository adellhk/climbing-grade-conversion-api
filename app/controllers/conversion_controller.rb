class ConversionController < ApplicationController

	def convert
		conversion = Conversion.new.convert(params[:input_grade])

		render json: conversion
	end

	def greet
		greeting = {message: 'hello'}
		
		render json: greeting
	end

end
