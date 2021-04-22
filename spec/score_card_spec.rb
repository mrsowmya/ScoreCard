# frozen_string_literal: true

require './score_card'

describe 'ScoreCard' do

	before do
		@score_card = ScoreCard.new('spec/input.csv')

		@average = { "A"=>{ students: 1, avg: 348 }, "B"=>{ students: 2, avg: 326 }, "C"=>{ students: 3, avg: 268 }}

		@a_grade = @score_card.data.select {|d| d[:grade] == "A"}
		@b_grade = @score_card.data.select {|d| d[:grade] == "B"}
		@c_grade = @score_card.data.select {|d| d[:grade] == "C"}
	end

	describe '#initialize' do
		it 'should initialize data and average' do
			expect(@score_card.average).to eq(@average)
			expect(@score_card.data.size).to eq(6)
			expect(@score_card.input_file_path).to eq ('spec/input.csv')
		end
	end

	describe 'generate average and compare' do
		it 'should set grade and average compare based on marks' do
			

			expect(@score_card.data.select {|d| d[:total] >= 348 }.map {|d| d[:grade]}.first).to eq("A")
			expect(@score_card.data.select {|d| d[:total] < 340 && d[:total] >= 300 }.map {|d| d[:grade]}.first).to eq("B")
			expect(@score_card.data.select {|d| d[:total] < 300 }.map {|d| d[:grade]}.first).to eq("C")

			expect(@a_grade.select { |d| d[:total] >= 348 }.map { |d| d[:average] }.first).to eq("ABOVE")
			expect(@b_grade.select { |d| d[:total] >= 326 }.map { |d| d[:average] }.first).to eq("ABOVE")
			expect(@b_grade.select { |d| d[:total] < 326 }.map { |d| d[:average] }.first).to eq("BELOW")
			expect(@c_grade.select { |d| d[:total] >= 268 }.map { |d| d[:average] }.first).to eq("ABOVE")
			expect(@c_grade.select { |d| d[:total] < 268 }.map { |d| d[:average] }.first).to eq("BELOW")
		end
	end

	describe 'get report' do
		it 'should generate report data' do
			expect(@a_grade.size).to eq(1)
			expect(@b_grade.size).to eq(2)
			expect(@c_grade.size).to eq(3)
		end

		it 'should have above grade and below grade data' do
			expect(@score_card.data.select {|data| data[:average] == 'ABOVE' }.size).to eq(4)
			expect(@score_card.data.select {|data| data[:average] == 'BELOW' }.size).to eq(2)

		end
	end


	describe 'generate_score_card' do
		it 'should output data to csv file' do
			File.delete('output.csv')
			@score_card.generate_score_card

			expect { File.open('output.csv') }.to_not raise_error(Errno::ENOENT)

		end
	end
	
end