@students = []

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "9. Exit"
end

def interactive_menu
  loop do
    print_menu
    process(gets.chomp)
  end
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      save_students
    when "4"
      load_students
    when "9"
      exit
    else
      puts "I don't know what you meant, please try again"
  end
end

def add_student_info(name, colour, cohort)
  @students << {name: name, colour: colour, cohort: cohort}
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
require "Date"
  while !name.empty? do
    puts "What is their favourite colour?"
    colour = STDIN.gets.chomp.capitalize
    puts "Which cohort is #{name} in?"
    cohort = STDIN.gets.chomp.capitalize
    if Date::MONTHNAMES.include? cohort
      cohort = cohort.to_sym
      add_student_info(name, colour, cohort)
    else puts "Please enter a valid month"
      cohort = STDIN.gets.chomp
      add_student_info(name, colour, cohort)
    end

    if @students.count == 1
      puts "Now we have #{@students.count} student. Please enter next student or hit return."
    else @students.count > 1
    puts "Now we have #{@students.count} students. Please enter next student or hit return."
  end
    name = gets.chomp
  end
  @students
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

=begin
#def print(students)
  students.each_with_index { |(student), index|
   if "#{student[:name]}".length < 12
    if "#{student[:name]}".start_with?('S','s')
      puts "#{index+1}. #{student[:name]} (#{student[:cohort]} cohort)".center(30)
   end
    }
end
=end

def print_student_list
  existing_cohorts = @students.map do |student|
    student[:cohort]
  end.uniq
  existing_cohorts.each do |cohort|
    puts "The students in the #{cohort.to_s} cohort are:"
    @students.each do |student|
      if student[:cohort] == cohort
         puts student[:name]
      end
    end
  end
end

def print_footer(students)
  if @students.count == 1
    puts "Overall, we have #{@students.count} great student"
  elsif @students.count > 1
    puts "Overall, we have #{@students.count} great students"
  else
    puts "There are no students in this academy"
  end
end

#@students = input_students
def show_students
  print_header
  print_student_list
  print_footer(@students)
end

def save_students
  file = File.open("students.csv", "w")
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, cohort = line.chomp.split(',')
    @students << {name: name, cohort: cohort.to_sym}
  end
  file.close
end

interactive_menu
