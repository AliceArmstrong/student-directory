@students = []
@default_filename = "students.csv"

def print_menu # Main menu
  puts "-------------------------"
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save list"
  puts "4. Load list"
  puts "9. Exit"
  puts "-------------------------"
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
      success
      input_students
    when "2"
      success
      show_students
    when "3"
      save_students
    when "4"
      menu_load_students
    when "9"
      success
      exit
    else
      puts "I don't know what you meant, please try again"
  end
end

def add_student_info(name, cohort)
  @students << {name: name, cohort: cohort}
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
    until Date::MONTHNAMES.include? cohort
      puts "Please enter a valid month"
      cohort = STDIN.gets.chomp
    end
    cohort = cohort.to_sym
    add_student_info(name, cohort)

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
  puts "Please type name of file to save to (including extension). Blank entry defaults to #{@default_filename}"
  filename = STDIN.gets.chomp
  filename = @default_filename if filename.empty?
  if File.exists?(filename)
    file = File.open(filename, "w")
    @students.each { |student|
      student_data = [student[:name], student[:cohort]]
      csv_line = student_data.join(",")
      file.puts csv_line
    }
    success
    file.close
  else
    file_error(filename)
    return
  end
end

def cmd_load_students
  filename = ARGV.first
  filename = @default_filename if filename.nil?
  if File.exists?(filename)
    load_students(filename)
  else
    file_error(filename)
    return
  end
end

def menu_load_students
  puts "Please type name of file to load from (including extension). Blank entry defaults to #{@default_filename}"
  filename = STDIN.gets.chomp
  filename = @default_filename if filename.empty?
  if File.exists?(filename)
    load_students(filename)
  else
    file_error(filename)
    return
  end
end

def load_students(filename = @default_filename)
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, cohort = line.chomp.split(',')
    add_student_info(name, cohort)
  end
    puts "Loaded #{@students.count} from #{filename}"
  file.close
end

def success
  puts "Action successful"
end

def file_error(filename)
  puts "Sorry, #{filename} doesn't exist."
end

cmd_load_students
interactive_menu
