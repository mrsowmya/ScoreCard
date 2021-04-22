# frozen_string_literal: true
require 'csv'

class ScoreCard

	GRADE_A = 'A'
	GRADE_B = 'B'
	GRADE_C = 'C'

	attr_accessor :input_file_path, :average, :data

	def initialize(input_file_path)
		@input_file_path = input_file_path
		@average = {}
		@data = generate_data
	end

	def generate_score_card
		CSV.open("output.csv", "w") do |csv|
  		
  		csv << ["ID", "Subject1", "Subject2", "Subject3", "Subject4", "Grand­Total", "Grade", "Average­Compare"]

	  	@data.each do |data|
	  		csv << data.values
			end

			csv << []

			csv << ["Grade report"]
			csv << ["Number of students in A Grade :: #{@average[GRADE_A][:students]}"]
			csv << ["Number of students in B Grade :: #{@average[GRADE_B][:students]}"]
			csv << ["Number of students in C Grade :: #{@average[GRADE_C][:students]}"]
			csv << ["Number of students above their grade average :: #{students_above_grade}"]
			csv << ["Number of students below their grade average :: #{students_below_grade}"]
		end

	end

	private

	def fetch_marks(value)
		value.split("-").last.to_i
	end
	
	def generate_data
		@data = []

		CSV.read(input_file_path).each do |row|
			s1 = fetch_marks(row[1])
			s2 = fetch_marks(row[2]) 
			s3 = fetch_marks(row[3])
			s4 = fetch_marks(row[4])

			grand_total = [s1, s2, s3, s4].sum

			@data << { id: row[0], s1: s1, s2: s2, s3: s3, s4: s4, total: grand_total, grade: get_grade(grand_total) }
		end

		generate_average

		@data.each do |data|
			data[:average] = average_compare(data[:grade], data[:total])
		end

		@data
	end

	def get_grade(marks)
		if marks >= 340
			GRADE_A
		elsif marks < 340 && marks >= 300
			GRADE_B
		elsif marks < 300
			GRADE_C
		end
	end

	def average_compare(grade, total)
		if total >= @average[grade][:avg]
			'ABOVE'
		else
			'BELOW'
		end
	end

	def generate_average
		@generate_average ||= begin

			[GRADE_A, GRADE_B, GRADE_C].each do |grade|
				data = respective_grade_students(grade)
				val = data.inject(0.0) { |sum, val| sum + val } / data.size

				@average[grade] = { students: data.size, avg: val.to_i }
			end
		end
	end

	def respective_grade_students(grade)
		@data.select { |data| data[:grade] == grade }.map { |d| d[:total] }
	end

	def students_above_grade
		@data.select { |data| data[:average] == 'ABOVE' }.size
	end

	def students_below_grade
		@data.select { |data| data[:average] == 'BELOW' }.size
	end
	
end

ScoreCard.new('input.csv').generate_score_card

